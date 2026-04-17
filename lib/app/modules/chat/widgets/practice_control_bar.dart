import 'package:flutter/material.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_dimensions.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/constants/app_text_styles.dart';

class PracticeControlBar extends StatelessWidget {
  const PracticeControlBar({
    required this.controller,
    required this.onChanged,
    required this.onSend,
    required this.onHint,
    required this.onMicTap,
    required this.onFinish,
    required this.isSending,
    required this.sendEnabled,
    super.key,
  });

  final TextEditingController controller;
  final ValueChanged<String> onChanged;
  final VoidCallback onSend;
  final VoidCallback onHint;
  final VoidCallback onMicTap;
  final VoidCallback onFinish;
  final bool isSending;
  final bool sendEnabled;

  @override
  Widget build(BuildContext context) {
    final double bottomInset = MediaQuery.paddingOf(context).bottom;

    return Container(
      padding: EdgeInsets.fromLTRB(
        AppDimensions.xl,
        AppDimensions.sm,
        AppDimensions.xl,
        bottomInset + AppDimensions.md,
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
                onTap: onHint,
              ),
              const Spacer(),
              GestureDetector(
                onTap: onMicTap,
                child: Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: <Color>[
                        AppColors.primary800,
                        AppColors.primary700,
                      ],
                    ),
                    shape: BoxShape.circle,
                    boxShadow: <BoxShadow>[
                      BoxShadow(
                        color: AppColors.primary800.withValues(alpha: 0.18),
                        blurRadius: 12,
                        offset: const Offset(0, 6),
                      ),
                    ],
                  ),
                  child: const Icon(
                    Icons.mic_none_rounded,
                    size: AppDimensions.iconLg,
                    color: Colors.white,
                  ),
                ),
              ),
              const Spacer(),
              _SecondaryControlChip(
                icon: Icons.stop_circle_outlined,
                label: AppStrings.practiceControlEnd,
                onTap: onFinish,
              ),
            ],
          ),
          const SizedBox(height: AppDimensions.sm),
          Text(
            AppStrings.practiceVoiceComingSoon,
            style: AppTextStyles.labelMedium.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: AppDimensions.sm),
          Row(
            children: <Widget>[
              Expanded(
                child: TextField(
                  controller: controller,
                  onChanged: onChanged,
                  minLines: 1,
                  maxLines: 3,
                  decoration: const InputDecoration(
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

class _SecondaryControlChip extends StatelessWidget {
  const _SecondaryControlChip({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  final IconData icon;
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
          color: AppColors.primary50,
          borderRadius: BorderRadius.circular(AppDimensions.radiusFull),
          border: Border.all(color: AppColors.primary200),
        ),
        child: Row(
          children: <Widget>[
            Icon(icon, size: AppDimensions.iconSm, color: AppColors.primary800),
            const SizedBox(width: AppDimensions.xs),
            Text(label, style: AppTextStyles.labelMedium),
          ],
        ),
      ),
    );
  }
}
