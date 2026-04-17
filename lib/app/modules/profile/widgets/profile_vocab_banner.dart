import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_dimensions.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/constants/app_text_styles.dart';

class ProfileVocabBanner extends StatelessWidget {
  const ProfileVocabBanner({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppDimensions.radiusLg),
        border: Border.all(color: AppColors.primary200.withValues(alpha: 0.9)),
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(AppDimensions.radiusLg),
        child: InkWell(
          borderRadius: BorderRadius.circular(AppDimensions.radiusLg),
          onTap: () {
            // Navigator to Vocabulary Tab or Screen
          },
          child: Padding(
            padding: const EdgeInsets.all(AppDimensions.lg),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Container(
                  padding: const EdgeInsets.all(AppDimensions.md),
                  decoration: const BoxDecoration(
                    color: AppColors.primary50,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.menu_book_rounded,
                    color: AppColors.primary700,
                    size: 28,
                  ),
                ),
                const SizedBox(width: AppDimensions.lg),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Text(
                        AppStrings.profileActionSavedWords,
                        style: AppTextStyles.h3.copyWith(
                          color: AppColors.textPrimary,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: AppDimensions.xs),
                      Text(
                        AppStrings.profileActionSavedWordsSubtitle,
                        style: AppTextStyles.bodySmall.copyWith(
                          color: AppColors.textSecondary,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: AppDimensions.md),
                const Icon(
                  Icons.arrow_forward_ios_rounded,
                  color: AppColors.primary300,
                  size: 16,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
