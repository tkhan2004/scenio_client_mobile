import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../core/constants/app_colors.dart';
import '../../core/constants/app_dimensions.dart';
import '../../core/constants/app_strings.dart';
import '../../core/constants/app_text_styles.dart';
import '../home/widgets/scenio_icon_badge.dart';
import 'scene_detail_viewmodel.dart';

class SceneDetailView extends GetView<SceneDetailViewModel> {
  const SceneDetailView({super.key});

  @override
  Widget build(BuildContext context) {
    final bool hasConflict = controller.hasAnotherActiveSession;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Stack(
        children: <Widget>[
          Container(
            height: 280,
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
            ),
          ),
          SafeArea(
            bottom: false,
            child: Column(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.fromLTRB(
                    AppDimensions.xxl,
                    AppDimensions.md,
                    AppDimensions.xxl,
                    AppDimensions.xl,
                  ),
                  child: Row(
                    children: <Widget>[
                      _RoundIconButton(
                        icon: Icons.arrow_back_ios_new_rounded,
                        onTap: Get.back,
                      ),
                      const Spacer(),
                      _ScenePill(
                        label:
                            '${controller.scene.categoryLabel} • ${controller.scene.difficultyLabel}',
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: SingleChildScrollView(
                    physics: const ClampingScrollPhysics(),
                    padding: const EdgeInsets.fromLTRB(
                      AppDimensions.xxl,
                      0,
                      AppDimensions.xxl,
                      AppDimensions.xl,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          controller.scene.title,
                          style: AppTextStyles.displayLarge.copyWith(
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: AppDimensions.xs),
                        Text(
                          controller.scene.description,
                          style: AppTextStyles.bodyLarge.copyWith(
                            color: Colors.white.withValues(alpha: 0.9),
                          ),
                        ),
                        const SizedBox(height: AppDimensions.xl),
                        Container(
                          padding: const EdgeInsets.all(AppDimensions.xl),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(
                              AppDimensions.radiusXl,
                            ),
                            boxShadow: <BoxShadow>[
                              BoxShadow(
                                color: AppColors.primary900.withValues(
                                  alpha: 0.08,
                                ),
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
                                  ScenioIconBadge(
                                    icon: controller.iconForScene(),
                                    tint: AppColors.primary800,
                                    size: 58,
                                  ),
                                  const SizedBox(width: AppDimensions.lg),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Text(
                                          AppStrings.sceneDetailCharacterTitle,
                                          style: AppTextStyles.labelMedium,
                                        ),
                                        const SizedBox(height: 2),
                                        Text(
                                          controller.scene.characterName,
                                          style: AppTextStyles.h2,
                                        ),
                                        const SizedBox(height: 2),
                                        Text(
                                          '${controller.scene.characterRole} • ${AppStrings.sceneDetailAiBadge}',
                                          style: AppTextStyles.bodySmall
                                              .copyWith(
                                                color: AppColors.textSecondary,
                                              ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: AppDimensions.xl),
                              _DetailSection(
                                title: AppStrings.sceneDetailSceneMetaTitle,
                                child: Wrap(
                                  spacing: AppDimensions.sm,
                                  runSpacing: AppDimensions.sm,
                                  children: <Widget>[
                                    _ScenePill(
                                      label:
                                          '${controller.scene.estimatedMinutes} min',
                                    ),
                                    _ScenePill(
                                      label: controller.scene.categoryLabel,
                                    ),
                                    _ScenePill(
                                      label: controller.scene.difficultyLabel,
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: AppDimensions.lg),
                              _DetailSection(
                                title: AppStrings.sceneDetailMissionTitle,
                                child: Container(
                                  width: double.infinity,
                                  padding: const EdgeInsets.all(
                                    AppDimensions.lg,
                                  ),
                                  decoration: BoxDecoration(
                                    color: AppColors.accent50,
                                    borderRadius: BorderRadius.circular(
                                      AppDimensions.radiusLg,
                                    ),
                                  ),
                                  child: Text(
                                    controller.scene.mission,
                                    style: AppTextStyles.bodyMedium.copyWith(
                                      color: AppColors.neutral900,
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(height: AppDimensions.lg),
                              _DetailSection(
                                title: AppStrings.sceneDetailVocabularyTitle,
                                child: Wrap(
                                  spacing: AppDimensions.sm,
                                  runSpacing: AppDimensions.sm,
                                  children: controller.scene.vocabularyPreview
                                      .map(
                                        (String word) =>
                                            _VocabularyPill(label: word),
                                      )
                                      .toList(),
                                ),
                              ),
                              if (hasConflict) ...<Widget>[
                                const SizedBox(height: AppDimensions.lg),
                                Container(
                                  width: double.infinity,
                                  padding: const EdgeInsets.all(
                                    AppDimensions.lg,
                                  ),
                                  decoration: BoxDecoration(
                                    color: AppColors.secondary50,
                                    borderRadius: BorderRadius.circular(
                                      AppDimensions.radiusLg,
                                    ),
                                  ),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Text(
                                        AppStrings.sceneDetailConflictTitle,
                                        style: AppTextStyles.h3.copyWith(
                                          color: AppColors.secondary700,
                                        ),
                                      ),
                                      const SizedBox(height: AppDimensions.xs),
                                      Text(
                                        AppStrings.sceneDetailConflictSubtitle,
                                        style: AppTextStyles.bodySmall.copyWith(
                                          color: AppColors.textSecondary,
                                        ),
                                      ),
                                      const SizedBox(height: AppDimensions.sm),
                                      Text(
                                        '${controller.otherSession?.sceneTitle ?? ''} • ${controller.otherSession?.completedTurns ?? 0}/${controller.otherSession?.targetTurns ?? 0} turns',
                                        style: AppTextStyles.labelLarge
                                            .copyWith(
                                              color: AppColors.secondary700,
                                            ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(
            AppDimensions.xxl,
            AppDimensions.md,
            AppDimensions.xxl,
            AppDimensions.xl,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              ElevatedButton(
                onPressed: controller.handlePrimaryCta,
                child: Text(controller.primaryCtaLabel),
              ),
              if (hasConflict) ...<Widget>[
                const SizedBox(height: AppDimensions.sm),
                OutlinedButton(
                  onPressed: controller.forceStartNew,
                  child: const Text(AppStrings.sceneDetailStartNewButton),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class _DetailSection extends StatelessWidget {
  const _DetailSection({required this.title, required this.child});

  final String title;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(title, style: AppTextStyles.h3),
        const SizedBox(height: AppDimensions.sm),
        child,
      ],
    );
  }
}

class _ScenePill extends StatelessWidget {
  const _ScenePill({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppDimensions.md,
        vertical: AppDimensions.sm,
      ),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.16),
        borderRadius: BorderRadius.circular(AppDimensions.radiusFull),
        border: Border.all(color: Colors.white.withValues(alpha: 0.2)),
      ),
      child: Text(
        label,
        style: AppTextStyles.labelMedium.copyWith(color: Colors.white),
      ),
    );
  }
}

class _VocabularyPill extends StatelessWidget {
  const _VocabularyPill({required this.label});

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

class _RoundIconButton extends StatelessWidget {
  const _RoundIconButton({required this.icon, required this.onTap});

  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.14),
          borderRadius: BorderRadius.circular(AppDimensions.radiusFull),
          border: Border.all(color: Colors.white.withValues(alpha: 0.18)),
        ),
        alignment: Alignment.center,
        child: Icon(icon, size: AppDimensions.iconSm, color: Colors.white),
      ),
    );
  }
}
