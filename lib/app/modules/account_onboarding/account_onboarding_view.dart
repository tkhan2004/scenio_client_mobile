import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../core/constants/app_colors.dart';
import '../../core/constants/app_dimensions.dart';
import '../../core/constants/app_strings.dart';
import '../../core/constants/app_text_styles.dart';
import '../auth/widgets/auth_primary_button.dart';
import 'account_onboarding_viewmodel.dart';

class AccountOnboardingView extends GetView<AccountOnboardingViewModel> {
  const AccountOnboardingView({super.key});

  List<_ChoiceOption> get _goalOptions => <_ChoiceOption>[
    _ChoiceOption(
      label: AppStrings.accountOnboardingGoalWork,
      caption: AppStrings.accountOnboardingGoalWorkCaption,
      value: 'WORK',
    ),
    _ChoiceOption(
      label: AppStrings.accountOnboardingGoalTravel,
      caption: AppStrings.accountOnboardingGoalTravelCaption,
      value: 'TRAVEL',
    ),
    _ChoiceOption(
      label: AppStrings.accountOnboardingGoalDaily,
      caption: AppStrings.accountOnboardingGoalDailyCaption,
      value: 'DAILY',
    ),
    _ChoiceOption(
      label: AppStrings.accountOnboardingGoalMixed,
      caption: AppStrings.accountOnboardingGoalMixedCaption,
      value: 'ALL',
    ),
  ];

  List<_ChoiceOption> get _levelOptions => <_ChoiceOption>[
    _ChoiceOption(
      label: AppStrings.accountOnboardingLevelA1,
      caption: AppStrings.accountOnboardingLevelA1Caption,
      value: 'A1',
    ),
    _ChoiceOption(
      label: AppStrings.accountOnboardingLevelA2,
      caption: AppStrings.accountOnboardingLevelA2Caption,
      value: 'A2',
    ),
    _ChoiceOption(
      label: AppStrings.accountOnboardingLevelB1,
      caption: AppStrings.accountOnboardingLevelB1Caption,
      value: 'B1',
    ),
    _ChoiceOption(
      label: AppStrings.accountOnboardingLevelB2,
      caption: AppStrings.accountOnboardingLevelB2Caption,
      value: 'B2',
    ),
  ];

  List<_ChoiceOption> get _frequencyOptions => <_ChoiceOption>[
    _ChoiceOption(
      label: AppStrings.accountOnboardingFrequencyLight,
      caption: AppStrings.accountOnboardingFrequencyLightCaption,
      value: 'LIGHT',
    ),
    _ChoiceOption(
      label: AppStrings.accountOnboardingFrequencyRegular,
      caption: AppStrings.accountOnboardingFrequencyRegularCaption,
      value: 'REGULAR',
    ),
    _ChoiceOption(
      label: AppStrings.accountOnboardingFrequencyIntensive,
      caption: AppStrings.accountOnboardingFrequencyIntensiveCaption,
      value: 'INTENSIVE',
    ),
  ];

  List<_ChoiceOption> get _focusOptions => <_ChoiceOption>[
    _ChoiceOption(
      label: AppStrings.accountOnboardingFocusVocabulary,
      caption: AppStrings.accountOnboardingFocusVocabularyCaption,
      value: 'VOCABULARY',
    ),
    _ChoiceOption(
      label: AppStrings.accountOnboardingFocusGrammar,
      caption: AppStrings.accountOnboardingFocusGrammarCaption,
      value: 'GRAMMAR',
    ),
    _ChoiceOption(
      label: AppStrings.accountOnboardingFocusNaturalness,
      caption: AppStrings.accountOnboardingFocusNaturalnessCaption,
      value: 'NATURALNESS',
    ),
    _ChoiceOption(
      label: AppStrings.accountOnboardingFocusConfidence,
      caption: AppStrings.accountOnboardingFocusConfidenceCaption,
      value: 'CONFIDENCE',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final double bottomSafeInset = MediaQuery.paddingOf(context).bottom;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        bottom: false,
        child: Column(
          children: <Widget>[
            Expanded(
              child: Obx(
                () => SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  padding: const EdgeInsets.fromLTRB(
                    AppDimensions.xxl,
                    AppDimensions.xl,
                    AppDimensions.xxl,
                    AppDimensions.xl,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      const _SetupHero(),
                      const SizedBox(height: AppDimensions.lg),
                      _StepProgress(
                        label: controller.progressLabel,
                        progress:
                            (controller.currentStep.value + 1) /
                            controller.totalSteps,
                      ),
                      const SizedBox(height: AppDimensions.xl),
                      AnimatedSwitcher(
                        duration: const Duration(milliseconds: 220),
                        child: _currentStepSection(),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            ClipRRect(
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(AppDimensions.radiusXl),
              ),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 18, sigmaY: 18),
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.78),
                    border: Border(
                      top: BorderSide(
                        color: Colors.white.withValues(alpha: 0.92),
                        width: 0.8,
                      ),
                    ),
                  ),
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(
                      AppDimensions.xxl,
                      AppDimensions.md,
                      AppDimensions.xxl,
                      bottomSafeInset + AppDimensions.xl,
                    ),
                    child: Obx(
                      () => Row(
                        children: <Widget>[
                          if (!controller.isFirstStep) ...<Widget>[
                            SizedBox(
                              width: 104,
                              child: OutlinedButton(
                                onPressed: controller.isSubmitting.value
                                    ? null
                                    : controller.previousStep,
                                child: Text('Back'.tr),
                              ),
                            ),
                            const SizedBox(width: AppDimensions.md),
                          ],
                          Expanded(
                            child: AuthPrimaryButton(
                              label: controller.primaryButtonLabel,
                              onPressed: controller.isSubmitting.value
                                  ? null
                                  : controller.handlePrimaryAction,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _currentStepSection() {
    switch (controller.currentStep.value) {
      case 0:
        return _ChoiceSection(
          key: const ValueKey<String>('goals'),
          icon: Icons.flag_rounded,
          title: AppStrings.accountOnboardingGoalTitle,
          subtitle:
              '${AppStrings.accountOnboardingGoalSubtitle} ${'You can choose more than one.'.tr}',
          selectedValues: controller.selectedLearningGoals.toList(),
          errorText: controller.learningGoalError.value,
          options: _goalOptions,
          onSelected: controller.selectLearningGoal,
          multiSelect: true,
        );
      case 1:
        return _ChoiceSection(
          key: const ValueKey<String>('level'),
          icon: Icons.school_rounded,
          title: AppStrings.accountOnboardingLevelTitle,
          subtitle: AppStrings.accountOnboardingLevelSubtitle,
          selectedValues: <String>[controller.selectedLevel.value],
          errorText: controller.levelError.value,
          options: _levelOptions,
          onSelected: controller.selectLevel,
        );
      case 2:
        return _ChoiceSection(
          key: const ValueKey<String>('frequency'),
          icon: Icons.calendar_month_rounded,
          title: AppStrings.accountOnboardingFrequencyTitle,
          subtitle: AppStrings.accountOnboardingFrequencySubtitle,
          selectedValues: <String>[controller.selectedStudyFrequency.value],
          errorText: controller.studyFrequencyError.value,
          options: _frequencyOptions,
          onSelected: controller.selectStudyFrequency,
        );
      case 3:
        return _ChoiceSection(
          key: const ValueKey<String>('focus'),
          icon: Icons.auto_awesome_rounded,
          title: AppStrings.accountOnboardingFocusTitle,
          subtitle:
              '${AppStrings.accountOnboardingFocusSubtitle} ${'Pick every blocker that feels true.'.tr}',
          selectedValues: controller.selectedSelfAssessments.toList(),
          errorText: controller.selfAssessmentError.value,
          options: _focusOptions,
          onSelected: controller.selectSelfAssessment,
          multiSelect: true,
        );
      case 4:
      default:
        return _SummarySection(
          key: const ValueKey<String>('summary'),
          goals: controller.selectedLearningGoals.toList(),
          level: controller.selectedLevel.value,
          frequency: controller.selectedStudyFrequency.value,
          focuses: controller.selectedSelfAssessments.toList(),
        );
    }
  }
}

class _SetupHero extends StatelessWidget {
  const _SetupHero();

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
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
            color: AppColors.primary700.withValues(alpha: 0.24),
            blurRadius: 28,
            offset: const Offset(0, 14),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppDimensions.xxl),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              width: 46,
              height: 46,
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.16),
                borderRadius: BorderRadius.circular(AppDimensions.radiusLg),
                border: Border.all(
                  color: Colors.white.withValues(alpha: 0.28),
                  width: 0.8,
                ),
              ),
              child: const Icon(
                Icons.route_rounded,
                color: Colors.white,
                size: AppDimensions.iconLg,
              ),
            ),
            const SizedBox(height: AppDimensions.xl),
            Text(
              AppStrings.accountOnboardingEyebrow,
              style: AppTextStyles.labelLarge.copyWith(
                color: Colors.white.withValues(alpha: 0.76),
              ),
            ),
            const SizedBox(height: AppDimensions.sm),
            Text(
              AppStrings.accountOnboardingTitle,
              style: AppTextStyles.displayLarge.copyWith(
                color: Colors.white,
                height: 1.16,
              ),
            ),
            const SizedBox(height: AppDimensions.md),
            Text(
              AppStrings.accountOnboardingSubtitle,
              style: AppTextStyles.bodyMedium.copyWith(
                color: Colors.white.withValues(alpha: 0.82),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _StepProgress extends StatelessWidget {
  const _StepProgress({required this.label, required this.progress});

  final String label;
  final double progress;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          label,
          style: AppTextStyles.labelMedium.copyWith(
            color: AppColors.textSecondary,
          ),
        ),
        const SizedBox(height: AppDimensions.sm),
        ClipRRect(
          borderRadius: BorderRadius.circular(AppDimensions.radiusFull),
          child: LinearProgressIndicator(
            value: progress.clamp(0, 1),
            minHeight: 8,
            backgroundColor: AppColors.primary200,
            valueColor: const AlwaysStoppedAnimation<Color>(
              AppColors.primary800,
            ),
          ),
        ),
      ],
    );
  }
}

class _ChoiceSection extends StatelessWidget {
  const _ChoiceSection({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.selectedValues,
    required this.errorText,
    required this.options,
    required this.onSelected,
    this.multiSelect = false,
    super.key,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final List<String> selectedValues;
  final String errorText;
  final List<_ChoiceOption> options;
  final ValueChanged<String> onSelected;
  final bool multiSelect;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.82),
        borderRadius: BorderRadius.circular(AppDimensions.radiusXl),
        border: Border.all(
          color: AppColors.primary200.withValues(alpha: 0.86),
          width: 0.8,
        ),
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: AppColors.primary200.withValues(alpha: 0.14),
            blurRadius: 18,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppDimensions.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: AppColors.primary50,
                    borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
                  ),
                  child: Icon(
                    icon,
                    color: AppColors.primary800,
                    size: AppDimensions.iconMd,
                  ),
                ),
                const SizedBox(width: AppDimensions.md),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(title, style: AppTextStyles.h3),
                      const SizedBox(height: 2),
                      Text(subtitle, style: AppTextStyles.bodySmall),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppDimensions.lg),
            ...options.map(
              (_ChoiceOption option) => Padding(
                padding: const EdgeInsets.only(bottom: AppDimensions.sm),
                child: _ChoiceTile(
                  option: option,
                  isSelected: selectedValues.contains(option.value),
                  multiSelect: multiSelect,
                  onTap: () => onSelected(option.value),
                ),
              ),
            ),
            SizedBox(
              height: 16,
              child: errorText.isEmpty
                  ? const SizedBox.shrink()
                  : Text(
                      errorText,
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.error,
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ChoiceTile extends StatelessWidget {
  const _ChoiceTile({
    required this.option,
    required this.isSelected,
    required this.multiSelect,
    required this.onTap,
  });

  final _ChoiceOption option;
  final bool isSelected;
  final bool multiSelect;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppDimensions.radiusLg),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          curve: Curves.easeOutCubic,
          padding: const EdgeInsets.all(AppDimensions.md),
          decoration: BoxDecoration(
            color: isSelected
                ? AppColors.primary700.withValues(alpha: 0.12)
                : AppColors.primary50.withValues(alpha: 0.54),
            borderRadius: BorderRadius.circular(AppDimensions.radiusLg),
            border: Border.all(
              color: isSelected
                  ? AppColors.primary700
                  : AppColors.primary200.withValues(alpha: 0.78),
              width: isSelected ? 1.2 : 0.8,
            ),
          ),
          child: Row(
            children: <Widget>[
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(option.label, style: AppTextStyles.labelLarge),
                    const SizedBox(height: 2),
                    Text(option.caption, style: AppTextStyles.caption),
                  ],
                ),
              ),
              const SizedBox(width: AppDimensions.md),
              AnimatedContainer(
                duration: const Duration(milliseconds: 180),
                width: 24,
                height: 24,
                decoration: BoxDecoration(
                  color: isSelected ? AppColors.primary700 : Colors.white,
                  shape: multiSelect ? BoxShape.rectangle : BoxShape.circle,
                  borderRadius: multiSelect
                      ? BorderRadius.circular(AppDimensions.radiusSm)
                      : null,
                  border: Border.all(
                    color: isSelected
                        ? AppColors.primary700
                        : AppColors.primary200,
                    width: 1,
                  ),
                ),
                child: isSelected
                    ? const Icon(
                        Icons.check_rounded,
                        color: Colors.white,
                        size: 16,
                      )
                    : null,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SummarySection extends StatelessWidget {
  const _SummarySection({
    required this.goals,
    required this.level,
    required this.frequency,
    required this.focuses,
    super.key,
  });

  final List<String> goals;
  final String level;
  final String frequency;
  final List<String> focuses;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.82),
        borderRadius: BorderRadius.circular(AppDimensions.radiusXl),
        border: Border.all(
          color: AppColors.primary200.withValues(alpha: 0.86),
          width: 0.8,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppDimensions.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text('Review your setup'.tr, style: AppTextStyles.h2),
            const SizedBox(height: AppDimensions.sm),
            Text(
              'Scenio will use this to create your first roadmap.'.tr,
              style: AppTextStyles.bodySmall.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: AppDimensions.lg),
            _SummaryRow(label: 'Goals'.tr, values: goals),
            _SummaryRow(label: 'Level'.tr, values: <String>[level]),
            _SummaryRow(
              label: 'Practice rhythm'.tr,
              values: <String>[frequency],
            ),
            _SummaryRow(label: 'Focus'.tr, values: focuses),
            const SizedBox(height: AppDimensions.md),
            Text(
              'XP will track effort and rewards. Level should increase only after enough completed sessions, strong recent scores, or a level test.'
                  .tr,
              style: AppTextStyles.caption.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SummaryRow extends StatelessWidget {
  const _SummaryRow({required this.label, required this.values});

  final String label;
  final List<String> values;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppDimensions.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(label, style: AppTextStyles.labelLarge),
          const SizedBox(height: AppDimensions.sm),
          Wrap(
            spacing: AppDimensions.sm,
            runSpacing: AppDimensions.sm,
            children: values
                .where((String value) => value.trim().isNotEmpty)
                .map(
                  (String value) => Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppDimensions.md,
                      vertical: AppDimensions.sm,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.primary50,
                      borderRadius: BorderRadius.circular(
                        AppDimensions.radiusFull,
                      ),
                      border: Border.all(color: AppColors.primary200),
                    ),
                    child: Text(value, style: AppTextStyles.labelMedium),
                  ),
                )
                .toList(growable: false),
          ),
        ],
      ),
    );
  }
}

class _ChoiceOption {
  const _ChoiceOption({
    required this.label,
    required this.caption,
    required this.value,
  });

  final String label;
  final String caption;
  final String value;
}
