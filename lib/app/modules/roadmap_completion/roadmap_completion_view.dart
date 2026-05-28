import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../core/constants/app_colors.dart';
import '../../core/constants/app_dimensions.dart';
import '../../core/constants/app_text_styles.dart';
import '../../data/models/learning_plan_model.dart';
import '../home/widgets/scenio_icon_badge.dart';
import 'roadmap_completion_viewmodel.dart';

class RoadmapCompletionView extends GetView<RoadmapCompletionViewModel> {
  const RoadmapCompletionView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Obx(() {
          if (controller.isLoading.value && controller.summary.value == null) {
            return const Center(child: CircularProgressIndicator());
          }

          return SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.fromLTRB(
              AppDimensions.xxl,
              AppDimensions.lg,
              AppDimensions.xxl,
              AppDimensions.xxxl,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                IconButton(
                  onPressed: controller.backHome,
                  icon: const Icon(Icons.close_rounded),
                  style: IconButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: AppColors.primary800,
                    side: const BorderSide(color: AppColors.primary200),
                  ),
                ),
                const SizedBox(height: AppDimensions.lg),
                _CompletionHero(controller: controller),
                const SizedBox(height: AppDimensions.xl),
                Text('Tiến bộ nổi bật'.tr, style: AppTextStyles.h2),
                const SizedBox(height: AppDimensions.md),
                _ProgressDeltaGrid(delta: controller.scoreDelta),
                const SizedBox(height: AppDimensions.xl),
                Text('Scene đã hoàn thành'.tr, style: AppTextStyles.h2),
                const SizedBox(height: AppDimensions.md),
                Wrap(
                  spacing: AppDimensions.sm,
                  runSpacing: AppDimensions.sm,
                  children: controller.completedScenes
                      .map((String title) => _SceneChip(title: title))
                      .toList(growable: false),
                ),
                const SizedBox(height: AppDimensions.xl),
                _RewardSummaryCard(controller: controller),
                const SizedBox(height: AppDimensions.xl),
                _NextRoadmapCard(
                  title: controller.nextRoadmapTitle,
                  isLoading: controller.isStartingNext.value,
                  onStart: controller.startNextRoadmap,
                ),
              ],
            ),
          );
        }),
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
          child: Obx(
            () => ElevatedButton(
              onPressed: controller.isLoading.value
                  ? null
                  : controller.backHome,
              child: Text('Back to Home'.tr),
            ),
          ),
        ),
      ),
    );
  }
}

class _CompletionHero extends StatelessWidget {
  const _CompletionHero({required this.controller});

  final RoadmapCompletionViewModel controller;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppDimensions.xl),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: <Color>[AppColors.primary900, AppColors.primary700],
        ),
        borderRadius: BorderRadius.circular(AppDimensions.radiusXl),
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: AppColors.primary900.withValues(alpha: 0.18),
            blurRadius: 28,
            offset: const Offset(0, 14),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          ScenioIconBadge(
            icon: Icons.workspace_premium_rounded,
            tint: AppColors.accent500,
            size: 64,
            iconColor: AppColors.accent500,
          ),
          const SizedBox(height: AppDimensions.lg),
          Text(
            'Roadmap completed'.tr,
            style: AppTextStyles.displayMedium.copyWith(color: Colors.white),
          ),
          const SizedBox(height: AppDimensions.sm),
          Text(
            'You finished ${controller.title} and earned ${controller.xpBonus} XP.',
            style: AppTextStyles.bodyMedium.copyWith(
              color: Colors.white.withValues(alpha: 0.82),
            ),
          ),
          const SizedBox(height: AppDimensions.lg),
          Wrap(
            spacing: AppDimensions.sm,
            runSpacing: AppDimensions.sm,
            children: <Widget>[
              _LightPill(label: controller.level, icon: Icons.school_rounded),
              _LightPill(
                label: controller.badgeTitle,
                icon: Icons.military_tech_rounded,
              ),
              _LightPill(
                label: '+${controller.xpBonus} XP',
                icon: Icons.bolt_rounded,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _ProgressDeltaGrid extends StatelessWidget {
  const _ProgressDeltaGrid({required this.delta});

  final RoadmapScoreDeltaModel delta;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Expanded(
          child: _DeltaCard(
            label: 'Grammar',
            before: delta.grammar.before,
            after: delta.grammar.after,
          ),
        ),
        const SizedBox(width: AppDimensions.md),
        Expanded(
          child: _DeltaCard(
            label: 'Vocabulary',
            before: delta.vocabulary.before,
            after: delta.vocabulary.after,
          ),
        ),
        const SizedBox(width: AppDimensions.md),
        Expanded(
          child: _DeltaCard(
            label: 'Natural',
            before: delta.naturalness.before,
            after: delta.naturalness.after,
          ),
        ),
      ],
    );
  }
}

class _DeltaCard extends StatelessWidget {
  const _DeltaCard({
    required this.label,
    required this.before,
    required this.after,
  });

  final String label;
  final int before;
  final int after;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppDimensions.md),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppDimensions.radiusLg),
        border: Border.all(color: AppColors.primary200.withValues(alpha: 0.9)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(label.tr, style: AppTextStyles.labelMedium),
          const SizedBox(height: AppDimensions.sm),
          Text(
            '$before → $after',
            style: AppTextStyles.h3.copyWith(color: AppColors.primary700),
          ),
        ],
      ),
    );
  }
}

class _SceneChip extends StatelessWidget {
  const _SceneChip({required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppDimensions.md,
        vertical: AppDimensions.sm,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppDimensions.radiusFull),
        border: Border.all(color: AppColors.primary200),
      ),
      child: Text(
        title,
        style: AppTextStyles.labelMedium.copyWith(color: AppColors.primary800),
      ),
    );
  }
}

class _RewardSummaryCard extends StatelessWidget {
  const _RewardSummaryCard({required this.controller});

  final RoadmapCompletionViewModel controller;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppDimensions.lg),
      decoration: BoxDecoration(
        color: AppColors.accent50.withValues(alpha: 0.8),
        borderRadius: BorderRadius.circular(AppDimensions.radiusXl),
        border: Border.all(color: AppColors.accent200.withValues(alpha: 0.7)),
      ),
      child: Row(
        children: <Widget>[
          ScenioIconBadge(
            icon: Icons.emoji_events_rounded,
            tint: AppColors.accent500,
            size: 52,
            iconColor: AppColors.accent500,
          ),
          const SizedBox(width: AppDimensions.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text('Badge earned'.tr, style: AppTextStyles.h3),
                const SizedBox(height: 2),
                Text(
                  '${controller.badgeTitle} • +${controller.xpBonus} XP',
                  style: AppTextStyles.bodySmall.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _NextRoadmapCard extends StatelessWidget {
  const _NextRoadmapCard({
    required this.title,
    required this.isLoading,
    required this.onStart,
  });

  final String title;
  final bool isLoading;
  final VoidCallback onStart;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppDimensions.lg),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppDimensions.radiusXl),
        border: Border.all(color: AppColors.primary200.withValues(alpha: 0.9)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text('Recommended next roadmap'.tr, style: AppTextStyles.h3),
          const SizedBox(height: AppDimensions.xs),
          Text(
            title,
            style: AppTextStyles.bodyMedium.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: AppDimensions.md),
          SizedBox(
            width: 172,
            child: OutlinedButton(
              onPressed: isLoading ? null : onStart,
              style: OutlinedButton.styleFrom(minimumSize: const Size(172, 44)),
              child: Text(
                isLoading ? 'Đang lưu...'.tr : 'Start next roadmap'.tr,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _LightPill extends StatelessWidget {
  const _LightPill({required this.label, required this.icon});

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
        color: Colors.white.withValues(alpha: 0.13),
        borderRadius: BorderRadius.circular(AppDimensions.radiusFull),
        border: Border.all(color: Colors.white.withValues(alpha: 0.22)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Icon(icon, size: AppDimensions.iconSm, color: Colors.white),
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
