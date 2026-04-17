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
      padding: const EdgeInsets.all(AppDimensions.xl),
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
            children: <Widget>[
              Container(
                width: 64,
                height: 64,
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.18),
                  borderRadius: BorderRadius.circular(AppDimensions.radiusFull),
                  border: Border.all(
                    color: Colors.white.withValues(alpha: 0.28),
                  ),
                ),
                alignment: Alignment.center,
                child: Text(
                  'K',
                  style: AppTextStyles.displayMedium.copyWith(
                    color: Colors.white,
                  ),
                ),
              ),
              Spacer(),
              _HeroTextButton(
                icon: Icons.edit_outlined,
                label: AppStrings.profileHeroEdit,
              ),
            ],
          ),
          SizedBox(height: AppDimensions.lg),
          Text(
            AppStrings.homeProfileTitle,
            style: AppTextStyles.labelLarge.copyWith(
              color: Colors.white.withValues(alpha: 0.76),
            ),
          ),
          const SizedBox(height: AppDimensions.xs),
          Text(
            controller.displayName,
            style: AppTextStyles.displayLarge.copyWith(
              color: Colors.white,
              height: 1.08,
            ),
          ),
          const SizedBox(height: AppDimensions.xs),
          Text(
            controller.profileEmail,
            style: AppTextStyles.bodyMedium.copyWith(
              color: Colors.white.withValues(alpha: 0.78),
            ),
          ),
          const SizedBox(height: AppDimensions.lg),
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
          SizedBox(height: AppDimensions.lg),
          Row(
            children: <Widget>[
              Expanded(
                child: _HeroInfoPill(
                  title: AppStrings.homeProfileGoal,
                  value: controller.profileGoalProgress,
                  accent: AppColors.secondary50,
                ),
              ),
              SizedBox(width: AppDimensions.md),
              Expanded(
                child: _HeroInfoPill(
                  title: AppStrings.profileBadgesSection,
                  value: controller.profileBadgesProgress,
                  accent: AppColors.accent50,
                ),
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
        horizontal: AppDimensions.md,
        vertical: AppDimensions.sm,
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
          const SizedBox(width: AppDimensions.sm),
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
        horizontal: AppDimensions.md,
        vertical: AppDimensions.sm,
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
          const SizedBox(width: AppDimensions.sm),
          Text(
            label,
            style: AppTextStyles.labelMedium.copyWith(color: Colors.white),
          ),
        ],
      ),
    );
  }
}

class _HeroInfoPill extends StatelessWidget {
  const _HeroInfoPill({
    required this.title,
    required this.value,
    required this.accent,
  });

  final String title;
  final String value;
  final Color accent;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppDimensions.md),
      decoration: BoxDecoration(
        color: accent.withValues(alpha: 0.94),
        borderRadius: BorderRadius.circular(AppDimensions.radiusLg),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(title, style: AppTextStyles.labelMedium),
          const SizedBox(height: AppDimensions.xs),
          Text(
            value,
            style: AppTextStyles.labelLarge.copyWith(
              color: AppColors.textPrimary,
            ),
          ),
        ],
      ),
    );
  }
}
