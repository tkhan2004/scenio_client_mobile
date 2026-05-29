import 'package:flutter/material.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_dimensions.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../domain/entities/session_entity.dart';

class PracticeControlBar extends StatelessWidget {
  const PracticeControlBar({
    required this.controller,
    required this.onChanged,
    required this.onSend,
    required this.onHint,
    required this.onMicTap,
    required this.onMuteTap,
    required this.onFinish,
    required this.hintEnabled,
    required this.isHinting,
    required this.isSending,
    required this.isFinishing,
    required this.sendEnabled,
    required this.voiceActive,
    required this.voiceConnecting,
    required this.micMuted,
    required this.voiceStatusText,
    required this.practiceState,
    super.key,
  });

  final TextEditingController controller;
  final ValueChanged<String> onChanged;
  final VoidCallback onSend;
  final VoidCallback onHint;
  final VoidCallback onMicTap;
  final VoidCallback onMuteTap;
  final VoidCallback onFinish;
  final bool hintEnabled;
  final bool isHinting;
  final bool isSending;
  final bool isFinishing;
  final bool sendEnabled;
  final bool voiceActive;
  final bool voiceConnecting;
  final bool micMuted;
  final String voiceStatusText;
  final PracticeRealtimeState practiceState;

  @override
  Widget build(BuildContext context) {
    final double bottomInset = MediaQuery.paddingOf(context).bottom;
    final bool userSpeaking =
        practiceState == PracticeRealtimeState.userSpeaking;
    final bool aiSpeaking =
        practiceState == PracticeRealtimeState.aiThinking ||
        practiceState == PracticeRealtimeState.aiSpeaking;

    return Container(
      padding: EdgeInsets.fromLTRB(
        AppDimensions.lg,
        AppDimensions.xs,
        AppDimensions.lg,
        bottomInset + AppDimensions.sm,
      ),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.96),
        borderRadius: const BorderRadius.vertical(
          top: Radius.circular(AppDimensions.radiusXl),
        ),
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: AppColors.primary900.withValues(alpha: 0.08),
            blurRadius: 20,
            offset: const Offset(0, -8),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Row(
            children: <Widget>[
              _SecondaryControlChip(
                icon: Icons.lightbulb_outline_rounded,
                label: AppStrings.practiceControlHint,
                onTap: hintEnabled ? onHint : null,
                isLoading: isHinting,
              ),
              const Spacer(),
              _ReactiveMicButton(
                active: voiceActive,
                connecting: voiceConnecting,
                muted: micMuted,
                userSpeaking: userSpeaking,
                aiSpeaking: aiSpeaking,
                onTap: onMicTap,
              ),
              Spacer(),
              _SecondaryControlChip(
                icon: Icons.stop_circle_outlined,
                label: isFinishing
                    ? 'Đang chốt...'
                    : AppStrings.practiceControlEnd,
                onTap: isFinishing ? null : onFinish,
                isLoading: isFinishing,
              ),
            ],
          ),
          const SizedBox(height: AppDimensions.xs),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Flexible(
                child: Text(
                  aiSpeaking
                      ? 'AI đang nói, mic tạm khóa'
                      : userSpeaking
                      ? 'Mic đang nghe bạn nói'
                      : voiceStatusText,
                  textAlign: TextAlign.center,
                  style: AppTextStyles.labelMedium.copyWith(
                    color: voiceActive
                        ? AppColors.secondary700
                        : AppColors.textSecondary,
                  ),
                ),
              ),
              if (voiceActive) ...<Widget>[
                const SizedBox(width: AppDimensions.sm),
                InkWell(
                  onTap: onMuteTap,
                  borderRadius: BorderRadius.circular(AppDimensions.radiusFull),
                  child: Container(
                    padding: const EdgeInsets.all(AppDimensions.xs),
                    decoration: BoxDecoration(
                      color: micMuted
                          ? AppColors.warningBg
                          : AppColors.primary50,
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: micMuted
                            ? AppColors.warning
                            : AppColors.primary200,
                      ),
                    ),
                    child: Icon(
                      micMuted
                          ? Icons.mic_off_rounded
                          : Icons.graphic_eq_rounded,
                      size: AppDimensions.iconSm,
                      color: micMuted
                          ? AppColors.warning
                          : AppColors.primary800,
                    ),
                  ),
                ),
              ],
            ],
          ),
          const SizedBox(height: AppDimensions.xs),
          Row(
            children: <Widget>[
              Expanded(
                child: TextField(
                  controller: controller,
                  onChanged: onChanged,
                  minLines: 1,
                  maxLines: 1,
                  decoration: InputDecoration(
                    hintText: AppStrings.practiceComposerHint,
                    prefixIcon: Icon(Icons.edit_outlined),
                  ),
                ),
              ),
              const SizedBox(width: AppDimensions.sm),
              SizedBox(
                width: 48,
                height: 48,
                child: ElevatedButton(
                  onPressed: sendEnabled && !isSending ? onSend : null,
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.zero,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(
                        AppDimensions.radiusFull,
                      ),
                    ),
                  ),
                  child: isSending
                      ? const SizedBox(
                          width: 18,
                          height: 18,
                          child: CircularProgressIndicator(
                            strokeWidth: 2.2,
                            color: Colors.white,
                          ),
                        )
                      : const Icon(Icons.send_rounded),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _ReactiveMicButton extends StatefulWidget {
  const _ReactiveMicButton({
    required this.active,
    required this.connecting,
    required this.muted,
    required this.userSpeaking,
    required this.aiSpeaking,
    required this.onTap,
  });

  final bool active;
  final bool connecting;
  final bool muted;
  final bool userSpeaking;
  final bool aiSpeaking;
  final VoidCallback onTap;

  @override
  State<_ReactiveMicButton> createState() => _ReactiveMicButtonState();
}

class _ReactiveMicButtonState extends State<_ReactiveMicButton>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 780),
    );
    if (widget.userSpeaking) {
      _controller.repeat(reverse: true);
    }
  }

  @override
  void didUpdateWidget(covariant _ReactiveMicButton oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.userSpeaking && !_controller.isAnimating) {
      _controller.repeat(reverse: true);
      return;
    }

    if (!widget.userSpeaking && _controller.isAnimating) {
      _controller.stop();
      _controller.animateTo(0, duration: const Duration(milliseconds: 180));
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      child: AnimatedBuilder(
        animation: _controller,
        builder: (BuildContext context, Widget? child) {
          final double pulse = widget.userSpeaking ? _controller.value : 0.0;
          final double size = widget.active ? 58 + pulse * 8 : 54;

          return AnimatedContainer(
            duration: const Duration(milliseconds: 220),
            curve: Curves.easeOutCubic,
            width: size,
            height: size,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: <Color>[
                  widget.aiSpeaking
                      ? AppColors.neutral300
                      : widget.active
                      ? widget.muted
                            ? AppColors.warning
                            : AppColors.secondary500
                      : AppColors.primary800,
                  widget.aiSpeaking
                      ? AppColors.primary200
                      : widget.active
                      ? widget.muted
                            ? AppColors.accent500
                            : AppColors.primary700
                      : AppColors.primary700,
                ],
              ),
              shape: BoxShape.circle,
              boxShadow: <BoxShadow>[
                BoxShadow(
                  color:
                      (widget.userSpeaking
                              ? AppColors.secondary500
                              : AppColors.primary800)
                          .withValues(alpha: widget.userSpeaking ? 0.30 : 0.18),
                  blurRadius: widget.userSpeaking ? 24 : 12,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child: widget.connecting
                ? const Center(
                    child: SizedBox(
                      width: 22,
                      height: 22,
                      child: CircularProgressIndicator(
                        strokeWidth: 2.4,
                        color: Colors.white,
                      ),
                    ),
                  )
                : Icon(
                    widget.aiSpeaking
                        ? Icons.lock_rounded
                        : widget.active
                        ? widget.muted
                              ? Icons.mic_off_rounded
                              : Icons.mic_rounded
                        : Icons.mic_none_rounded,
                    size: AppDimensions.iconMd,
                    color: Colors.white,
                  ),
          );
        },
      ),
    );
  }
}

class _SecondaryControlChip extends StatelessWidget {
  const _SecondaryControlChip({
    required this.icon,
    required this.label,
    required this.onTap,
    this.isLoading = false,
  });

  final IconData icon;
  final String label;
  final VoidCallback? onTap;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    final bool enabled = onTap != null && !isLoading;
    return InkWell(
      onTap: enabled ? onTap : null,
      borderRadius: BorderRadius.circular(AppDimensions.radiusFull),
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: AppDimensions.md,
          vertical: 7,
        ),
        decoration: BoxDecoration(
          color: enabled
              ? AppColors.primary50
              : AppColors.neutral100.withValues(alpha: 0.7),
          borderRadius: BorderRadius.circular(AppDimensions.radiusFull),
          border: Border.all(
            color: enabled ? AppColors.primary200 : AppColors.neutral300,
          ),
        ),
        child: Row(
          children: <Widget>[
            isLoading
                ? const SizedBox(
                    width: AppDimensions.iconSm,
                    height: AppDimensions.iconSm,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: AppColors.primary800,
                    ),
                  )
                : Icon(
                    icon,
                    size: AppDimensions.iconSm,
                    color: enabled ? AppColors.primary800 : AppColors.textHint,
                  ),
            const SizedBox(width: AppDimensions.xs),
            Text(
              label,
              style: AppTextStyles.labelMedium.copyWith(
                color: enabled ? AppColors.textPrimary : AppColors.textHint,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
