import 'dart:async';
import 'dart:convert';

import 'package:dio/dio.dart' as dio;
import 'package:flutter/services.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:get/get.dart' hide navigator;
import 'package:permission_handler/permission_handler.dart';

import '../../data/models/realtime_token_model.dart';
import '../../domain/entities/message_entity.dart';
import 'realtime_connection_state.dart';
import 'realtime_transcript_event.dart';

class RealtimeConversationException implements Exception {
  const RealtimeConversationException(this.message);

  final String message;

  @override
  String toString() => message;
}

class RealtimeConversationService extends GetxService {
  static const Duration _playbackMicrophoneCooldown = Duration(
    milliseconds: 2400,
  );
  static const Duration _speakerphoneTailCooldown = Duration(
    milliseconds: 1800,
  );
  static const Duration _maxSpeakerphoneGuard = Duration(seconds: 14);
  static const int _estimatedSpeechMsPerWord = 430;

  final dio.Dio _dio = dio.Dio(
    dio.BaseOptions(
      connectTimeout: const Duration(seconds: 20),
      receiveTimeout: const Duration(seconds: 20),
      sendTimeout: const Duration(seconds: 20),
      responseType: dio.ResponseType.plain,
    ),
  );

  final StreamController<RealtimeConnectionPhase> _phaseController =
      StreamController<RealtimeConnectionPhase>.broadcast();
  final StreamController<RealtimeTranscriptEvent> _transcriptController =
      StreamController<RealtimeTranscriptEvent>.broadcast();

  RTCPeerConnection? _peerConnection;
  RTCDataChannel? _dataChannel;
  MediaStream? _localStream;
  RTCVideoRenderer? _remoteAudioRenderer;
  Timer? _restoreMicrophoneTimer;
  Timer? _manualResponseTimer;

  RealtimeConnectionPhase _phase = RealtimeConnectionPhase.idle;
  bool _microphoneEnabledByUser = true;
  bool _microphoneSuppressedByPlayback = false;
  bool _aiResponseInProgress = false;
  bool _manualResponsePending = false;
  bool _acceptedUserSpeechTurn = false;
  bool _openingResponseSent = false;
  DateTime? _lastAiPlaybackAt;
  DateTime? _currentAiPlaybackStartedAt;
  DateTime? _microphoneLockedUntil;
  String? _lastAiFinalTranscript;
  String? _pendingOpeningMessage;

  Stream<RealtimeConnectionPhase> get phaseStream => _phaseController.stream;
  Stream<RealtimeTranscriptEvent> get transcriptStream =>
      _transcriptController.stream;
  RealtimeConnectionPhase get phase => _phase;
  bool get isConnected => _phase.isLive;

  Future<void> connect(
    RealtimeTokenModel token, {
    String? openingMessage,
  }) async {
    if (token.clientSecret.value.isEmpty) {
      throw const RealtimeConversationException('Realtime token không hợp lệ.');
    }

    await disconnect();
    _emitPhase(RealtimeConnectionPhase.requestingPermission);

    await _ensureMicrophonePermission();

    _emitPhase(RealtimeConnectionPhase.connecting);

    try {
      try {
        await Helper.setSpeakerphoneOn(true);
      } catch (_) {
        // Không chặn flow nếu thiết bị/OS không hỗ trợ chuyển speaker.
      }

      _remoteAudioRenderer = RTCVideoRenderer();
      await _remoteAudioRenderer!.initialize();

      _localStream = await navigator.mediaDevices.getUserMedia(
        <String, dynamic>{
          'audio': <String, dynamic>{
            'echoCancellation': true,
            'noiseSuppression': true,
            'autoGainControl': true,
          },
          'video': false,
        },
      );
      _microphoneEnabledByUser = true;
      _microphoneSuppressedByPlayback = false;
      _aiResponseInProgress = false;
      _manualResponsePending = false;
      _acceptedUserSpeechTurn = false;
      _openingResponseSent = false;
      _lastAiPlaybackAt = null;
      _currentAiPlaybackStartedAt = null;
      _microphoneLockedUntil = null;
      _lastAiFinalTranscript = null;
      _pendingOpeningMessage = openingMessage?.trim();
      _applyLocalMicrophoneState();

      _peerConnection = await createPeerConnection(<String, dynamic>{
        'sdpSemantics': 'unified-plan',
        'iceServers': <Map<String, dynamic>>[],
      }, <String, dynamic>{});

      _peerConnection!
        ..onConnectionState = _handlePeerConnectionState
        ..onIceConnectionState = _handleIceConnectionState
        ..onTrack = (RTCTrackEvent event) {
          if (event.streams.isNotEmpty) {
            _remoteAudioRenderer?.srcObject = event.streams.first;
          }
        };

      _dataChannel = await _peerConnection!.createDataChannel(
        'oai-events',
        RTCDataChannelInit()..ordered = true,
      );
      _dataChannel!
        ..onMessage = _handleDataChannelMessage
        ..onDataChannelState = (RTCDataChannelState state) {
          if (state == RTCDataChannelState.RTCDataChannelOpen) {
            _emitPhase(RealtimeConnectionPhase.connected);
            _requestOpeningResponseIfNeeded();
          }
        };

      for (final MediaStreamTrack track in _localStream!.getAudioTracks()) {
        await _peerConnection!.addTrack(track, _localStream!);
      }

      final RTCSessionDescription offer = await _peerConnection!.createOffer(
        <String, dynamic>{
          'offerToReceiveAudio': true,
          'offerToReceiveVideo': false,
        },
      );
      await _peerConnection!.setLocalDescription(offer);

      final dio.Response<String> answerResponse = await _dio.post<String>(
        'https://api.openai.com/v1/realtime/calls',
        data: offer.sdp,
        options: dio.Options(
          headers: <String, String>{
            'Authorization': 'Bearer ${token.clientSecret.value}',
            'Content-Type': 'application/sdp',
          },
        ),
      );

      final String answerSdp = answerResponse.data ?? '';
      if (answerSdp.trim().isEmpty) {
        throw const RealtimeConversationException(
          'Realtime provider không trả SDP answer.',
        );
      }

      await _peerConnection!.setRemoteDescription(
        RTCSessionDescription(answerSdp, 'answer'),
      );
      _emitPhase(RealtimeConnectionPhase.connected);
      _requestOpeningResponseIfNeeded();
    } on RealtimeConversationException {
      await _resetAfterFailedConnect();
      rethrow;
    } on dio.DioException catch (error) {
      await _resetAfterFailedConnect();
      throw RealtimeConversationException(_messageFromRealtimeHttpError(error));
    } on PlatformException catch (error) {
      await _resetAfterFailedConnect();
      throw RealtimeConversationException(_messageFromPlatformError(error));
    } catch (error) {
      await _resetAfterFailedConnect();
      throw RealtimeConversationException(
        'Không thể khởi tạo WebRTC realtime: $error',
      );
    }
  }

  Future<void> _ensureMicrophonePermission() async {
    final PermissionStatus currentStatus = await Permission.microphone.status;
    final PermissionStatus permission = currentStatus.isGranted
        ? currentStatus
        : await Permission.microphone.request();

    if (permission.isGranted) return;

    _emitPhase(RealtimeConnectionPhase.error);

    if (permission.isPermanentlyDenied || permission.isRestricted) {
      throw const RealtimeConversationException(
        'Quyền microphone đang bị chặn. Hãy vào Settings > Scenio > Microphone để bật lại, hoặc xoá app và cài lại khi test trên simulator.',
      );
    }

    throw const RealtimeConversationException(
      'Bạn cần cấp quyền microphone để bắt đầu đàm thoại.',
    );
  }

  Future<void> _resetAfterFailedConnect() async {
    await disconnect();
    _emitPhase(RealtimeConnectionPhase.error);
  }

  String _messageFromRealtimeHttpError(dio.DioException error) {
    final int? statusCode = error.response?.statusCode;
    final String providerMessage = _providerErrorMessage(error.response?.data);

    if (statusCode == 401 || statusCode == 403) {
      return 'Realtime token không hợp lệ hoặc đã hết hạn. Hãy thoát phiên học rồi mở lại để lấy token mới.';
    }

    if (providerMessage.isNotEmpty) {
      return 'Realtime provider từ chối kết nối: $providerMessage';
    }

    if (statusCode != null) {
      return 'Realtime provider trả lỗi HTTP $statusCode.';
    }

    return 'Không thể kết nối realtime provider. Kiểm tra mạng rồi thử lại.';
  }

  String _providerErrorMessage(Object? data) {
    if (data == null) return '';

    if (data is Map<String, dynamic>) {
      final Object? error = data['error'];
      if (error is Map<String, dynamic>) {
        final Object? message = error['message'];
        if (message is String) return message;
      }

      final Object? message = data['message'];
      if (message is String) return message;
      return '';
    }

    if (data is String && data.trim().isNotEmpty) {
      try {
        final Object? decoded = jsonDecode(data);
        return _providerErrorMessage(decoded);
      } catch (_) {
        return data.trim();
      }
    }

    return '';
  }

  String _messageFromPlatformError(PlatformException error) {
    final String code = error.code.toLowerCase();
    final String message = (error.message ?? '').toLowerCase();

    if (code.contains('permission') || message.contains('permission')) {
      return 'Microphone chưa được cấp quyền. Hãy bật quyền mic trong Settings rồi mở lại voice realtime.';
    }

    if (message.contains('audio') || message.contains('microphone')) {
      return 'Không mở được microphone trên thiết bị hiện tại. Hãy kiểm tra input audio của simulator hoặc thử chạy trên máy thật.';
    }

    return 'Lỗi native khi mở voice realtime: ${error.message ?? error.code}';
  }

  Future<void> setMicrophoneEnabled(bool enabled) async {
    _microphoneEnabledByUser = enabled;
    _applyLocalMicrophoneState();
    _emitPhase(
      enabled
          ? RealtimeConnectionPhase.connected
          : RealtimeConnectionPhase.paused,
    );
  }

  void _suppressMicrophoneForPlayback() {
    if (!_microphoneEnabledByUser) return;

    _currentAiPlaybackStartedAt ??= DateTime.now();
    _aiResponseInProgress = true;
    _restoreMicrophoneTimer?.cancel();
    _extendMicrophoneLock(_playbackMicrophoneCooldown);
    if (!_microphoneSuppressedByPlayback) {
      _microphoneSuppressedByPlayback = true;
      _applyLocalMicrophoneState();
    }
  }

  void _restoreMicrophoneAfterPlayback({String? aiTranscript}) {
    _lastAiPlaybackAt = DateTime.now();
    _extendMicrophoneLock(
      aiTranscript == null
          ? _playbackMicrophoneCooldown
          : _estimatedRemainingPlaybackGuard(aiTranscript),
    );
    _scheduleMicrophoneRestore();
  }

  void _extendMicrophoneLock(Duration duration) {
    final DateTime nextLockUntil = DateTime.now().add(duration);
    final DateTime? currentLockUntil = _microphoneLockedUntil;
    if (currentLockUntil == null || nextLockUntil.isAfter(currentLockUntil)) {
      _microphoneLockedUntil = nextLockUntil;
    }
  }

  Duration _estimatedRemainingPlaybackGuard(String aiTranscript) {
    final int wordCount = _normalizedWords(aiTranscript).length;
    final int estimatedSpeechMs = (wordCount * _estimatedSpeechMsPerWord)
        .clamp(
          _playbackMicrophoneCooldown.inMilliseconds,
          _maxSpeakerphoneGuard.inMilliseconds,
        )
        .toInt();
    final DateTime? startedAt = _currentAiPlaybackStartedAt;
    final int elapsedMs = startedAt == null
        ? 0
        : DateTime.now().difference(startedAt).inMilliseconds;
    final int remainingMs = (estimatedSpeechMs - elapsedMs)
        .clamp(0, _maxSpeakerphoneGuard.inMilliseconds)
        .toInt();

    return Duration(
      milliseconds: remainingMs + _speakerphoneTailCooldown.inMilliseconds,
    );
  }

  bool get _isPlaybackGuardActive {
    final DateTime? lockedUntil = _microphoneLockedUntil;
    return lockedUntil != null && DateTime.now().isBefore(lockedUntil);
  }

  void _scheduleMicrophoneRestore() {
    _restoreMicrophoneTimer?.cancel();
    final DateTime? lockedUntil = _microphoneLockedUntil;
    final Duration restoreDelay = lockedUntil == null
        ? _playbackMicrophoneCooldown
        : lockedUntil.difference(DateTime.now());

    _restoreMicrophoneTimer = Timer(
      restoreDelay.isNegative ? Duration.zero : restoreDelay,
      () {
        if (_isPlaybackGuardActive) {
          _scheduleMicrophoneRestore();
          return;
        }

        _restoreMicrophoneTimer = null;
        _aiResponseInProgress = false;
        _currentAiPlaybackStartedAt = null;
        _microphoneLockedUntil = null;
        _clearRealtimeInputBuffer();
        _microphoneSuppressedByPlayback = false;
        _applyLocalMicrophoneState();
        if (_microphoneEnabledByUser && isConnected) {
          _emitPhase(RealtimeConnectionPhase.connected);
        }
      },
    );
  }

  void _scheduleManualResponseCreate(String userTranscript) {
    if (_aiResponseInProgress ||
        _microphoneSuppressedByPlayback ||
        _isPlaybackGuardActive ||
        _manualResponsePending ||
        !_acceptedUserSpeechTurn ||
        !_isValidUserTurnTranscript(userTranscript)) {
      return;
    }

    _manualResponsePending = true;
    _manualResponseTimer?.cancel();
    _manualResponseTimer = Timer(const Duration(milliseconds: 260), () {
      _manualResponseTimer = null;
      if (_aiResponseInProgress || _microphoneSuppressedByPlayback) {
        _manualResponsePending = false;
        return;
      }

      _suppressMicrophoneForPlayback();
      _sendRealtimeClientEvent(<String, dynamic>{'type': 'response.create'});
      _emitPhase(RealtimeConnectionPhase.aiThinking);
    });
  }

  void _requestOpeningResponseIfNeeded() {
    final String openingMessage = _pendingOpeningMessage?.trim() ?? '';
    if (openingMessage.isEmpty || _openingResponseSent) return;

    final RTCDataChannel? dataChannel = _dataChannel;
    if (dataChannel == null ||
        dataChannel.state != RTCDataChannelState.RTCDataChannelOpen) {
      return;
    }

    _openingResponseSent = true;
    _suppressMicrophoneForPlayback();
    _sendRealtimeClientEvent(<String, dynamic>{
      'type': 'response.create',
      'response': <String, dynamic>{
        'modalities': <String>['audio'],
        'instructions':
            'Start this session now by saying exactly this opening line, without adding anything else: "$openingMessage"',
      },
    });
    _emitPhase(RealtimeConnectionPhase.aiThinking);
  }

  bool _isValidUserTurnTranscript(String content) {
    final String normalized = content.trim();
    if (normalized.length < 2) return false;

    final DateTime? lastAiPlaybackAt = _lastAiPlaybackAt;
    if (lastAiPlaybackAt == null) return true;
    if (_isPlaybackGuardActive) return false;

    final Duration sinceAiPlayback = DateTime.now().difference(
      lastAiPlaybackAt,
    );
    return sinceAiPlayback > _playbackMicrophoneCooldown;
  }

  void _applyLocalMicrophoneState() {
    final MediaStream? stream = _localStream;
    if (stream == null) return;

    final bool enabled =
        _microphoneEnabledByUser &&
        !_microphoneSuppressedByPlayback &&
        !_isPlaybackGuardActive;
    for (final MediaStreamTrack track in stream.getAudioTracks()) {
      track.enabled = enabled;
    }
  }

  void _clearRealtimeInputBuffer() {
    _sendRealtimeClientEvent(<String, dynamic>{
      'type': 'input_audio_buffer.clear',
    });
  }

  void _sendRealtimeClientEvent(Map<String, dynamic> event) {
    final RTCDataChannel? dataChannel = _dataChannel;
    if (dataChannel == null ||
        dataChannel.state != RTCDataChannelState.RTCDataChannelOpen) {
      return;
    }

    dataChannel.send(RTCDataChannelMessage(jsonEncode(event)));
  }

  Future<void> disconnect() async {
    _restoreMicrophoneTimer?.cancel();
    _manualResponseTimer?.cancel();
    _restoreMicrophoneTimer = null;
    _manualResponseTimer = null;
    _microphoneEnabledByUser = true;
    _microphoneSuppressedByPlayback = false;
    _aiResponseInProgress = false;
    _manualResponsePending = false;
    _acceptedUserSpeechTurn = false;
    _openingResponseSent = false;
    _lastAiPlaybackAt = null;
    _currentAiPlaybackStartedAt = null;
    _microphoneLockedUntil = null;
    _lastAiFinalTranscript = null;
    _pendingOpeningMessage = null;

    if (_phase != RealtimeConnectionPhase.idle) {
      _emitPhase(RealtimeConnectionPhase.finishing);
    }

    _dataChannel
      ?..onMessage = null
      ..onDataChannelState = null
      ..onBufferedAmountChange = null
      ..onBufferedAmountLow = null;
    _dataChannel = null;

    await _peerConnection?.close();
    await _peerConnection?.dispose();
    _peerConnection = null;

    final MediaStream? stream = _localStream;
    if (stream != null) {
      for (final MediaStreamTrack track in stream.getTracks()) {
        await track.stop();
      }
      await stream.dispose();
    }
    _localStream = null;

    _remoteAudioRenderer?.srcObject = null;
    await _remoteAudioRenderer?.dispose();
    _remoteAudioRenderer = null;

    _emitPhase(RealtimeConnectionPhase.idle);
  }

  void _handlePeerConnectionState(RTCPeerConnectionState state) {
    switch (state) {
      case RTCPeerConnectionState.RTCPeerConnectionStateConnected:
        _emitPhase(RealtimeConnectionPhase.connected);
        break;
      case RTCPeerConnectionState.RTCPeerConnectionStateConnecting:
        _emitPhase(RealtimeConnectionPhase.connecting);
        break;
      case RTCPeerConnectionState.RTCPeerConnectionStateDisconnected:
        _emitPhase(RealtimeConnectionPhase.reconnecting);
        break;
      case RTCPeerConnectionState.RTCPeerConnectionStateFailed:
        _emitPhase(RealtimeConnectionPhase.error);
        break;
      case RTCPeerConnectionState.RTCPeerConnectionStateClosed:
        _emitPhase(RealtimeConnectionPhase.completed);
        break;
      case RTCPeerConnectionState.RTCPeerConnectionStateNew:
        break;
    }
  }

  void _handleIceConnectionState(RTCIceConnectionState state) {
    if (state == RTCIceConnectionState.RTCIceConnectionStateChecking) {
      _emitPhase(RealtimeConnectionPhase.connecting);
    }
    if (state == RTCIceConnectionState.RTCIceConnectionStateFailed) {
      _emitPhase(RealtimeConnectionPhase.error);
    }
  }

  void _handleDataChannelMessage(RTCDataChannelMessage message) {
    if (message.isBinary) return;

    final Object? decoded = jsonDecode(message.text);
    if (decoded is! Map<String, dynamic>) return;

    final String type = decoded['type'] as String? ?? '';

    switch (type) {
      case 'input_audio_buffer.speech_started':
        if (_microphoneSuppressedByPlayback ||
            _aiResponseInProgress ||
            _isPlaybackGuardActive) {
          _clearRealtimeInputBuffer();
          return;
        }
        _manualResponseTimer?.cancel();
        _manualResponseTimer = null;
        _manualResponsePending = false;
        _acceptedUserSpeechTurn = true;
        _emitPhase(RealtimeConnectionPhase.userSpeaking);
        return;
      case 'input_audio_buffer.speech_stopped':
      case 'input_audio_buffer.committed':
        if (_microphoneSuppressedByPlayback ||
            _aiResponseInProgress ||
            _isPlaybackGuardActive) {
          _clearRealtimeInputBuffer();
          return;
        }
        return;
      case 'response.created':
        _acceptedUserSpeechTurn = false;
        _manualResponsePending = false;
        _suppressMicrophoneForPlayback();
        _emitPhase(RealtimeConnectionPhase.aiThinking);
        return;
      case 'response.audio.delta':
      case 'response.output_audio.delta':
        _suppressMicrophoneForPlayback();
        _emitPhase(RealtimeConnectionPhase.aiSpeaking);
        return;
      case 'response.audio.done':
      case 'response.output_audio.done':
        _restoreMicrophoneAfterPlayback();
        return;
      case 'response.done':
        _acceptedUserSpeechTurn = false;
        _manualResponsePending = false;
        _restoreMicrophoneAfterPlayback(aiTranscript: _lastAiFinalTranscript);
        _emitPhase(RealtimeConnectionPhase.aiSpeaking);
        return;
      case 'error':
        _manualResponsePending = false;
        _emitPhase(RealtimeConnectionPhase.error);
        return;
    }

    final RealtimeTranscriptEvent? transcriptEvent = _mapTranscriptEvent(
      decoded,
    );
    if (transcriptEvent != null) {
      if (transcriptEvent.author == MessageAuthor.user) {
        if (_aiResponseInProgress ||
            _microphoneSuppressedByPlayback ||
            _isPlaybackGuardActive ||
            !_acceptedUserSpeechTurn) {
          _clearRealtimeInputBuffer();
          return;
        }

        if (transcriptEvent.isFinal) {
          if (_looksLikeEchoedAiSpeech(transcriptEvent.content)) {
            _acceptedUserSpeechTurn = false;
            _clearRealtimeInputBuffer();
            return;
          }
          _scheduleManualResponseCreate(transcriptEvent.content);
        }
      }

      _transcriptController.add(transcriptEvent);
      if (transcriptEvent.author == MessageAuthor.ai) {
        _suppressMicrophoneForPlayback();
        if (transcriptEvent.isFinal) {
          _lastAiFinalTranscript = transcriptEvent.content;
          _restoreMicrophoneAfterPlayback(
            aiTranscript: transcriptEvent.content,
          );
        }
        _emitPhase(
          transcriptEvent.isFinal
              ? RealtimeConnectionPhase.aiSpeaking
              : RealtimeConnectionPhase.aiSpeaking,
        );
      }
    }
  }

  bool _looksLikeEchoedAiSpeech(String userTranscript) {
    final String? aiTranscript = _lastAiFinalTranscript;
    if (aiTranscript == null || aiTranscript.trim().isEmpty) return false;

    final List<String> userWords = _normalizedWords(userTranscript);
    final List<String> aiWords = _normalizedWords(aiTranscript);
    if (userWords.length < 3 || aiWords.length < 3) return false;

    final Set<String> userSet = userWords.toSet();
    final Set<String> aiSet = aiWords.toSet();
    final int shared = userSet.intersection(aiSet).length;
    final double overlap = shared / userSet.length;

    final String normalizedUser = userWords.join(' ');
    final String normalizedAi = aiWords.join(' ');

    return overlap >= 0.68 ||
        normalizedAi.contains(normalizedUser) ||
        normalizedUser.contains(normalizedAi);
  }

  List<String> _normalizedWords(String value) {
    return value
        .toLowerCase()
        .replaceAll(RegExp(r"[^a-z0-9\s']"), ' ')
        .split(RegExp(r'\s+'))
        .where((String word) => word.length > 1)
        .toList(growable: false);
  }

  RealtimeTranscriptEvent? _mapTranscriptEvent(Map<String, dynamic> event) {
    final String type = event['type'] as String? ?? '';
    final bool isUserTranscript =
        type == 'conversation.item.input_audio_transcription.completed';
    final bool isAiPartial =
        type == 'response.audio_transcript.delta' ||
        type == 'response.output_audio_transcript.delta' ||
        type == 'response.text.delta' ||
        type == 'response.output_text.delta';
    final bool isAiFinal =
        type == 'response.audio_transcript.done' ||
        type == 'response.output_audio_transcript.done' ||
        type == 'response.text.done' ||
        type == 'response.output_text.done';

    if (!isUserTranscript && !isAiPartial && !isAiFinal) {
      return null;
    }

    final String content =
        _firstString(event, <String>[
          'transcript',
          'delta',
          'text',
          'content',
        ]) ??
        '';
    if (content.trim().isEmpty) return null;

    return RealtimeTranscriptEvent(
      author: isUserTranscript ? MessageAuthor.user : MessageAuthor.ai,
      content: content.trim(),
      isFinal: isUserTranscript || isAiFinal,
      providerEventId: _firstString(event, <String>[
        'event_id',
        'eventId',
        'item_id',
        'response_id',
      ]),
      audioStartMs: _firstInt(event, 'audio_start_ms'),
      audioEndMs: _firstInt(event, 'audio_end_ms'),
    );
  }

  String? _firstString(Map<String, dynamic> map, List<String> keys) {
    for (final String key in keys) {
      final dynamic value = map[key];
      if (value is String && value.trim().isNotEmpty) {
        return value;
      }
    }
    return null;
  }

  int? _firstInt(Map<String, dynamic> map, String key) {
    final dynamic value = map[key];
    if (value is num) return value.toInt();
    if (value is String) return int.tryParse(value);
    return null;
  }

  void _emitPhase(RealtimeConnectionPhase phase) {
    if (_phase == phase) return;
    _phase = phase;
    if (!_phaseController.isClosed) {
      _phaseController.add(phase);
    }
  }

  @override
  void onClose() {
    unawaited(disconnect());
    unawaited(_phaseController.close());
    unawaited(_transcriptController.close());
    super.onClose();
  }
}
