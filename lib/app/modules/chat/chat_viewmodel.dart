import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../core/constants/app_strings.dart';
import '../../core/utils/scenio_alerts.dart';
import '../../domain/entities/message_entity.dart';
import '../../domain/entities/scene_entity.dart';
import '../../domain/entities/session_entity.dart';
import '../../routes/app_routes.dart';
import '../home/home_viewmodel.dart';

class ChatViewModel extends GetxController {
  final HomeViewModel homeViewModel = Get.find<HomeViewModel>();
  final TextEditingController composerController = TextEditingController();
  final RxBool isTranscriptExpanded = false.obs;
  final RxBool isSubmitting = false.obs;
  final RxBool canSendReply = false.obs;

  SceneEntity get scene => homeViewModel.currentSessionScene!;
  SessionEntity get session => homeViewModel.currentSession!;
  RxList<MessageEntity> get messages => homeViewModel.activeMessages;
  Rx<PracticeRealtimeState> get practiceState => homeViewModel.practiceState;

  bool get hasActiveSession => homeViewModel.hasActiveSession;
  String get latestAiCaption => _lastMessageFor(MessageAuthor.ai);
  String get latestUserCaption => _lastMessageFor(MessageAuthor.user);

  @override
  void onInit() {
    super.onInit();
    if (!homeViewModel.hasActiveSession) {
      Future<void>.microtask(() => Get.offAllNamed(Routes.home));
    }
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

  void showVoiceComingSoon() {
    ScenioAlert.show(
      title: 'Scenio',
      message: AppStrings.practiceVoiceSnackbar,
    );
  }

  void leaveSession() {
    homeViewModel.abandonCurrentSession();
    Get.offAllNamed(Routes.home);
  }

  void finishSession() {
    unawaited(_finishSession());
  }

  Future<void> _finishSession() async {
    try {
      final SessionResultEntity result = await homeViewModel
          .completeCurrentSession();
      Get.offNamed(Routes.sessionResult, arguments: result);
    } catch (_) {
      ScenioAlert.show(
        title: 'Scenio',
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
        return AppStrings.practiceStateListening;
      case PracticeRealtimeState.active:
        return AppStrings.practiceStateListening;
      case PracticeRealtimeState.userTyping:
        return AppStrings.practiceStateTyping;
      case PracticeRealtimeState.userListening:
        return AppStrings.practiceStateListening;
      case PracticeRealtimeState.aiThinking:
        return AppStrings.practiceStateThinking;
      case PracticeRealtimeState.aiSpeaking:
        return AppStrings.practiceStateSpeaking;
      case PracticeRealtimeState.paused:
        return AppStrings.practiceStatePaused;
    }
  }

  String _lastMessageFor(MessageAuthor author) {
    for (final MessageEntity message in messages.reversed) {
      if (message.author == author) return message.text;
    }
    return author == MessageAuthor.ai ? scene.starterPrompt : '...';
  }

  @override
  void onClose() {
    composerController.dispose();
    super.onClose();
  }
}
