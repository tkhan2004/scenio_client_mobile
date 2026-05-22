import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_dimensions.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/constants/app_text_styles.dart';
import '../profile_viewmodel.dart';

class ProfileHeroCard extends StatelessWidget {
  const ProfileHeroCard({required this.controller, super.key});

  final ProfileViewModel controller;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppDimensions.lg),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: <Color>[
            AppColors.primary900,
            AppColors.primary800,
            AppColors.primary700,
          ],
        ),
        borderRadius: BorderRadius.circular(AppDimensions.radiusXl),
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: AppColors.primary900.withValues(alpha: 0.18),
            blurRadius: 24,
            offset: const Offset(0, 16),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                width: 52,
                height: 52,
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.18),
                  borderRadius: BorderRadius.circular(AppDimensions.radiusFull),
                  border: Border.all(
                    color: Colors.white.withValues(alpha: 0.28),
                  ),
                ),
                alignment: Alignment.center,
                child: Text(
                  controller.avatarInitial,
                  style: AppTextStyles.h2.copyWith(color: Colors.white),
                ),
              ),
              const SizedBox(width: AppDimensions.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      AppStrings.homeProfileTitle,
                      style: AppTextStyles.labelMedium.copyWith(
                        color: Colors.white.withValues(alpha: 0.72),
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      controller.displayName,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppTextStyles.displayMedium.copyWith(
                        color: Colors.white,
                        height: 1.08,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      controller.profileEmail,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppTextStyles.bodySmall.copyWith(
                        color: Colors.white.withValues(alpha: 0.74),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: AppDimensions.sm),
              _HeroTextButton(
                icon: Icons.edit_outlined,
                label: AppStrings.profileHeroEdit,
              ),
            ],
          ),
          const SizedBox(height: AppDimensions.md),
          Wrap(
            spacing: AppDimensions.sm,
            runSpacing: AppDimensions.sm,
            children: <Widget>[
              _HeroChip(
                label: 'Level ${controller.profileLevel}',
                icon: Icons.workspace_premium_rounded,
              ),
              _HeroChip(
                label: controller.profileLearningGoal,
                icon: Icons.explore_rounded,
              ),
              _HeroChip(
                label: controller.profileStudyFrequency,
                icon: Icons.bolt_rounded,
              ),
              _HeroChip(
                label: controller.profileFocus,
                icon: Icons.auto_awesome_rounded,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _HeroTextButton extends StatelessWidget {
  const _HeroTextButton({required this.icon, required this.label});

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppDimensions.sm,
        vertical: AppDimensions.xs,
      ),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(AppDimensions.radiusFull),
        border: Border.all(color: Colors.white.withValues(alpha: 0.22)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Icon(icon, color: Colors.white, size: AppDimensions.iconSm),
          const SizedBox(width: AppDimensions.xs),
          Text(
            label,
            style: AppTextStyles.labelMedium.copyWith(color: Colors.white),
          ),
        ],
      ),
    );
  }
}

class _HeroChip extends StatelessWidget {
  const _HeroChip({required this.label, required this.icon});

  final String label;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppDimensions.sm,
        vertical: AppDimensions.xs,
      ),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(AppDimensions.radiusFull),
        border: Border.all(color: Colors.white.withValues(alpha: 0.2)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Icon(icon, size: AppDimensions.iconSm, color: Colors.white),
          const SizedBox(width: AppDimensions.xs),
          Text(
            label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.labelMedium.copyWith(color: Colors.white),
          ),
        ],
      ),
    );
  }
}
