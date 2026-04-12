import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_dimensions.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../data/models/profile_model.dart';
import '../../home/widgets/scenio_icon_badge.dart';

class ProfileHistoryCard extends StatelessWidget {
  const ProfileHistoryCard({required this.item, super.key});

  final ProfileHistoryItem item;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppDimensions.lg),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppDimensions.radiusLg),
        border: Border.all(color: AppColors.primary200.withValues(alpha: 0.9)),
      ),
      child: Column(
        children: <Widget>[
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              ScenioIconBadge(
                icon: item.icon,
                tint: AppColors.primary700,
                size: 44,
              ),
              const SizedBox(width: AppDimensions.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(item.title, style: AppTextStyles.h3),
                    const SizedBox(height: 2),
                    Text(
                      item.meta,
                      style: AppTextStyles.bodySmall.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppDimensions.md,
                  vertical: AppDimensions.sm,
                ),
                decoration: BoxDecoration(
                  color: AppColors.primary50,
                  borderRadius: BorderRadius.circular(AppDimensions.radiusFull),
                ),
                child: Text(
                  '${item.averageScore}',
                  style: AppTextStyles.labelLarge.copyWith(
                    color: AppColors.primary800,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppDimensions.md),
          Row(
            children: <Widget>[
              Text(
                item.dateLabel,
                style: AppTextStyles.labelMedium.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
              const Spacer(),
              Text(
                '+${item.xpEarned} XP',
                style: AppTextStyles.labelLarge.copyWith(
                  color: AppColors.secondary500,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
