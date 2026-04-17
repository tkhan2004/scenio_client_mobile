import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_dimensions.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../data/models/profile_model.dart';
import '../../../core/utils/scenio_alerts.dart';
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
          if (action.id == 'language') {
            _showLanguageBottomSheet(context);
            return;
          }
          ScenioAlert.show(
            title: action.title,
            message: 'This profile action will be connected next.',
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

  void _showLanguageBottomSheet(BuildContext context) {
    Get.bottomSheet(
      Container(
        padding: const EdgeInsets.all(AppDimensions.xl),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(AppDimensions.radiusXl)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Text('Language Settings', style: AppTextStyles.h3),
            const SizedBox(height: AppDimensions.lg),
            ListTile(
              title: const Text('English (US)'),
              trailing: Get.locale?.languageCode == 'en' ? Icon(Icons.check_circle, color: AppColors.primary700) : null,
              onTap: () {
                Get.updateLocale(const Locale('en', 'US'));
                Get.back();
              },
            ),
            ListTile(
              title: const Text('Tiếng Việt'),
              trailing: Get.locale?.languageCode == 'vi' ? Icon(Icons.check_circle, color: AppColors.primary700) : null,
              onTap: () {
                Get.updateLocale(const Locale('vi', 'VN'));
                Get.back();
              },
            ),
            const SizedBox(height: AppDimensions.xxl),
          ],
        ),
      ),
    );
  }
}
