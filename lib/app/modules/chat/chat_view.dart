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
      if (!controller.hasActiveSession) {
        return const SizedBox.shrink();
      }

      final PracticeRealtimeState state = controller.practiceState.value;

      return Scaffold(
        backgroundColor: AppColors.background,
        body: Container(
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
                                  style: AppTextStyles.h2.copyWith(
                                    color: Colors.white,
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  '${controller.scene.characterName} • ${controller.scene.characterRole} • ${controller.scene.difficultyLabel}',
                                  style: AppTextStyles.bodySmall.copyWith(
                                    color: Colors.white.withValues(alpha: 0.74),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: AppDimensions.md),
                          _HeaderTextButton(
                            label: AppStrings.practiceHintButton,
                            onTap: controller.showHint,
                          ),
                          const SizedBox(width: AppDimensions.sm),
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
                        PracticeStage(
                          userInitials: 'K',
                          aiInitials: controller.scene.characterInitials,
                          aiName: controller.scene.characterName,
                          aiRole: controller.scene.characterRole,
                          stateLabel: controller.labelForState(state),
                          state: state,
                        ),
                        const SizedBox(height: AppDimensions.lg),
                        PracticeCaptionStrip(
                          aiCaption: controller.latestAiCaption,
                          userCaption: controller.latestUserCaption,
                        ),
                        const SizedBox(height: AppDimensions.md),
                        PracticeTranscriptPanel(
                          messages: controller.messages.toList(growable: false),
                          expanded: controller.isTranscriptExpanded.value,
                          onToggle: controller.toggleTranscript,
                        ),
                      ],
                    ),
                  ),
                ),
                PracticeControlBar(
                  controller: controller.composerController,
                  onChanged: controller.onComposerChanged,
                  onSend: controller.sendReply,
                  onHint: controller.showHint,
                  onMicTap: controller.showVoiceComingSoon,
                  onFinish: controller.finishSession,
                  isSending: controller.isSubmitting.value,
                  sendEnabled: controller.canSendReply.value,
                ),
              ],
            ),
          ),
        ),
      );
    });
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
          style: AppTextStyles.labelMedium.copyWith(color: Colors.white),
        ),
      ),
    );
  }
}
