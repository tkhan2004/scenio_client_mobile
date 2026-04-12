import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_dimensions.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../data/models/profile_model.dart';
import '../../home/widgets/scenio_icon_badge.dart';

class ProfileBadgeCard extends StatelessWidget {
  const ProfileBadgeCard({required this.badge, super.key});

  final ProfileBadgeData badge;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 176,
      padding: const EdgeInsets.all(AppDimensions.lg),
      decoration: BoxDecoration(
        color: badge.isEarned ? Colors.white : AppColors.primary50,
        borderRadius: BorderRadius.circular(AppDimensions.radiusLg),
        border: Border.all(
          color: badge.isEarned
              ? AppColors.accent200.withValues(alpha: 0.92)
              : AppColors.primary200.withValues(alpha: 0.92),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          ScenioIconBadge(
            icon: badge.icon,
            tint: badge.isEarned ? AppColors.accent500 : AppColors.primary300,
            size: 44,
          ),
          const SizedBox(height: AppDimensions.md),
          Text(badge.title, style: AppTextStyles.h3),
          const SizedBox(height: AppDimensions.xs),
          Text(
            badge.description,
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.bodySmall.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: AppDimensions.md),
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: AppDimensions.md,
              vertical: AppDimensions.sm,
            ),
            decoration: BoxDecoration(
              color: badge.isEarned ? AppColors.accent50 : Colors.white,
              borderRadius: BorderRadius.circular(AppDimensions.radiusFull),
            ),
            child: Text(
              badge.isEarned ? '+${badge.xpReward} XP' : 'Locked',
              style: AppTextStyles.labelMedium.copyWith(
                color: badge.isEarned
                    ? AppColors.accent500
                    : AppColors.primary500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
