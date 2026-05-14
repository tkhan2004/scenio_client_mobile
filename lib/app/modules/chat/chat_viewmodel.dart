import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../core/constants/app_strings.dart';
import '../../core/network/api_response.dart';
import '../../core/realtime/realtime_connection_state.dart';
import '../../core/realtime/realtime_conversation_service.dart';
import '../../core/realtime/realtime_transcript_event.dart';
import '../../core/utils/scenio_alerts.dart';
import '../../data/models/realtime_token_model.dart';
import '../../domain/entities/message_entity.dart';
import '../../domain/entities/scene_entity.dart';
import '../../domain/entities/session_entity.dart';
import '../../domain/repositories/vocab_repository.dart';
import '../../routes/app_routes.dart';
import '../home/home_viewmodel.dart';

class ChatViewModel extends GetxController {
  final HomeViewModel homeViewModel = Get.find<HomeViewModel>();
  final RealtimeConversationService realtimeService =
      Get.find<RealtimeConversationService>();
  final VocabRepository vocabRepository = Get.find<VocabRepository>();
  final TextEditingController composerController = TextEditingController();
  final RxBool isTranscriptExpanded = false.obs;
  final RxBool isSubmitting = false.obs;
  final RxBool canSendReply = false.obs;
  final RxBool isVoiceSessionActive = false.obs;
  final RxBool isVoiceConnecting = false.obs;
  final RxBool isMicMuted = false.obs;
  final RxBool showEntryGuide = true.obs;
  final RxString partialAiCaption = ''.obs;
  final RxString partialUserCaption = ''.obs;

  StreamSubscription<RealtimeConnectionPhase>? _phaseSubscription;
  StreamSubscription<RealtimeTranscriptEvent>? _transcriptSubscription;
  Timer? _entryGuideTimer;
  Timer? _phaseSettleTimer;
  Timer? _aiCaptionSettleTimer;
  Timer? _userCaptionSettleTimer;
  PracticeRealtimeState? _pendingPracticeState;
  String? _pendingAiCaption;
  String? _pendingUserCaption;
  final Set<String> _syncedProviderEvents = <String>{};

  SceneEntity get scene =>
      homeViewModel.currentSessionScene ?? _sceneFromActiveSession();
  SessionEntity get session => homeViewModel.currentSession!;
  RxList<MessageEntity> get messages => homeViewModel.activeMessages;
  Rx<PracticeRealtimeState> get practiceState => homeViewModel.practiceState;

  bool get hasActiveSession => homeViewModel.hasActiveSession;
  bool get canRenderSession => homeViewModel.currentSession != null;
  String get latestAiCaption => partialAiCaption.value.isNotEmpty
      ? partialAiCaption.value
      : _lastMessageFor(MessageAuthor.ai);
  String get latestUserCaption => partialUserCaption.value.isNotEmpty
      ? partialUserCaption.value
      : _lastMessageFor(MessageAuthor.user);
  String get voiceStatusText => isVoiceSessionActive.value
      ? isMicMuted.value
            ? AppStrings.practiceVoiceStatusMuted
            : AppStrings.practiceVoiceStatusLive
      : AppStrings.practiceVoiceStatusIdle.replaceFirst(
          '{name}',
          scene.characterName,
        );

  @override
  void onInit() {
    super.onInit();
    if (!homeViewModel.hasActiveSession) {
      Future<void>.microtask(() => Get.offAllNamed(Routes.home));
    }
    _entryGuideTimer = Timer(const Duration(milliseconds: 1150), () {
      if (!isClosed) {
        showEntryGuide.value = false;
      }
    });
    _phaseSubscription = realtimeService.phaseStream.listen(_handleVoicePhase);
    _transcriptSubscription = realtimeService.transcriptStream.listen(
      _handleRealtimeTranscript,
    );
  }

  void onComposerChanged(String value) {
    if (practiceState.value == PracticeRealtimeState.aiThinking ||
        practiceState.value == PracticeRealtimeState.aiSpeaking) {
      return;
    }

    homeViewModel.setPracticeState(
      value.trim().isEmpty
          ? PracticeRealtimeState.userListening
          : PracticeRealtimeState.userTyping,
    );
    canSendReply.value = value.trim().isNotEmpty;
  }

  void toggleTranscript() {
    isTranscriptExpanded.value = !isTranscriptExpanded.value;
  }

  Future<void> sendReply() async {
    final String text = composerController.text.trim();
    if (text.isEmpty || !hasActiveSession) return;

    isSubmitting.value = true;
    canSendReply.value = false;
    composerController.clear();
    await homeViewModel.submitPracticeReply(text);
    isSubmitting.value = false;
  }

  void showHint() {
    homeViewModel.requestHint();
  }

  Future<void> saveVocabularyCandidate({
    required String word,
    required MessageEntity message,
  }) async {
    final String normalizedWord = word.trim().toLowerCase();
    if (normalizedWord.isEmpty || !hasActiveSession) return;

    try {
      await vocabRepository.saveManualVocabulary(
        word: normalizedWord,
        definition: 'A word saved from your practice transcript for review.',
        sourceSessionId: session.id,
        sourceMessageId: message.id,
        sampleSentence: message.text,
      );
      ScenioAlert.show(
        title: AppStrings.appName,
        message: AppStrings.practiceVocabularySaved.replaceFirst(
          '{word}',
          normalizedWord,
        ),
        isSuccess: true,
      );
    } catch (_) {
      ScenioAlert.show(
        title: AppStrings.appName,
        message: AppStrings.practiceVocabularySaveError,
        isError: true,
      );
    }
  }

  void toggleVoiceSession() {
    unawaited(_toggleVoiceSession());
  }

  Future<void> _toggleVoiceSession() async {
    if (isVoiceConnecting.value || !hasActiveSession) return;

    if (isVoiceSessionActive.value) {
      await realtimeService.disconnect();
      isVoiceSessionActive.value = false;
      isMicMuted.value = false;
      homeViewModel.setPracticeState(PracticeRealtimeState.userListening);
      return;
    }

    isVoiceConnecting.value = true;
    homeViewModel.setPracticeState(PracticeRealtimeState.requestingPermission);

    try {
      final RealtimeTokenModel token = await homeViewModel
          .createRealtimeTokenForCurrentSession();
      await realtimeService.connect(token);
      isVoiceSessionActive.value = true;
      isMicMuted.value = false;
      ScenioAlert.show(
        title: AppStrings.appName,
        message: AppStrings.practiceVoiceReadySnackbar,
        isSuccess: true,
      );
    } on ApiException catch (error) {
      _handleVoiceStartError(error.message);
    } on RealtimeConversationException catch (error) {
      _handleVoiceStartError(error.message);
    } catch (error) {
      _handleVoiceStartError(
        '${AppStrings.practiceVoiceFallbackError}\n$error',
      );
    } finally {
      isVoiceConnecting.value = false;
    }
  }

  void toggleMicMute() {
    unawaited(_toggleMicMute());
  }

  Future<void> _toggleMicMute() async {
    if (!isVoiceSessionActive.value) return;
    final bool nextMuted = !isMicMuted.value;
    await realtimeService.setMicrophoneEnabled(!nextMuted);
    isMicMuted.value = nextMuted;
  }

  void leaveSession() {
    unawaited(realtimeService.disconnect());
    homeViewModel.abandonCurrentSession();
    Get.offAllNamed(Routes.home);
  }

  void finishSession() {
    unawaited(_finishSession());
  }

  Future<void> _finishSession() async {
    try {
      await realtimeService.disconnect();
      final SessionResultEntity result = await homeViewModel
          .completeCurrentSession();
      Get.offNamed(Routes.sessionResult, arguments: result);
    } catch (_) {
      ScenioAlert.show(
        title: AppStrings.appName,
        message: 'Chưa thể hoàn tất buổi luyện lúc này.',
        isError: true,
      );
    }
  }

  String labelForState(PracticeRealtimeState state) {
    switch (state) {
      case PracticeRealtimeState.idle:
        return AppStrings.practiceStateIdle;
      case PracticeRealtimeState.starting:
      case PracticeRealtimeState.requestingPermission:
        return AppStrings.practiceStateRequestingMic;
      case PracticeRealtimeState.connecting:
        return AppStrings.practiceStateConnecting;
      case PracticeRealtimeState.active:
      case PracticeRealtimeState.userListening:
        return AppStrings.practiceStateListening;
      case PracticeRealtimeState.userTyping:
        return AppStrings.practiceStateTyping;
      case PracticeRealtimeState.userSpeaking:
        return AppStrings.practiceStateUserSpeaking;
      case PracticeRealtimeState.aiThinking:
        return AppStrings.practiceStateThinking;
      case PracticeRealtimeState.aiSpeaking:
        return AppStrings.practiceStateSpeaking;
      case PracticeRealtimeState.reconnecting:
        return AppStrings.practiceStateReconnecting;
      case PracticeRealtimeState.paused:
        return AppStrings.practiceStatePaused;
      case PracticeRealtimeState.finishing:
        return AppStrings.practiceStateFinishing;
      case PracticeRealtimeState.completed:
        return AppStrings.practiceStateCompleted;
      case PracticeRealtimeState.error:
        return AppStrings.practiceStateVoiceError;
    }
  }

  void _handleVoicePhase(RealtimeConnectionPhase phase) {
    switch (phase) {
      case RealtimeConnectionPhase.idle:
        if (isVoiceSessionActive.value) {
          _setPracticeStateSmooth(PracticeRealtimeState.userListening);
        }
        break;
      case RealtimeConnectionPhase.requestingPermission:
        _setPracticeStateSmooth(
          PracticeRealtimeState.requestingPermission,
          immediate: true,
        );
        break;
      case RealtimeConnectionPhase.connecting:
        _setPracticeStateSmooth(
          PracticeRealtimeState.connecting,
          immediate: true,
        );
        break;
      case RealtimeConnectionPhase.connected:
        _setPracticeStateSmooth(PracticeRealtimeState.userListening);
        break;
      case RealtimeConnectionPhase.userSpeaking:
        _setPracticeStateSmooth(PracticeRealtimeState.userSpeaking);
        break;
      case RealtimeConnectionPhase.aiThinking:
        _setPracticeStateSmooth(PracticeRealtimeState.aiThinking);
        break;
      case RealtimeConnectionPhase.aiSpeaking:
        _setPracticeStateSmooth(PracticeRealtimeState.aiSpeaking);
        break;
      case RealtimeConnectionPhase.reconnecting:
        _setPracticeStateSmooth(
          PracticeRealtimeState.reconnecting,
          immediate: true,
        );
        break;
      case RealtimeConnectionPhase.paused:
        _setPracticeStateSmooth(PracticeRealtimeState.paused, immediate: true);
        break;
      case RealtimeConnectionPhase.finishing:
        _setPracticeStateSmooth(
          PracticeRealtimeState.finishing,
          immediate: true,
        );
        break;
      case RealtimeConnectionPhase.completed:
        _setPracticeStateSmooth(
          PracticeRealtimeState.completed,
          immediate: true,
        );
        isVoiceSessionActive.value = false;
        break;
      case RealtimeConnectionPhase.error:
        _setPracticeStateSmooth(PracticeRealtimeState.error, immediate: true);
        isVoiceSessionActive.value = false;
        break;
    }
  }

  void _handleRealtimeTranscript(RealtimeTranscriptEvent event) {
    if (event.author == MessageAuthor.user) {
      _setUserCaptionSmooth(event.isFinal ? '' : event.content);
    } else {
      _setAiCaptionSmooth(event.isFinal ? '' : event.content);
    }

    if (!event.isFinal || event.content.trim().isEmpty) return;

    final String? eventId = event.providerEventId;
    if (eventId != null && !_syncedProviderEvents.add(eventId)) {
      return;
    }

    homeViewModel.appendRealtimeTranscriptMessage(
      author: event.author,
      content: event.content,
      providerEventId: eventId,
    );
    unawaited(
      homeViewModel.syncAudioTranscript(
        author: event.author,
        content: event.content,
        providerEventId: event.providerEventId,
        audioStartMs: event.audioStartMs,
        audioEndMs: event.audioEndMs,
      ),
    );
  }

  void _handleVoiceStartError(String message) {
    isVoiceSessionActive.value = false;
    isMicMuted.value = false;
    _setPracticeStateSmooth(
      PracticeRealtimeState.userListening,
      immediate: true,
    );
    ScenioAlert.show(
      title: AppStrings.appName,
      message: message,
      isError: true,
    );
  }

  void _setPracticeStateSmooth(
    PracticeRealtimeState state, {
    bool immediate = false,
  }) {
    if (practiceState.value == state) return;

    _pendingPracticeState = state;

    if (immediate) {
      _phaseSettleTimer?.cancel();
      _phaseSettleTimer = null;
      homeViewModel.setPracticeState(state);
      return;
    }

    _phaseSettleTimer ??= Timer(const Duration(milliseconds: 180), () {
      _phaseSettleTimer = null;
      final PracticeRealtimeState? nextState = _pendingPracticeState;
      _pendingPracticeState = null;
      if (nextState != null && practiceState.value != nextState) {
        homeViewModel.setPracticeState(nextState);
      }
    });
  }

  void _setAiCaptionSmooth(String caption) {
    _pendingAiCaption = caption;
    _aiCaptionSettleTimer ??= Timer(const Duration(milliseconds: 120), () {
      _aiCaptionSettleTimer = null;
      final String nextCaption = _pendingAiCaption ?? '';
      _pendingAiCaption = null;
      if (partialAiCaption.value != nextCaption) {
        partialAiCaption.value = nextCaption;
      }
    });
  }

  void _setUserCaptionSmooth(String caption) {
    _pendingUserCaption = caption;
    _userCaptionSettleTimer ??= Timer(const Duration(milliseconds: 120), () {
      _userCaptionSettleTimer = null;
      final String nextCaption = _pendingUserCaption ?? '';
      _pendingUserCaption = null;
      if (partialUserCaption.value != nextCaption) {
        partialUserCaption.value = nextCaption;
      }
    });
  }

  String _lastMessageFor(MessageAuthor author) {
    for (final MessageEntity message in messages.reversed) {
      if (message.author == author) return message.text;
    }
    return author == MessageAuthor.ai ? scene.starterPrompt : '...';
  }

  SceneEntity _sceneFromActiveSession() {
    final SessionEntity? activeSession = homeViewModel.currentSession;
    if (activeSession == null) {
      return homeViewModel.heroScene;
    }

    return SceneEntity(
      id: activeSession.sceneId,
      title: activeSession.sceneTitle,
      category: SceneCategory.dailyLife,
      description: activeSession.mission,
      mission: activeSession.mission,
      difficulty: _difficultyFromLabel(activeSession.difficultyLabel),
      estimatedMinutes: 0,
      characterName: activeSession.characterName,
      characterRole: activeSession.characterRole,
      vocabularyPreview: const <String>[],
      starterPrompt: '',
      aiReplyPool: const <String>[],
    );
  }

  SceneDifficulty _difficultyFromLabel(String label) {
    switch (label.toUpperCase()) {
      case 'A1':
        return SceneDifficulty.a1;
      case 'B1':
        return SceneDifficulty.b1;
      case 'B2':
        return SceneDifficulty.b2;
      case 'A2':
      default:
        return SceneDifficulty.a2;
    }
  }

  @override
  void onClose() {
    _entryGuideTimer?.cancel();
    _phaseSettleTimer?.cancel();
    _aiCaptionSettleTimer?.cancel();
    _userCaptionSettleTimer?.cancel();
    unawaited(_phaseSubscription?.cancel());
    unawaited(_transcriptSubscription?.cancel());
    unawaited(realtimeService.disconnect());
    composerController.dispose();
    super.onClose();
  }
}
