import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../core/constants/app_colors.dart';
import '../../core/constants/app_dimensions.dart';
import '../../core/constants/app_strings.dart';
import '../../core/constants/app_text_styles.dart';
import '../../domain/entities/session_entity.dart';
import 'chat_viewmodel.dart';
import 'widgets/practice_caption_strip.dart';
import 'widgets/practice_control_bar.dart';
import 'widgets/practice_stage.dart';
import 'widgets/practice_transcript_panel.dart';

class ChatView extends GetView<ChatViewModel> {
  const ChatView({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (!controller.hasActiveSession || !controller.canRenderSession) {
        return const SizedBox.shrink();
      }

      return Scaffold(
        backgroundColor: AppColors.background,
        body: Stack(
          children: <Widget>[
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: <Color>[
                    AppColors.primary900,
                    AppColors.primary800,
                    AppColors.background,
                  ],
                  stops: const <double>[0.0, 0.34, 0.76],
                ),
              ),
              child: SafeArea(
                bottom: false,
                child: Column(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.fromLTRB(
                        AppDimensions.xxl,
                        AppDimensions.lg,
                        AppDimensions.xxl,
                        AppDimensions.lg,
                      ),
                      child: Column(
                        children: <Widget>[
                          Row(
                            children: <Widget>[
                              _HeaderIconButton(
                                icon: Icons.arrow_back_ios_new_rounded,
                                onTap: controller.leaveSession,
                              ),
                              const SizedBox(width: AppDimensions.md),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Text(
                                      controller.scene.title,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: AppTextStyles.h2.copyWith(
                                        color: Colors.white,
                                      ),
                                    ),
                                    const SizedBox(height: 2),
                                    Text(
                                      '${controller.scene.characterName} • ${controller.scene.characterRole} • ${controller.scene.difficultyLabel}',
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: AppTextStyles.bodySmall.copyWith(
                                        color: Colors.white.withValues(
                                          alpha: 0.74,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(width: AppDimensions.md),
                              _HeaderTextButton(
                                label: AppStrings.practiceHintButton,
                                onTap: controller.showHint,
                              ),
                              SizedBox(width: AppDimensions.sm),
                              _HeaderTextButton(
                                label: AppStrings.practiceLeaveButton,
                                onTap: controller.leaveSession,
                              ),
                            ],
                          ),
                          const SizedBox(height: AppDimensions.lg),
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(AppDimensions.md),
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: 0.12),
                              borderRadius: BorderRadius.circular(
                                AppDimensions.radiusLg,
                              ),
                              border: Border.all(
                                color: Colors.white.withValues(alpha: 0.16),
                              ),
                            ),
                            child: Text(
                              controller.scene.mission,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: AppTextStyles.bodySmall.copyWith(
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: SingleChildScrollView(
                        physics: const ClampingScrollPhysics(),
                        padding: const EdgeInsets.fromLTRB(
                          AppDimensions.xxl,
                          0,
                          AppDimensions.xxl,
                          AppDimensions.md,
                        ),
                        child: Column(
                          children: <Widget>[
                            Obx(() {
                              final PracticeRealtimeState state =
                                  controller.practiceState.value;

                              return PracticeStage(
                                aiInitials: controller.scene.characterInitials,
                                aiName: controller.scene.characterName,
                                aiRole: controller.scene.characterRole,
                                stateLabel: controller.labelForState(state),
                                state: state,
                                voiceActive:
                                    controller.isVoiceSessionActive.value,
                              );
                            }),
                            const SizedBox(height: AppDimensions.lg),
                            Obx(
                              () => PracticeCaptionStrip(
                                aiCaption: controller.latestAiCaption,
                                userCaption: controller.latestUserCaption,
                              ),
                            ),
                            const SizedBox(height: AppDimensions.md),
                            Obx(
                              () => PracticeTranscriptPanel(
                                messages: controller.messages.toList(
                                  growable: false,
                                ),
                                expanded: controller.isTranscriptExpanded.value,
                                onToggle: controller.toggleTranscript,
                                onSaveVocabulary:
                                    controller.saveVocabularyCandidate,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Obx(
                      () => PracticeControlBar(
                        controller: controller.composerController,
                        onChanged: controller.onComposerChanged,
                        onSend: controller.sendReply,
                        onHint: controller.showHint,
                        onMicTap: controller.toggleVoiceSession,
                        onMuteTap: controller.toggleMicMute,
                        onFinish: controller.finishSession,
                        isSending: controller.isSubmitting.value,
                        sendEnabled: controller.canSendReply.value,
                        voiceActive: controller.isVoiceSessionActive.value,
                        voiceConnecting: controller.isVoiceConnecting.value,
                        micMuted: controller.isMicMuted.value,
                        voiceStatusText: controller.voiceStatusText,
                        practiceState: controller.practiceState.value,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Positioned.fill(
              child: Obx(
                () => AnimatedSwitcher(
                  duration: const Duration(milliseconds: 280),
                  child: controller.showEntryGuide.value
                      ? const _EntryGuideOverlay()
                      : const SizedBox.shrink(),
                ),
              ),
            ),
          ],
        ),
      );
    });
  }
}

class _EntryGuideOverlay extends StatelessWidget {
  const _EntryGuideOverlay();

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.primary900.withValues(alpha: 0.22),
      alignment: Alignment.center,
      child: Container(
        margin: const EdgeInsets.all(AppDimensions.xxl),
        padding: const EdgeInsets.all(AppDimensions.xl),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.94),
          borderRadius: BorderRadius.circular(AppDimensions.radiusXl),
          border: Border.all(color: Colors.white),
          boxShadow: <BoxShadow>[
            BoxShadow(
              color: AppColors.primary900.withValues(alpha: 0.16),
              blurRadius: 28,
              offset: const Offset(0, 14),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            const SizedBox(
              width: 28,
              height: 28,
              child: CircularProgressIndicator(strokeWidth: 2.8),
            ),
            const SizedBox(height: AppDimensions.lg),
            Text('Đang chuẩn bị cuộc trò chuyện', style: AppTextStyles.h3),
            const SizedBox(height: AppDimensions.sm),
            Text(
              'Khi AI đang nói, mic sẽ tự khóa. Đợi mic sáng lại rồi bạn hãy trả lời.',
              textAlign: TextAlign.center,
              style: AppTextStyles.bodySmall.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _HeaderIconButton extends StatelessWidget {
  const _HeaderIconButton({required this.icon, required this.onTap});

  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.12),
          borderRadius: BorderRadius.circular(AppDimensions.radiusFull),
          border: Border.all(color: Colors.white.withValues(alpha: 0.16)),
        ),
        alignment: Alignment.center,
        child: Icon(icon, size: AppDimensions.iconSm, color: Colors.white),
      ),
    );
  }
}

class _HeaderTextButton extends StatelessWidget {
  const _HeaderTextButton({required this.label, required this.onTap});

  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppDimensions.radiusFull),
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: AppDimensions.md,
          vertical: AppDimensions.sm,
        ),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.12),
          borderRadius: BorderRadius.circular(AppDimensions.radiusFull),
          border: Border.all(color: Colors.white.withValues(alpha: 0.16)),
        ),
        child: Text(
          label,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: AppTextStyles.labelMedium.copyWith(color: Colors.white),
        ),
      ),
    );
  }
}
