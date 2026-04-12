import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_dimensions.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../data/models/profile_model.dart';
import '../../home/widgets/scenio_icon_badge.dart';

class ProfileActionTile extends StatelessWidget {
  const ProfileActionTile({required this.action, super.key});

  final ProfileActionItem action;

  @override
  Widget build(BuildContext context) {
    final Color accentColor = action.isDestructive
        ? AppColors.error
        : AppColors.primary800;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(AppDimensions.radiusLg),
        onTap: () {
          Get.snackbar(
            action.title,
            'This profile action will be connected next.',
            snackPosition: SnackPosition.BOTTOM,
            margin: const EdgeInsets.all(AppDimensions.lg),
            backgroundColor: Colors.white,
            colorText: AppColors.textPrimary,
          );
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: AppDimensions.md),
          child: Row(
            children: <Widget>[
              ScenioIconBadge(
                icon: action.icon,
                tint: action.isDestructive
                    ? AppColors.error
                    : AppColors.primary700,
                size: 40,
                iconColor: accentColor,
              ),
              const SizedBox(width: AppDimensions.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      action.title,
                      style: AppTextStyles.labelLarge.copyWith(
                        color: accentColor,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      action.subtitle,
                      style: AppTextStyles.bodySmall.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(Icons.chevron_right_rounded, color: AppColors.primary300),
            ],
          ),
        ),
      ),
    );
  }
}
