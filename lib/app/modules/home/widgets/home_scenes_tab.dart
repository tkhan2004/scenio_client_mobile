import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_dimensions.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../domain/entities/scene_entity.dart';
import '../home_viewmodel.dart';
import 'scenio_icon_badge.dart';

class HomeScenesTab extends StatelessWidget {
  const HomeScenesTab({
    required this.viewModel,
    required this.bottomPadding,
    super.key,
  });

  final HomeViewModel viewModel;
  final double bottomPadding;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
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
          _ScenesPageHeader(viewModel: viewModel),
          const SizedBox(height: AppDimensions.lg),
          TextField(
            onChanged: viewModel.updateSceneSearch,
            decoration: InputDecoration(
              hintText: AppStrings.scenesSearchHint,
              prefixIcon: const Icon(Icons.search_rounded),
              suffixIcon: const Icon(Icons.tune_rounded),
            ),
          ),
          const SizedBox(height: AppDimensions.lg),
          Text(
            'Categories',
            style: AppTextStyles.labelLarge.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: AppDimensions.sm),
          Obx(
            () => SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: viewModel.sceneCategoryFilters
                    .map(
                      (SceneCategory? category) => Padding(
                        padding: EdgeInsets.only(
                          right: category == viewModel.sceneCategoryFilters.last
                              ? 0
                              : AppDimensions.sm,
                        ),
                        child: ChoiceChip(
                          label: Text(
                            category?.label ?? AppStrings.scenesFilterAll,
                            style: AppTextStyles.labelMedium.copyWith(
                              color:
                                  viewModel.selectedCategory.value == category
                                  ? Colors.white
                                  : AppColors.textPrimary,
                            ),
                          ),
                          selected:
                              viewModel.selectedCategory.value == category,
                          onSelected: (bool selected) =>
                              viewModel.selectSceneCategory(category),
                          selectedColor: AppColors.primary700,
                          backgroundColor: AppColors.primary50,
                          side: BorderSide(
                            color: viewModel.selectedCategory.value == category
                                ? Colors.transparent
                                : AppColors.primary200,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(
                              AppDimensions.radiusFull,
                            ),
                          ),
                          showCheckmark: false,
                        ),
                      ),
                    )
                    .toList(),
              ),
            ),
          ),
          const SizedBox(height: AppDimensions.md),
          Text(
            'Difficulty',
            style: AppTextStyles.labelLarge.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: AppDimensions.sm),
          Obx(
            () => SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: viewModel.sceneDifficultyFilters
                    .map(
                      (SceneDifficulty? difficulty) => Padding(
                        padding: EdgeInsets.only(
                          right:
                              difficulty ==
                                  viewModel.sceneDifficultyFilters.last
                              ? 0
                              : AppDimensions.sm,
                        ),
                        child: ChoiceChip(
                          label: Text(
                            difficulty?.label ?? AppStrings.scenesDifficultyAll,
                            style: AppTextStyles.labelMedium.copyWith(
                              color:
                                  viewModel.selectedDifficulty.value ==
                                      difficulty
                                  ? Colors.white
                                  : AppColors.textPrimary,
                            ),
                          ),
                          selected:
                              viewModel.selectedDifficulty.value == difficulty,
                          onSelected: (bool selected) =>
                              viewModel.selectSceneDifficulty(difficulty),
                          selectedColor: AppColors.primary700,
                          backgroundColor: AppColors.primary50,
                          side: BorderSide(
                            color:
                                viewModel.selectedDifficulty.value == difficulty
                                ? Colors.transparent
                                : AppColors.primary200,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(
                              AppDimensions.radiusFull,
                            ),
                          ),
                          showCheckmark: false,
                        ),
                      ),
                    )
                    .toList(),
              ),
            ),
          ),
          const SizedBox(height: AppDimensions.xl),
          _ScenesSectionHeader(title: AppStrings.scenesRecommendedSection),
          const SizedBox(height: AppDimensions.md),
          SizedBox(
            height: 280,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: viewModel.recommendedScenes.length,
              separatorBuilder: (BuildContext context, int index) =>
                  const SizedBox(width: AppDimensions.md),
              itemBuilder: (BuildContext context, int index) {
                final SceneEntity scene = viewModel.recommendedScenes[index];
                return _RecommendedSceneCard(
                  scene: scene,
                  onTap: () => viewModel.openSceneDetails(scene),
                  onStart: () => _handleSceneStart(scene),
                );
              },
            ),
          ),
          const SizedBox(height: AppDimensions.xl),
          _ScenesSectionHeader(title: AppStrings.scenesLibrarySection),
          const SizedBox(height: AppDimensions.md),
          Obx(() {
            final List<SceneEntity> scenes = viewModel.filteredScenes;

            if (scenes.isEmpty) {
              return Container(
                padding: const EdgeInsets.all(AppDimensions.xl),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(AppDimensions.radiusLg),
                  border: Border.all(
                    color: AppColors.primary200.withValues(alpha: 0.88),
                  ),
                ),
                child: Text(
                  'No matching scene yet. Try a broader keyword or clear a filter.',
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
              );
            }

            return Column(
              children: scenes
                  .map(
                    (SceneEntity scene) => Padding(
                      padding: EdgeInsets.only(
                        bottom: scene == scenes.last ? 0 : AppDimensions.md,
                      ),
                      child: _SceneLibraryCard(
                        scene: scene,
                        onTap: () => viewModel.openSceneDetails(scene),
                        onStart: () => _handleSceneStart(scene),
                      ),
                    ),
                  )
                  .toList(),
            );
          }),
        ],
      ),
    );
  }

  void _handleSceneStart(SceneEntity scene) {
    if (viewModel.hasActiveSessionOutsideScene(scene.id)) {
      viewModel.openSceneDetails(scene);
      return;
    }

    viewModel.startOrResumeScene(scene);
    viewModel.openPracticeSession();
  }
}

class _ScenesPageHeader extends StatelessWidget {
  const _ScenesPageHeader({required this.viewModel});

  final HomeViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final bool hasActiveSession = viewModel.hasActiveSession;

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            children: <Widget>[
              Expanded(
                child: Text(
                  AppStrings.homeTabScenes,
                  style: AppTextStyles.displayLarge.copyWith(
                    fontSize: 28,
                    color: AppColors.primary900,
                  ),
                ),
              ),
              _HeaderStatusChip(
                label: hasActiveSession ? '1 active' : 'Ready',
                icon: hasActiveSession
                    ? Icons.graphic_eq_rounded
                    : Icons.explore_rounded,
              ),
            ],
          ),
          const SizedBox(height: AppDimensions.xs),
          Text(
            AppStrings.scenesHeroSubtitle,
            style: AppTextStyles.bodyMedium.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: AppDimensions.md),
          Row(
            children: <Widget>[
              Text(
                '${viewModel.scenes.length} ${AppStrings.scenesHeroStatScenes.toLowerCase()}',
                style: AppTextStyles.labelMedium.copyWith(
                  color: AppColors.primary700,
                ),
              ),
              const SizedBox(width: AppDimensions.md),
              Container(
                width: 4,
                height: 4,
                decoration: BoxDecoration(
                  color: AppColors.primary300,
                  borderRadius: BorderRadius.circular(AppDimensions.radiusFull),
                ),
              ),
              const SizedBox(width: AppDimensions.md),
              Expanded(
                child: Text(
                  hasActiveSession
                      ? 'Resume available in Practice'
                      : 'Choose a scene to begin',
                  style: AppTextStyles.labelMedium.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
              ),
            ],
          ),
        ],
      );
    });
  }
}

class _ScenesSectionHeader extends StatelessWidget {
  const _ScenesSectionHeader({required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Text(title, style: AppTextStyles.h2);
  }
}

class _RecommendedSceneCard extends StatelessWidget {
  const _RecommendedSceneCard({
    required this.scene,
    required this.onTap,
    required this.onStart,
  });

  final SceneEntity scene;
  final VoidCallback onTap;
  final VoidCallback onStart;

  @override
  Widget build(BuildContext context) {
    final Color tint = _sceneTint(scene);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 276,
        padding: const EdgeInsets.all(AppDimensions.lg),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: <Color>[Colors.white, tint.withValues(alpha: 0.16)],
          ),
          borderRadius: BorderRadius.circular(AppDimensions.radiusXl),
          border: Border.all(color: tint.withValues(alpha: 0.24)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              children: <Widget>[
                ScenioIconBadge(icon: _sceneIcon(scene), tint: tint, size: 52),
                const Spacer(),
                _MetaPill(label: scene.difficultyLabel),
              ],
            ),
            const SizedBox(height: AppDimensions.lg),
            Text(scene.title, style: AppTextStyles.h2),
            const SizedBox(height: AppDimensions.xs),
            Text(
              scene.description,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: AppTextStyles.bodySmall.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
            const Spacer(),
            Text(
              '${scene.characterName} • ${scene.characterRole}',
              style: AppTextStyles.labelLarge.copyWith(color: tint),
            ),
            const SizedBox(height: AppDimensions.xs),
            Text(
              '${scene.categoryLabel} • ${scene.estimatedMinutes} min',
              style: AppTextStyles.labelMedium,
            ),
            const SizedBox(height: AppDimensions.md),
            Row(
              children: <Widget>[
                TextButton(
                  onPressed: onTap,
                  child: const Text(AppStrings.scenesViewDetails),
                ),
                const Spacer(),
                ElevatedButton(
                  onPressed: onStart,
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size(112, AppDimensions.buttonHeight),
                  ),
                  child: const Text(AppStrings.scenesStartLabel),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _SceneLibraryCard extends StatelessWidget {
  const _SceneLibraryCard({
    required this.scene,
    required this.onTap,
    required this.onStart,
  });

  final SceneEntity scene;
  final VoidCallback onTap;
  final VoidCallback onStart;

  @override
  Widget build(BuildContext context) {
    final Color tint = _sceneTint(scene);

    return Container(
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
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              ScenioIconBadge(icon: _sceneIcon(scene), tint: tint, size: 48),
              const SizedBox(width: AppDimensions.lg),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(scene.title, style: AppTextStyles.h3),
                    const SizedBox(height: 2),
                    Text(
                      scene.description,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: AppTextStyles.bodySmall.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: AppDimensions.md),
          Wrap(
            spacing: AppDimensions.sm,
            runSpacing: AppDimensions.sm,
            children: <Widget>[
              _MetaPill(label: scene.categoryLabel),
              _MetaPill(label: scene.difficultyLabel),
              _MetaPill(label: '${scene.estimatedMinutes} min'),
            ],
          ),
          const SizedBox(height: AppDimensions.md),
          Text(
            '${scene.characterName} • ${scene.characterRole}',
            style: AppTextStyles.labelLarge.copyWith(color: tint),
          ),
          const SizedBox(height: AppDimensions.xs),
          Text(
            scene.mission,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.bodySmall.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: AppDimensions.lg),
          Row(
            children: <Widget>[
              Expanded(
                child: OutlinedButton(
                  onPressed: onTap,
                  style: OutlinedButton.styleFrom(
                    minimumSize: const Size.fromHeight(
                      AppDimensions.buttonHeight,
                    ),
                    side: BorderSide(
                      color: AppColors.primary300.withValues(alpha: 0.95),
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(
                        AppDimensions.radiusMd,
                      ),
                    ),
                  ),
                  child: const Text(AppStrings.scenesViewDetails),
                ),
              ),
              const SizedBox(width: AppDimensions.md),
              Expanded(
                child: ElevatedButton(
                  onPressed: onStart,
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size.fromHeight(
                      AppDimensions.buttonHeight,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(
                        AppDimensions.radiusMd,
                      ),
                    ),
                  ),
                  child: const Text(AppStrings.scenesStartLabel),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _MetaPill extends StatelessWidget {
  const _MetaPill({required this.label});

  final String label;

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
      child: Text(label, style: AppTextStyles.labelMedium),
    );
  }
}

class _HeaderStatusChip extends StatelessWidget {
  const _HeaderStatusChip({required this.label, required this.icon});

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

IconData _sceneIcon(SceneEntity scene) {
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

Color _sceneTint(SceneEntity scene) {
  switch (scene.category) {
    case SceneCategory.dailyLife:
      return AppColors.accent500;
    case SceneCategory.travel:
      return AppColors.primary800;
    case SceneCategory.work:
      return AppColors.secondary500;
    case SceneCategory.service:
      return AppColors.primary700;
  }
}
