import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_dimensions.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../domain/entities/scene_entity.dart';
import '../home_viewmodel.dart';
import 'scenio_icon_badge.dart';

class HomePracticeTab extends StatelessWidget {
  const HomePracticeTab({
    required this.viewModel,
    required this.bottomPadding,
    super.key,
  });

  final HomeViewModel viewModel;
  final double bottomPadding;

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => SafeArea(
        bottom: false,
        child: ListView(
          physics: const ClampingScrollPhysics(),
          padding: EdgeInsets.fromLTRB(
            AppDimensions.xxl,
            AppDimensions.xxl,
            AppDimensions.xxl,
            bottomPadding,
          ),
          children: <Widget>[
            _PracticePageHeader(viewModel: viewModel),
            const SizedBox(height: AppDimensions.xl),
            if (viewModel.hasActiveSession)
              _ActivePracticeCard(viewModel: viewModel)
            else
              _PracticeEmptyState(viewModel: viewModel),
            const SizedBox(height: AppDimensions.xl),
            Text(AppStrings.scenesRecommendedSection, style: AppTextStyles.h2),
            const SizedBox(height: AppDimensions.md),
            ...viewModel.recommendedScenes.map(
              (SceneEntity scene) => Padding(
                padding: EdgeInsets.only(
                  bottom: scene == viewModel.recommendedScenes.last
                      ? 0
                      : AppDimensions.md,
                ),
                child: _QuickStartSceneTile(
                  scene: scene,
                  onTap: () => viewModel.openSceneDetails(scene),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _PracticePageHeader extends StatelessWidget {
  const _PracticePageHeader({required this.viewModel});

  final HomeViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    final bool hasActiveSession = viewModel.hasActiveSession;
    final SceneEntity? activeScene = viewModel.currentSessionScene;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Row(
          children: <Widget>[
            Expanded(
              child: Text(
                AppStrings.practiceTabTitle,
                style: AppTextStyles.displayLarge.copyWith(
                  fontSize: 28,
                  color: AppColors.primary900,
                ),
              ),
            ),
            _PracticeStatusChip(
              label: hasActiveSession
                  ? AppStrings.practiceHeroChipActive
                  : AppStrings.practiceHeroChipIdle,
              icon: hasActiveSession
                  ? Icons.graphic_eq_rounded
                  : Icons.play_circle_outline_rounded,
            ),
          ],
        ),
        const SizedBox(height: AppDimensions.xs),
        Text(
          AppStrings.practiceHeroSubtitle,
          style: AppTextStyles.bodyMedium.copyWith(
            color: AppColors.textSecondary,
          ),
        ),
        const SizedBox(height: AppDimensions.md),
        Text(
          hasActiveSession && activeScene != null
              ? '${activeScene.title} • ${viewModel.currentSession!.completedTurns}/${viewModel.currentSession!.targetTurns} turns'
              : 'Choose a scene first, then return here to resume it fast.',
          style: AppTextStyles.labelMedium.copyWith(
            color: hasActiveSession
                ? AppColors.secondary500
                : AppColors.textSecondary,
          ),
        ),
      ],
    );
  }
}

class _PracticeStatusChip extends StatelessWidget {
  const _PracticeStatusChip({required this.label, required this.icon});

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
        color: AppColors.primary50,
        borderRadius: BorderRadius.circular(AppDimensions.radiusFull),
        border: Border.all(color: AppColors.primary200),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Icon(icon, size: AppDimensions.iconSm, color: AppColors.primary700),
          const SizedBox(width: AppDimensions.xs),
          Text(
            label,
            style: AppTextStyles.labelMedium.copyWith(
              color: AppColors.primary800,
            ),
          ),
        ],
      ),
    );
  }
}

class _ActivePracticeCard extends StatelessWidget {
  const _ActivePracticeCard({required this.viewModel});

  final HomeViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    final SceneEntity scene = viewModel.currentSessionScene!;

    return Container(
      padding: const EdgeInsets.all(AppDimensions.xl),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: <Color>[AppColors.primary900, AppColors.primary700],
        ),
        borderRadius: BorderRadius.circular(AppDimensions.radiusXl),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            AppStrings.practiceResumeTitle,
            style: AppTextStyles.labelLarge.copyWith(
              color: Colors.white.withValues(alpha: 0.84),
            ),
          ),
          const SizedBox(height: AppDimensions.sm),
          Text(
            scene.title,
            style: AppTextStyles.displayMedium.copyWith(color: Colors.white),
          ),
          const SizedBox(height: AppDimensions.xs),
          Text(
            '${scene.characterName} • ${scene.characterRole}',
            style: AppTextStyles.bodyMedium.copyWith(
              color: Colors.white.withValues(alpha: 0.88),
            ),
          ),
          const SizedBox(height: AppDimensions.md),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(AppDimensions.md),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.14),
              borderRadius: BorderRadius.circular(AppDimensions.radiusLg),
              border: Border.all(color: Colors.white.withValues(alpha: 0.18)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  AppStrings.practiceMissionLabel,
                  style: AppTextStyles.labelMedium.copyWith(
                    color: Colors.white.withValues(alpha: 0.78),
                  ),
                ),
                const SizedBox(height: AppDimensions.xs),
                Text(
                  scene.mission,
                  style: AppTextStyles.bodyMedium.copyWith(color: Colors.white),
                ),
                const SizedBox(height: AppDimensions.md),
                Row(
                  children: <Widget>[
                    Text(
                      '${AppStrings.practiceProgressLabel}: ${viewModel.currentSession!.completedTurns}/${viewModel.currentSession!.targetTurns}',
                      style: AppTextStyles.labelLarge.copyWith(
                        color: Colors.white,
                      ),
                    ),
                    const Spacer(),
                    Text(
                      AppStrings.practiceStateActive,
                      style: AppTextStyles.labelLarge.copyWith(
                        color: AppColors.accent200,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: AppDimensions.lg),
          ElevatedButton(
            onPressed: viewModel.openPracticeSession,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              foregroundColor: AppColors.primary900,
            ),
            child: const Text(AppStrings.practiceResumeButton),
          ),
        ],
      ),
    );
  }
}

class _PracticeEmptyState extends StatelessWidget {
  const _PracticeEmptyState({required this.viewModel});

  final HomeViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppDimensions.xl),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppDimensions.radiusXl),
        border: Border.all(color: AppColors.primary200.withValues(alpha: 0.9)),
      ),
      child: Column(
        children: <Widget>[
          Container(
            width: 96,
            height: 96,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: <Color>[
                  AppColors.primary50,
                  AppColors.primary200.withValues(alpha: 0.64),
                ],
              ),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.graphic_eq_rounded,
              size: AppDimensions.iconXl,
              color: AppColors.primary800,
            ),
          ),
          const SizedBox(height: AppDimensions.lg),
          Text(
            AppStrings.practiceEmptyTitle,
            textAlign: TextAlign.center,
            style: AppTextStyles.h2,
          ),
          const SizedBox(height: AppDimensions.xs),
          Text(
            AppStrings.practiceEmptySubtitle,
            textAlign: TextAlign.center,
            style: AppTextStyles.bodyMedium.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: AppDimensions.lg),
          ElevatedButton(
            onPressed: () => viewModel.selectTab(1),
            child: const Text(AppStrings.practiceBrowseScenesButton),
          ),
        ],
      ),
    );
  }
}

class _QuickStartSceneTile extends StatelessWidget {
  const _QuickStartSceneTile({required this.scene, required this.onTap});

  final SceneEntity scene;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppDimensions.radiusLg),
      child: Container(
        padding: const EdgeInsets.all(AppDimensions.lg),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(AppDimensions.radiusLg),
          border: Border.all(
            color: AppColors.primary200.withValues(alpha: 0.9),
          ),
        ),
        child: Row(
          children: <Widget>[
            ScenioIconBadge(
              icon: _iconForScene(scene),
              tint: AppColors.primary800,
              size: 46,
            ),
            const SizedBox(width: AppDimensions.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(scene.title, style: AppTextStyles.h3),
                  const SizedBox(height: 2),
                  Text(
                    '${scene.characterName} • ${scene.difficultyLabel} • ${scene.estimatedMinutes} min',
                    style: AppTextStyles.bodySmall.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
            const Icon(
              Icons.arrow_forward_ios_rounded,
              size: AppDimensions.iconSm,
              color: AppColors.primary500,
            ),
          ],
        ),
      ),
    );
  }
}

IconData _iconForScene(SceneEntity scene) {
  switch (scene.category) {
    case SceneCategory.dailyLife:
      return Icons.local_cafe_rounded;
    case SceneCategory.travel:
      return Icons.flight_takeoff_rounded;
    case SceneCategory.work:
      return Icons.work_rounded;
    case SceneCategory.service:
      return Icons.hotel_rounded;
  }
}
