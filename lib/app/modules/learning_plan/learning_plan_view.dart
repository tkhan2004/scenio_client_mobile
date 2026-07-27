import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../core/constants/app_colors.dart';
import '../../core/constants/app_dimensions.dart';
import '../../core/constants/app_text_styles.dart';
import '../../data/models/learning_plan_model.dart';
import '../../routes/app_routes.dart';
import '../home/widgets/scenio_icon_badge.dart';
import 'learning_plan_viewmodel.dart';

class LearningPlanView extends GetView<LearningPlanViewModel> {
  const LearningPlanView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        bottom: false,
        child: Obx(() {
          final LearningPlanResponseModel? plan = controller.currentPlan;

          if (controller.isLoading.value && plan == null) {
            return const _LearningPlanLoadingState();
          }

          if (plan == null) {
            return _LearningPlanEmptyState(onRetry: controller.load);
          }

          return CustomScrollView(
            physics: const BouncingScrollPhysics(),
            slivers: <Widget>[
              SliverPadding(
                padding: const EdgeInsets.fromLTRB(
                  AppDimensions.xxl,
                  AppDimensions.lg,
                  AppDimensions.xxl,
                  AppDimensions.xl,
                ),
                sliver: SliverList(
                  delegate: SliverChildListDelegate.fixed(<Widget>[
                    const _LearningPlanTopBar(),
                    const SizedBox(height: AppDimensions.xl),
                    _LearningPlanHero(
                      plan: plan,
                      isRefreshing: controller.isRefreshing.value,
                      onRefresh: controller.refreshPlan,
                      onStartNext: controller.openNextStep,
                    ),
                    const SizedBox(height: AppDimensions.lg),
                    _ExpectedOutcomeCard(plan: plan),
                    const SizedBox(height: AppDimensions.md),
                    _CompletionRuleCard(plan: plan),
                    const SizedBox(height: AppDimensions.xxl),
                    Text('Roadmap tổng thể'.tr, style: AppTextStyles.h2),
                    const SizedBox(height: AppDimensions.md),
                    ...plan.steps.map(
                      (LearningPlanStepModel step) => Padding(
                        padding: const EdgeInsets.only(
                          bottom: AppDimensions.md,
                        ),
                        child: _RoadmapStepCard(
                          step: step,
                          isCompleting:
                              controller.completingStepId.value == step.id,
                          onOpen: () => controller.openStep(step),
                          onComplete: () => controller.completeStep(step),
                        ),
                      ),
                    ),
                    const SizedBox(height: AppDimensions.lg),
                    _RoadmapRewardCard(plan: plan),
                    const SizedBox(height: AppDimensions.md),
                    _PlannedFeedbackCard(plan: plan),
                    SizedBox(
                      height:
                          MediaQuery.paddingOf(context).bottom +
                          AppDimensions.xxxl,
                    ),
                  ]),
                ),
              ),
            ],
          );
        }),
      ),
    );
  }
}

class _LearningPlanTopBar extends StatelessWidget {
  const _LearningPlanTopBar();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        IconButton(
          onPressed: Get.back,
          icon: const Icon(Icons.arrow_back_rounded),
          style: IconButton.styleFrom(
            backgroundColor: Colors.white,
            foregroundColor: AppColors.primary800,
            side: const BorderSide(color: AppColors.primary200),
          ),
        ),
        const SizedBox(width: AppDimensions.md),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text('Lộ trình học'.tr, style: AppTextStyles.h2),
              const SizedBox(height: 2),
              Text(
                'Roadmap, lịch luyện tập và feedback'.tr,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: AppTextStyles.bodySmall.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _LearningPlanHero extends StatelessWidget {
  const _LearningPlanHero({
    required this.plan,
    required this.isRefreshing,
    required this.onRefresh,
    required this.onStartNext,
  });

  final LearningPlanResponseModel plan;
  final bool isRefreshing;
  final VoidCallback onRefresh;
  final VoidCallback onStartNext;

  @override
  Widget build(BuildContext context) {
    final LearningPlanModel meta = plan.plan;
    final LearningPlanNextStepModel? nextStep = plan.nextStep;

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppDimensions.lg,
        vertical: AppDimensions.md,
      ),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: <Color>[AppColors.primary900, AppColors.primary700],
        ),
        borderRadius: BorderRadius.circular(AppDimensions.radiusXl),
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: AppColors.primary900.withValues(alpha: 0.16),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            children: <Widget>[
              ScenioIconBadge(
                icon: Icons.route_rounded,
                tint: AppColors.accent500,
                size: 44,
                iconColor: AppColors.primary800,
              ),
              const Spacer(),
              _HeroActionChip(
                label: isRefreshing ? 'Đang làm mới'.tr : 'Làm mới'.tr,
                icon: Icons.refresh_rounded,
                onTap: isRefreshing ? null : onRefresh,
              ),
            ],
          ),
          const SizedBox(height: AppDimensions.md),
          Text(
            meta.title,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.h2.copyWith(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            meta.targetOutcome?.trim().isNotEmpty == true
                ? meta.targetOutcome!
                : meta.summary.isEmpty
                ? 'Scenio sẽ điều chỉnh lộ trình sau mỗi phiên luyện tập.'.tr
                : meta.summary,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.bodySmall.copyWith(
              color: Colors.white.withValues(alpha: 0.82),
            ),
          ),
          const SizedBox(height: AppDimensions.md),
          ClipRRect(
            borderRadius: BorderRadius.circular(AppDimensions.radiusFull),
            child: LinearProgressIndicator(
              value: plan.progress,
              minHeight: 6,
              backgroundColor: Colors.white.withValues(alpha: 0.2),
              valueColor: const AlwaysStoppedAnimation<Color>(
                AppColors.accent200,
              ),
            ),
          ),
          const SizedBox(height: AppDimensions.xs),
          Text(
            '${plan.completedSteps}/${plan.totalSteps} ${'bước đã hoàn thành'.tr}',
            style: AppTextStyles.caption.copyWith(
              color: Colors.white.withValues(alpha: 0.86),
            ),
          ),
          const SizedBox(height: AppDimensions.md),
          Wrap(
            spacing: AppDimensions.xs,
            runSpacing: AppDimensions.xs,
            children: <Widget>[
              _LightPlanChip(label: meta.level, icon: Icons.school_rounded),
              _LightPlanChip(
                label: _labelForGoal(meta.learningGoal),
                icon: Icons.flag_rounded,
              ),
              _LightPlanChip(
                label: _labelForFocus(meta.focusSkill),
                icon: Icons.auto_awesome_rounded,
              ),
              _LightPlanChip(
                label: '${meta.weeklyTarget} ${'buổi/tuần'.tr}',
                icon: Icons.calendar_month_rounded,
              ),
            ],
          ),
          if (nextStep != null) ...<Widget>[
            const SizedBox(height: AppDimensions.md),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(
                horizontal: AppDimensions.md,
                vertical: 10,
              ),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.13),
                borderRadius: BorderRadius.circular(AppDimensions.radiusLg),
                border: Border.all(color: Colors.white.withValues(alpha: 0.2)),
              ),
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          'Bước tiếp theo'.tr,
                          style: AppTextStyles.caption.copyWith(
                            color: Colors.white.withValues(alpha: 0.72),
                            fontSize: 10,
                          ),
                        ),
                        const SizedBox(height: 1),
                        Text(
                          nextStep.title,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: AppTextStyles.labelMedium.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: AppDimensions.sm),
                  SizedBox(
                    width: 76,
                    height: 32,
                    child: ElevatedButton(
                      onPressed: onStartNext,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: AppColors.primary800,
                        minimumSize: const Size(76, 32),
                        padding: const EdgeInsets.symmetric(
                          horizontal: AppDimensions.sm,
                          vertical: 0,
                        ),
                      ),
                      child: Text('Mở'.tr, style: const TextStyle(fontSize: 12)),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _HeroActionChip extends StatelessWidget {
  const _HeroActionChip({
    required this.label,
    required this.icon,
    required this.onTap,
  });

  final String label;
  final IconData icon;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppDimensions.radiusFull),
      child: Container(
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
      ),
    );
  }
}

class _RoadmapStepCard extends StatelessWidget {
  const _RoadmapStepCard({
    required this.step,
    required this.isCompleting,
    required this.onOpen,
    required this.onComplete,
  });

  final LearningPlanStepModel step;
  final bool isCompleting;
  final VoidCallback onOpen;
  final VoidCallback onComplete;

  @override
  Widget build(BuildContext context) {
    final bool isCompleted = step.status == 'COMPLETED';
    final bool isLocked = step.status == 'LOCKED';
    final double progress = step.targetCount == 0
        ? 0
        : (step.completedCount / step.targetCount).clamp(0, 1).toDouble();

    return Container(
      padding: const EdgeInsets.all(AppDimensions.lg),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppDimensions.radiusXl),
        border: Border.all(color: AppColors.primary200.withValues(alpha: 0.9)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              _StepStatusMark(status: step.status),
              const SizedBox(width: AppDimensions.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      'Bước ${step.sortOrder + 1} • ${_labelForStatus(step.status)}',
                      style: AppTextStyles.labelMedium.copyWith(
                        color: isCompleted
                            ? AppColors.secondary500
                            : AppColors.primary700,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      step.title,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: AppTextStyles.h3,
                    ),
                    if (step.description?.trim().isNotEmpty ==
                        true) ...<Widget>[
                      const SizedBox(height: AppDimensions.xs),
                      Text(
                        step.description!,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: AppTextStyles.bodySmall.copyWith(
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: AppDimensions.md),
          Row(
            children: <Widget>[
              Expanded(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(AppDimensions.radiusFull),
                  child: LinearProgressIndicator(
                    value: progress,
                    minHeight: 7,
                    backgroundColor: AppColors.primary50,
                    valueColor: AlwaysStoppedAnimation<Color>(
                      isCompleted
                          ? AppColors.secondary500
                          : AppColors.primary700,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: AppDimensions.md),
              Text(
                '${step.completedCount}/${step.targetCount}',
                style: AppTextStyles.labelMedium.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppDimensions.md),
          Wrap(
            spacing: AppDimensions.sm,
            runSpacing: AppDimensions.sm,
            children: <Widget>[
              _SubtlePlanChip(
                icon: Icons.psychology_alt_rounded,
                label: _labelForFocus(step.focusSkill),
              ),
              if (step.scene != null)
                _SubtlePlanChip(
                  icon: Icons.theater_comedy_rounded,
                  label: step.scene!.title,
                ),
            ],
          ),
          if (!isLocked && !isCompleted) ...<Widget>[
            const SizedBox(height: AppDimensions.md),
            Row(
              children: <Widget>[
                Expanded(
                  child: OutlinedButton(
                    onPressed: onOpen,
                    child: Text('Mở bước học'.tr),
                  ),
                ),
                const SizedBox(width: AppDimensions.sm),
                Expanded(
                  child: TextButton(
                    onPressed: isCompleting ? null : onComplete,
                    child: Text(
                      isCompleting ? 'Đang lưu...'.tr : 'Đánh dấu xong'.tr,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}

class _StepStatusMark extends StatelessWidget {
  const _StepStatusMark({required this.status});

  final String status;

  @override
  Widget build(BuildContext context) {
    final bool isCompleted = status == 'COMPLETED';
    final bool isLocked = status == 'LOCKED';

    return Container(
      width: 42,
      height: 42,
      decoration: BoxDecoration(
        color: isCompleted
            ? AppColors.secondary50
            : isLocked
            ? AppColors.neutral100
            : AppColors.primary50,
        borderRadius: BorderRadius.circular(AppDimensions.radiusLg),
      ),
      child: Icon(
        isCompleted
            ? Icons.check_rounded
            : isLocked
            ? Icons.lock_outline_rounded
            : Icons.play_arrow_rounded,
        color: isCompleted
            ? AppColors.secondary500
            : isLocked
            ? AppColors.textSecondary
            : AppColors.primary700,
      ),
    );
  }
}

class _ExpectedOutcomeCard extends StatelessWidget {
  const _ExpectedOutcomeCard({required this.plan});

  final LearningPlanResponseModel plan;

  @override
  Widget build(BuildContext context) {
    final List<String> outcomes = _expectedOutcomes(plan.plan);

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
          Row(
            children: <Widget>[
              ScenioIconBadge(
                icon: Icons.flag_rounded,
                tint: AppColors.secondary500,
                size: 44,
                iconColor: AppColors.secondary700,
              ),
              const SizedBox(width: AppDimensions.md),
              Expanded(
                child: Text(
                  'Sau roadmap này bạn sẽ làm được gì?'.tr,
                  style: AppTextStyles.h3,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppDimensions.md),
          ...List<Widget>.generate(outcomes.length, (int index) {
            return Padding(
              padding: EdgeInsets.only(
                bottom: index == outcomes.length - 1 ? 0 : AppDimensions.sm,
              ),
              child: _OutcomeLine(text: outcomes[index]),
            );
          }),
        ],
      ),
    );
  }
}

class _CompletionRuleCard extends StatelessWidget {
  const _CompletionRuleCard({required this.plan});

  final LearningPlanResponseModel plan;

  @override
  Widget build(BuildContext context) {
    final LearningPlanCompletionCriteriaModel criteria =
        plan.plan.completionCriteria;
    final int coreScenes = criteria.requiredCoreScenes > 0
        ? criteria.requiredCoreScenes
        : plan.steps
              .where((LearningPlanStepModel step) => step.type == 'SCENE')
              .length;
    final int requiredSteps = criteria.requiredSteps > 0
        ? criteria.requiredSteps
        : plan.totalSteps;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppDimensions.lg),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: <Color>[
            AppColors.primary50.withValues(alpha: 0.86),
            Colors.white,
          ],
        ),
        borderRadius: BorderRadius.circular(AppDimensions.radiusXl),
        border: Border.all(color: AppColors.primary200.withValues(alpha: 0.9)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text('Cách hoàn thành roadmap'.tr, style: AppTextStyles.h3),
          const SizedBox(height: AppDimensions.md),
          Wrap(
            spacing: AppDimensions.sm,
            runSpacing: AppDimensions.sm,
            children: <Widget>[
              _RulePill(
                icon: Icons.checklist_rounded,
                label: '$requiredSteps ${'bước học'.tr}',
              ),
              _RulePill(
                icon: Icons.theater_comedy_rounded,
                label: '$coreScenes ${'scene chính'.tr}',
              ),
              _RulePill(
                icon: Icons.bar_chart_rounded,
                label: 'Điểm gần đây >= 70'.tr.replaceAll(
                  '70',
                  '${criteria.minimumRecentAverageScore}',
                ),
              ),
            ],
          ),
          const SizedBox(height: AppDimensions.md),
          Text(
            'Scenio sẽ cập nhật bước tiếp theo sau mỗi phiên để roadmap luôn bám theo điểm mạnh/yếu mới nhất của bạn.'
                .tr,
            style: AppTextStyles.bodySmall.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}

class _RoadmapRewardCard extends StatelessWidget {
  const _RoadmapRewardCard({required this.plan});

  final LearningPlanResponseModel plan;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppDimensions.xl),
      decoration: BoxDecoration(
        color: AppColors.accent50.withValues(alpha: 0.78),
        borderRadius: BorderRadius.circular(AppDimensions.radiusXl),
        border: Border.all(color: AppColors.accent200.withValues(alpha: 0.6)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            children: <Widget>[
              ScenioIconBadge(
                icon: Icons.workspace_premium_rounded,
                tint: AppColors.accent500,
                size: 48,
                iconColor: AppColors.accent500,
              ),
              const SizedBox(width: AppDimensions.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      'Mở khóa sau khi hoàn thành'.tr,
                      style: AppTextStyles.h3,
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'Roadmap có phần thưởng rõ ràng để demo thấy được giá trị sau quá trình học.'
                          .tr,
                      style: AppTextStyles.bodySmall.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: AppDimensions.lg),
          Wrap(
            spacing: AppDimensions.sm,
            runSpacing: AppDimensions.sm,
            children: <Widget>[
              _RewardChip(
                icon: Icons.military_tech_rounded,
                label: plan.plan.reward.badgeTitle.isNotEmpty
                    ? plan.plan.reward.badgeTitle
                    : '${plan.plan.level} completion badge',
              ),
              _RewardChip(
                icon: Icons.bolt_rounded,
                label:
                    '+${plan.plan.reward.xpBonus > 0 ? plan.plan.reward.xpBonus : 120} bonus XP',
              ),
              _RewardChip(
                icon: Icons.route_rounded,
                label: 'Next roadmap suggestion'.tr,
              ),
            ],
          ),
          const SizedBox(height: AppDimensions.lg),
          if (plan.completionSummary != null ||
              plan.plan.isCompleted) ...<Widget>[
            const SizedBox(height: AppDimensions.lg),
            SizedBox(
              width: 184,
              child: OutlinedButton(
                onPressed: () =>
                    Get.toNamed(Routes.roadmapCompletion, arguments: plan),
                style: OutlinedButton.styleFrom(
                  minimumSize: const Size(184, 44),
                ),
                child: Text('Preview summary'.tr),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _OutcomeLine extends StatelessWidget {
  const _OutcomeLine({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Container(
          width: 22,
          height: 22,
          decoration: BoxDecoration(
            color: AppColors.secondary50,
            borderRadius: BorderRadius.circular(AppDimensions.radiusFull),
          ),
          child: const Icon(
            Icons.check_rounded,
            size: 15,
            color: AppColors.secondary500,
          ),
        ),
        const SizedBox(width: AppDimensions.sm),
        Expanded(
          child: Text(
            text,
            style: AppTextStyles.bodySmall.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
        ),
      ],
    );
  }
}

class _RulePill extends StatelessWidget {
  const _RulePill({required this.icon, required this.label});

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return _SubtlePlanChip(icon: icon, label: label);
  }
}

class _RewardChip extends StatelessWidget {
  const _RewardChip({required this.icon, required this.label});

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
        color: Colors.white.withValues(alpha: 0.76),
        borderRadius: BorderRadius.circular(AppDimensions.radiusFull),
        border: Border.all(color: AppColors.accent200.withValues(alpha: 0.6)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Icon(icon, size: AppDimensions.iconSm, color: AppColors.accent500),
          const SizedBox(width: AppDimensions.xs),
          Text(
            label,
            style: AppTextStyles.labelMedium.copyWith(
              color: AppColors.neutral700,
            ),
          ),
        ],
      ),
    );
  }
}

class _PlannedFeedbackCard extends StatelessWidget {
  const _PlannedFeedbackCard({required this.plan});

  final LearningPlanResponseModel plan;

  @override
  Widget build(BuildContext context) {
    final List<LearningPlanStepModel> openSteps = plan.steps
        .where((LearningPlanStepModel step) => step.status != 'COMPLETED')
        .take(3)
        .toList(growable: false);

    return Container(
      padding: const EdgeInsets.all(AppDimensions.xl),
      decoration: BoxDecoration(
        color: AppColors.primary50.withValues(alpha: 0.72),
        borderRadius: BorderRadius.circular(AppDimensions.radiusXl),
        border: Border.all(color: AppColors.primary200.withValues(alpha: 0.9)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            children: <Widget>[
              ScenioIconBadge(
                icon: Icons.event_available_rounded,
                tint: AppColors.primary700,
                size: 46,
              ),
              const SizedBox(width: AppDimensions.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      'Lịch luyện tập và feedback'.tr,
                      style: AppTextStyles.h3,
                    ),
                    const SizedBox(height: 2),
                    Text(
                      '${plan.plan.weeklyTarget} ${'buổi mỗi tuần, feedback sau từng phiên'.tr}',
                      style: AppTextStyles.bodySmall.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: AppDimensions.lg),
          _FeedbackRow(
            icon: Icons.rate_review_rounded,
            title: 'Feedback ưu tiên'.tr,
            subtitle:
                '${_labelForFocus(plan.plan.focusSkill)} • ${'sửa lỗi theo transcript và kết quả nói'.tr}',
          ),
          const SizedBox(height: AppDimensions.md),
          _FeedbackRow(
            icon: Icons.timeline_rounded,
            title: 'Checkpoint tiếp theo'.tr,
            subtitle:
                plan.nextStep?.title ??
                'Hoàn thành phiên tiếp theo để mở đề xuất mới.'.tr,
          ),
          if (openSteps.isNotEmpty) ...<Widget>[
            const SizedBox(height: AppDimensions.lg),
            Text('Lịch gợi ý'.tr, style: AppTextStyles.labelLarge),
            const SizedBox(height: AppDimensions.sm),
            ...openSteps.indexed.map(
              ((int, LearningPlanStepModel) item) => Padding(
                padding: EdgeInsets.only(
                  bottom: item.$1 == openSteps.length - 1
                      ? 0
                      : AppDimensions.sm,
                ),
                child: _SchedulePill(
                  index: item.$1 + 1,
                  title: item.$2.title,
                  focus: _labelForFocus(item.$2.focusSkill),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _FeedbackRow extends StatelessWidget {
  const _FeedbackRow({
    required this.icon,
    required this.title,
    required this.subtitle,
  });

  final IconData icon;
  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Icon(icon, color: AppColors.primary700, size: AppDimensions.iconMd),
        const SizedBox(width: AppDimensions.md),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(title, style: AppTextStyles.labelLarge),
              const SizedBox(height: 2),
              Text(
                subtitle,
                style: AppTextStyles.bodySmall.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _SchedulePill extends StatelessWidget {
  const _SchedulePill({
    required this.index,
    required this.title,
    required this.focus,
  });

  final int index;
  final String title;
  final String focus;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppDimensions.md),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.78),
        borderRadius: BorderRadius.circular(AppDimensions.radiusLg),
        border: Border.all(color: AppColors.primary200),
      ),
      child: Row(
        children: <Widget>[
          Text(
            'Buổi $index',
            style: AppTextStyles.labelMedium.copyWith(
              color: AppColors.primary700,
            ),
          ),
          const SizedBox(width: AppDimensions.md),
          Expanded(
            child: Text(
              title,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: AppTextStyles.labelLarge,
            ),
          ),
          const SizedBox(width: AppDimensions.sm),
          Text(
            focus,
            style: AppTextStyles.caption.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}

class _LightPlanChip extends StatelessWidget {
  const _LightPlanChip({required this.label, required this.icon});

  final String label;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppDimensions.sm,
        vertical: 6,
      ),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.14),
        borderRadius: BorderRadius.circular(AppDimensions.radiusFull),
        border: Border.all(color: Colors.white.withValues(alpha: 0.22)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Icon(icon, color: Colors.white, size: 14),
          const SizedBox(width: 6),
          Text(
            label,
            style: AppTextStyles.caption.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

class _SubtlePlanChip extends StatelessWidget {
  const _SubtlePlanChip({required this.icon, required this.label});

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
        color: AppColors.primary50,
        borderRadius: BorderRadius.circular(AppDimensions.radiusFull),
        border: Border.all(color: AppColors.primary200),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Icon(icon, size: AppDimensions.iconSm, color: AppColors.primary700),
          const SizedBox(width: AppDimensions.xs),
          ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 190),
            child: Text(
              label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: AppTextStyles.labelMedium.copyWith(
                color: AppColors.primary800,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _LearningPlanLoadingState extends StatelessWidget {
  const _LearningPlanLoadingState();

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: CircularProgressIndicator(color: AppColors.primary700),
    );
  }
}

class _LearningPlanEmptyState extends StatelessWidget {
  const _LearningPlanEmptyState({required this.onRetry});

  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(AppDimensions.xxl),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          ScenioIconBadge(
            icon: Icons.route_rounded,
            tint: AppColors.primary700,
            size: 72,
          ),
          const SizedBox(height: AppDimensions.lg),
          Text('Chưa có lộ trình học'.tr, style: AppTextStyles.h2),
          const SizedBox(height: AppDimensions.sm),
          Text(
            'Hoàn tất onboarding để Scenio tạo roadmap phù hợp.'.tr,
            textAlign: TextAlign.center,
            style: AppTextStyles.bodyMedium.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: AppDimensions.xl),
          ElevatedButton(onPressed: onRetry, child: Text('Tải lại'.tr)),
        ],
      ),
    );
  }
}

String _labelForGoal(String? value) {
  switch (value) {
    case 'WORK':
      return 'Công việc'.tr;
    case 'TRAVEL':
      return 'Du lịch'.tr;
    case 'DAILY':
      return 'Đời sống'.tr;
    case 'ALL':
      return 'Kết hợp'.tr;
    default:
      return 'Cá nhân hóa'.tr;
  }
}

String _labelForFocus(String value) {
  switch (value) {
    case 'VOCABULARY':
      return 'Từ vựng'.tr;
    case 'GRAMMAR':
      return 'Ngữ pháp'.tr;
    case 'CONFIDENCE':
      return 'Tự tin'.tr;
    case 'NATURALNESS':
    default:
      return 'Tự nhiên'.tr;
  }
}

String _labelForStatus(String value) {
  switch (value) {
    case 'COMPLETED':
      return 'Hoàn thành'.tr;
    case 'LOCKED':
      return 'Đang khóa'.tr;
    case 'IN_PROGRESS':
      return 'Đang học'.tr;
    default:
      return 'Sẵn sàng'.tr;
  }
}

List<String> _expectedOutcomes(LearningPlanModel plan) {
  final String? targetOutcome = plan.targetOutcome?.trim();
  if (targetOutcome != null && targetOutcome.isNotEmpty) {
    return <String>[
      targetOutcome,
      'Biết mình cần sửa gì qua feedback sau từng phiên luyện.'.tr,
      'Có đề xuất bước tiếp theo rõ ràng sau mỗi phiên luyện.'.tr,
    ];
  }

  final String goal = (plan.learningGoal ?? '').toUpperCase();
  final String level = plan.level;
  final String focus = _labelForFocus(plan.focusSkill).toLowerCase();

  switch (goal) {
    case 'WORK':
      return <String>[
        'Trả lời các tình huống công việc ngắn ở level $level rõ ràng hơn.'.tr,
        'Dùng cấu trúc câu và từ vựng phù hợp hơn khi nói với đối tác AI.'.tr,
        'Biết mình cần sửa gì qua feedback sau từng phiên luyện.'.tr,
      ];
    case 'TRAVEL':
      return <String>[
        'Xử lý các tình huống du lịch cơ bản như check-in, hỏi đường, gọi món.'
            .tr,
        'Giải thích nhu cầu đơn giản bằng câu nói tự nhiên và dễ hiểu hơn.'.tr,
        'Duy trì hội thoại ngắn với trọng tâm $focus ở level $level.'.tr,
      ];
    case 'DAILY':
      return <String>[
        'Nói chuyện đời sống hằng ngày tự nhiên hơn trong các scene ngắn.'.tr,
        'Tập phản xạ trả lời theo ngữ cảnh thay vì chỉ dịch từng câu.'.tr,
        'Xây thói quen luyện đều ${plan.weeklyTarget} buổi mỗi tuần.'.tr,
      ];
    default:
      return <String>[
        'Hoàn thành các scene cốt lõi phù hợp trình độ $level.'.tr,
        'Cải thiện $focus bằng feedback theo transcript thật.'.tr,
        'Có đề xuất bước tiếp theo rõ ràng sau mỗi phiên luyện.'.tr,
      ];
  }
}
