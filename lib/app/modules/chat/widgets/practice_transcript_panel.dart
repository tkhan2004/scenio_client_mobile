import 'package:flutter/material.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_dimensions.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../domain/entities/message_entity.dart';

class PracticeTranscriptPanel extends StatelessWidget {
  const PracticeTranscriptPanel({
    required this.messages,
    required this.expanded,
    required this.onToggle,
    super.key,
  });

  final List<MessageEntity> messages;
  final bool expanded;
  final VoidCallback onToggle;

  @override
  Widget build(BuildContext context) {
    final List<MessageEntity> visibleMessages = expanded
        ? messages
        : messages.take(messages.length.clamp(0, 3).toInt()).toList();

    return AnimatedContainer(
      duration: const Duration(milliseconds: 220),
      curve: Curves.easeOutCubic,
      width: double.infinity,
      padding: const EdgeInsets.all(AppDimensions.lg),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppDimensions.radiusLg),
        border: Border.all(color: AppColors.primary200.withValues(alpha: 0.9)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            children: <Widget>[
              Text(AppStrings.practiceTranscriptTitle, style: AppTextStyles.h3),
              const Spacer(),
              TextButton(
                onPressed: onToggle,
                child: Text(
                  expanded
                      ? AppStrings.practiceTranscriptHide
                      : AppStrings.practiceTranscriptShow,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppDimensions.sm),
          ...visibleMessages.map(
            (MessageEntity message) => Padding(
              padding: EdgeInsets.only(
                bottom: message == visibleMessages.last ? 0 : AppDimensions.sm,
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  SizedBox(
                    width: 38,
                    child: Text(
                      message.author.label,
                      style: AppTextStyles.labelMedium.copyWith(
                        color: message.author == MessageAuthor.ai
                            ? AppColors.primary700
                            : AppColors.secondary500,
                      ),
                    ),
                  ),
                  Expanded(
                    child: Text(
                      message.text,
                      style: AppTextStyles.bodySmall.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
