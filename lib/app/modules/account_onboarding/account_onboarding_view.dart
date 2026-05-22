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
              child: SingleChildScrollView(
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
                    const SizedBox(height: AppDimensions.xxl),
                    Obx(
                      () => _ChoiceSection(
                        icon: Icons.flag_rounded,
                        title: AppStrings.accountOnboardingGoalTitle,
                        subtitle: AppStrings.accountOnboardingGoalSubtitle,
                        selectedValue: controller.selectedLearningGoal.value,
                        errorText: controller.learningGoalError.value,
                        options: <_ChoiceOption>[
                          _ChoiceOption(
                            label: AppStrings.accountOnboardingGoalWork,
                            caption:
                                AppStrings.accountOnboardingGoalWorkCaption,
                            value: 'WORK',
                          ),
                          _ChoiceOption(
                            label: AppStrings.accountOnboardingGoalTravel,
                            caption:
                                AppStrings.accountOnboardingGoalTravelCaption,
                            value: 'TRAVEL',
                          ),
                          _ChoiceOption(
                            label: AppStrings.accountOnboardingGoalDaily,
                            caption:
                                AppStrings.accountOnboardingGoalDailyCaption,
                            value: 'DAILY',
                          ),
                          _ChoiceOption(
                            label: AppStrings.accountOnboardingGoalMixed,
                            caption:
                                AppStrings.accountOnboardingGoalMixedCaption,
                            value: 'ALL',
                          ),
                        ],
                        onSelected: controller.selectLearningGoal,
                      ),
                    ),
                    const SizedBox(height: AppDimensions.lg),
                    Obx(
                      () => _ChoiceSection(
                        icon: Icons.school_rounded,
                        title: AppStrings.accountOnboardingLevelTitle,
                        subtitle: AppStrings.accountOnboardingLevelSubtitle,
                        selectedValue: controller.selectedLevel.value,
                        errorText: controller.levelError.value,
                        options: <_ChoiceOption>[
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
                        ],
                        onSelected: controller.selectLevel,
                      ),
                    ),
                    const SizedBox(height: AppDimensions.lg),
                    Obx(
                      () => _ChoiceSection(
                        icon: Icons.calendar_month_rounded,
                        title: AppStrings.accountOnboardingFrequencyTitle,
                        subtitle: AppStrings.accountOnboardingFrequencySubtitle,
                        selectedValue: controller.selectedStudyFrequency.value,
                        errorText: controller.studyFrequencyError.value,
                        options: <_ChoiceOption>[
                          _ChoiceOption(
                            label: AppStrings.accountOnboardingFrequencyLight,
                            caption: AppStrings
                                .accountOnboardingFrequencyLightCaption,
                            value: 'LIGHT',
                          ),
                          _ChoiceOption(
                            label: AppStrings.accountOnboardingFrequencyRegular,
                            caption: AppStrings
                                .accountOnboardingFrequencyRegularCaption,
                            value: 'REGULAR',
                          ),
                          _ChoiceOption(
                            label:
                                AppStrings.accountOnboardingFrequencyIntensive,
                            caption: AppStrings
                                .accountOnboardingFrequencyIntensiveCaption,
                            value: 'INTENSIVE',
                          ),
                        ],
                        onSelected: controller.selectStudyFrequency,
                      ),
                    ),
                    const SizedBox(height: AppDimensions.lg),
                    Obx(
                      () => _ChoiceSection(
                        icon: Icons.auto_awesome_rounded,
                        title: AppStrings.accountOnboardingFocusTitle,
                        subtitle: AppStrings.accountOnboardingFocusSubtitle,
                        selectedValue: controller.selectedSelfAssessment.value,
                        errorText: controller.selfAssessmentError.value,
                        options: <_ChoiceOption>[
                          _ChoiceOption(
                            label: AppStrings.accountOnboardingFocusVocabulary,
                            caption: AppStrings
                                .accountOnboardingFocusVocabularyCaption,
                            value: 'VOCABULARY',
                          ),
                          _ChoiceOption(
                            label: AppStrings.accountOnboardingFocusGrammar,
                            caption:
                                AppStrings.accountOnboardingFocusGrammarCaption,
                            value: 'GRAMMAR',
                          ),
                          _ChoiceOption(
                            label: AppStrings.accountOnboardingFocusNaturalness,
                            caption: AppStrings
                                .accountOnboardingFocusNaturalnessCaption,
                            value: 'NATURALNESS',
                          ),
                          _ChoiceOption(
                            label: AppStrings.accountOnboardingFocusConfidence,
                            caption: AppStrings
                                .accountOnboardingFocusConfidenceCaption,
                            value: 'CONFIDENCE',
                          ),
                        ],
                        onSelected: controller.selectSelfAssessment,
                      ),
                    ),
                  ],
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
                      () => AuthPrimaryButton(
                        label: controller.isSubmitting.value
                            ? AppStrings.accountOnboardingSavingButton
                            : AppStrings.accountOnboardingSubmitButton,
                        onPressed: controller.isSubmitting.value
                            ? null
                            : controller.submit,
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

class _ChoiceSection extends StatelessWidget {
  const _ChoiceSection({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.selectedValue,
    required this.errorText,
    required this.options,
    required this.onSelected,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final String selectedValue;
  final String errorText;
  final List<_ChoiceOption> options;
  final ValueChanged<String> onSelected;

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
                  isSelected: selectedValue == option.value,
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
    required this.onTap,
  });

  final _ChoiceOption option;
  final bool isSelected;
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
                  shape: BoxShape.circle,
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
