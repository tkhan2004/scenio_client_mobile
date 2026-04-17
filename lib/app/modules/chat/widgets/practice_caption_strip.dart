import 'package:flutter/material.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_dimensions.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/constants/app_text_styles.dart';

class PracticeCaptionStrip extends StatelessWidget {
  const PracticeCaptionStrip({
    required this.aiCaption,
    required this.userCaption,
    super.key,
  });

  final String aiCaption;
  final String userCaption;

  @override
  Widget build(BuildContext context) {
    return Container(
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
          Text(
            AppStrings.practiceCaptionAi,
            style: AppTextStyles.labelMedium.copyWith(
              color: AppColors.primary700,
            ),
          ),
          const SizedBox(height: AppDimensions.xs),
          Text(aiCaption, style: AppTextStyles.bodyLarge),
          const SizedBox(height: AppDimensions.md),
          Text(
            AppStrings.practiceCaptionYou,
            style: AppTextStyles.labelMedium.copyWith(
              color: AppColors.secondary500,
            ),
          ),
          const SizedBox(height: AppDimensions.xs),
          Text(userCaption, style: AppTextStyles.bodyLarge),
        ],
      ),
    );
  }
}
