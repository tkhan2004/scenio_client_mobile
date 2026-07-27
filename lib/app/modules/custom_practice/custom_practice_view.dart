import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../core/constants/app_colors.dart';
import '../../core/constants/app_dimensions.dart';
import '../../core/constants/app_text_styles.dart';
import '../auth/widgets/auth_text_field.dart';
import 'custom_practice_viewmodel.dart';

class CustomPracticeView extends GetView<CustomPracticeViewModel> {
  const CustomPracticeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
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
            () => Row(
              children: <Widget>[
                if (!controller.isFirstStep) ...<Widget>[
                  Expanded(
                    child: OutlinedButton(
                      onPressed: controller.previousStep,
                      style: OutlinedButton.styleFrom(
                        minimumSize: const Size.fromHeight(
                          AppDimensions.buttonHeight,
                        ),
                        side: const BorderSide(color: AppColors.primary200),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(
                            AppDimensions.radiusFull,
                          ),
                        ),
                      ),
                      child: Text('Back'.tr),
                    ),
                  ),
                  const SizedBox(width: AppDimensions.md),
                ],
                Expanded(
                  flex: controller.isFirstStep ? 1 : 2,
                  child: ElevatedButton(
                    onPressed: controller.isSubmitting.value
                        ? null
                        : controller.handlePrimaryAction,
                    child: Text(
                      controller.isSubmitting.value
                          ? 'Starting session...'.tr
                          : controller.primaryActionLabel,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      body: Stack(
        children: <Widget>[
          SafeArea(
            bottom: false,
            child: Form(
              key: controller.formKey,
              child: Obx(
                () => ListView(
                  physics: const ClampingScrollPhysics(),
                  padding: const EdgeInsets.fromLTRB(
                    AppDimensions.xxl,
                    AppDimensions.xxl,
                    AppDimensions.xxl,
                    AppDimensions.xxxl * 2,
                  ),
                  children: <Widget>[
                    _AnimatedReveal(
                      visible: controller.revealedStage.value >= 1,
                      child: Row(
                        children: <Widget>[
                          _TopBackButton(onTap: Get.back),
                          const SizedBox(width: AppDimensions.md),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text(
                                  'Custom'.tr,
                                  style: AppTextStyles.displayLarge.copyWith(
                                    fontSize: 28,
                                    color: AppColors.primary900,
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  'Custom practice builder'.tr,
                                  style: AppTextStyles.bodySmall.copyWith(
                                    color: AppColors.textSecondary,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          _PracticeStatusChip(
                            label: controller.progressLabel,
                            icon: Icons.auto_awesome_rounded,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: AppDimensions.lg),
                    _AnimatedReveal(
                      visible: controller.revealedStage.value >= 1,
                      offsetY: 18,
                      child: _PracticeIntroCard(
                        title: 'Create your own practice'.tr,
                        subtitle:
                            'We will guide you one decision at a time so the scene feels clear, focused, and easy to start.'
                                .tr,
                        eyebrow: controller.stepTitle(
                          controller.currentStep.value,
                        ),
                        status: controller.stepSubtitle(
                          controller.currentStep.value,
                        ),
                      ),
                    ),
                    const SizedBox(height: AppDimensions.lg),
                    _AnimatedReveal(
                      visible: controller.revealedStage.value >= 2,
                      offsetY: 20,
                      child: _SectionCard(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            _ProgressHeader(
                              label: controller.progressLabel,
                              title: controller.stepTitle(
                                controller.currentStep.value,
                              ),
                              subtitle: controller.stepSubtitle(
                                controller.currentStep.value,
                              ),
                              currentStep: controller.currentStep.value,
                              totalSteps: controller.totalSteps,
                            ),
                            const SizedBox(height: AppDimensions.lg),
                            AnimatedSwitcher(
                              duration: const Duration(milliseconds: 360),
                              switchInCurve: Curves.easeOutCubic,
                              switchOutCurve: Curves.easeInCubic,
                              transitionBuilder:
                                  (Widget child, Animation<double> animation) {
                                    final Animation<Offset> offsetAnimation =
                                        Tween<Offset>(
                                          begin: const Offset(0.06, 0),
                                          end: Offset.zero,
                                        ).animate(animation);
                                    return FadeTransition(
                                      opacity: animation,
                                      child: SlideTransition(
                                        position: offsetAnimation,
                                        child: child,
                                      ),
                                    );
                                  },
                              child: _StepContent(
                                key: ValueKey<int>(
                                  controller.currentStep.value,
                                ),
                                step: controller.currentStep.value,
                                controller: controller,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    if (controller.currentStep.value == 0) ...<Widget>[
                      const SizedBox(height: AppDimensions.lg),
                      _AnimatedReveal(
                        visible: controller.revealedStage.value >= 3,
                        offsetY: 18,
                        child: _StepSupportCard(
                          title: 'Quick presets'.tr,
                          subtitle:
                              'Choose a realistic seed first, then fine-tune it as you move through the steps.'
                                  .tr,
                          child: SizedBox(
                            height: 128,
                            child: ListView.separated(
                              scrollDirection: Axis.horizontal,
                              itemCount: controller.presets.length,
                              separatorBuilder: (_, int index) =>
                                  const SizedBox(width: AppDimensions.md),
                              itemBuilder: (BuildContext context, int index) {
                                final CustomPracticePreset preset =
                                    controller.presets[index];
                                return _PresetCard(
                                  preset: preset,
                                  onTap: () => controller.applyPreset(preset),
                                );
                              },
                            ),
                          ),
                        ),
                      ),

                    ],
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _AnimatedReveal extends StatelessWidget {
  const _AnimatedReveal({
    required this.visible,
    required this.child,
    this.offsetY = 12,
  });

  final bool visible;
  final Widget child;
  final double offsetY;

  @override
  Widget build(BuildContext context) {
    return AnimatedOpacity(
      duration: const Duration(milliseconds: 420),
      curve: Curves.easeOutCubic,
      opacity: visible ? 1 : 0,
      child: AnimatedSlide(
        duration: const Duration(milliseconds: 420),
        curve: Curves.easeOutCubic,
        offset: visible ? Offset.zero : Offset(0, offsetY / 100),
        child: child,
      ),
    );
  }
}

class _ProgressHeader extends StatelessWidget {
  const _ProgressHeader({
    required this.label,
    required this.title,
    required this.subtitle,
    required this.currentStep,
    required this.totalSteps,
  });

  final String label;
  final String title;
  final String subtitle;
  final int currentStep;
  final int totalSteps;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          label,
          style: AppTextStyles.labelSmall.copyWith(
            color: AppColors.textSecondary,
          ),
        ),
        const SizedBox(height: AppDimensions.xs),
        Text(title, style: AppTextStyles.h1),
        const SizedBox(height: AppDimensions.xs),
        Text(
          subtitle,
          style: AppTextStyles.bodySmall.copyWith(
            color: AppColors.textSecondary,
          ),
        ),
        const SizedBox(height: AppDimensions.lg),
        Row(
          children: List<Widget>.generate(totalSteps, (int index) {
            final bool isActive = index == currentStep;
            final bool isDone = index < currentStep;
            return Expanded(
              child: Container(
                margin: EdgeInsets.only(
                  right: index == totalSteps - 1 ? 0 : AppDimensions.sm,
                ),
                height: 10,
                decoration: BoxDecoration(
                  color: isDone || isActive
                      ? AppColors.textPrimary
                      : AppColors.primary200,
                  borderRadius: BorderRadius.circular(AppDimensions.radiusFull),
                ),
              ),
            );
          }),
        ),
      ],
    );
  }
}

class _StepContent extends StatelessWidget {
  const _StepContent({
    required super.key,
    required this.step,
    required this.controller,
  });

  final int step;
  final CustomPracticeViewModel controller;

  @override
  Widget build(BuildContext context) {
    switch (step) {
      case 0:
        return _StepSectionCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              _FieldLabel(label: 'Practice goal'.tr),
              _LongTextField(
                controller: controller.practiceGoalController,
                hintText:
                    'Summarize the real situation you want to practice'.tr,
                validator: controller.validateRequired,
                minLines: 3,
                maxLines: 4,
              ),
              const SizedBox(height: AppDimensions.sm),
              _SuggestionWrap(
                suggestions: const <String>[
                  'Practice a job interview',
                  'Handle a customer complaint politely',
                  'Make an English phone call',
                ],
                onSelected: (String value) {
                  controller.practiceGoalController.text = value.tr;
                },
              ),
              const SizedBox(height: AppDimensions.lg),
              _FieldLabel(label: 'Topic summary'.tr),
              _LongTextField(
                controller: controller.topicSummaryController,
                hintText:
                    'For example: a short HR interview for a frontend intern role'
                        .tr,
                validator: controller.validateRequired,
                minLines: 3,
                maxLines: 4,
              ),
              const SizedBox(height: AppDimensions.sm),
              _SuggestionWrap(
                suggestions: const <String>[
                  'A short HR interview for a frontend intern role',
                  'A phone call to reschedule a clinic appointment',
                  'A conversation with airline staff about a delayed bag',
                ],
                onSelected: (String value) {
                  controller.topicSummaryController.text = value.tr;
                },
              ),
              const SizedBox(height: AppDimensions.lg),
              _FieldLabel(label: 'Success outcome'.tr),
              _LongTextField(
                controller: controller.successOutcomeController,
                hintText: 'What would make this session feel successful?'.tr,
                validator: controller.validateOptionalLonger,
                minLines: 2,
                maxLines: 3,
              ),
            ],
          ),
        );
      case 1:
        return Obx(
          () => _StepSectionCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                _FieldLabel(label: 'Context type'.tr),
                _ChipWrap(
                  values: const <String>[
                    'INTERVIEW',
                    'WORK',
                    'TRAVEL',
                    'PHONE_CALL',
                    'CUSTOMER_SERVICE',
                    'SOCIAL',
                    'MEDICAL',
                    'OTHER',
                  ],
                  selectedValue: controller.contextType.value,
                  labelBuilder: _contextTypeLabel,
                  onSelected: controller.selectContextType,
                ),
                const SizedBox(height: AppDimensions.md),
                _FieldLabel(label: 'Conversation channel'.tr),
                _ChipWrap(
                  values: const <String>[
                    'IN_PERSON',
                    'PHONE_CALL',
                    'VIDEO_CALL',
                  ],
                  selectedValue: controller.conversationChannel.value,
                  labelBuilder: _channelLabel,
                  onSelected: controller.selectConversationChannel,
                ),
                const SizedBox(height: AppDimensions.md),
                _FieldLabel(label: 'Location'.tr),
                AuthTextField(
                  controller: controller.locationController,
                  hintText: 'Online meeting, office, airport, clinic...'.tr,
                  validator: controller.validateOptionalLonger,
                  textInputAction: TextInputAction.next,
                ),
                const SizedBox(height: AppDimensions.sm),
                _SuggestionWrap(
                  suggestions: const <String>[
                    'Online meeting',
                    'Office lobby',
                    'Airport service desk',
                    'On the phone',
                  ],
                  onSelected: (String value) {
                    controller.locationController.text = value.tr;
                  },
                ),
                const SizedBox(height: AppDimensions.lg),
                _FieldLabel(label: 'Your role'.tr),
                AuthTextField(
                  controller: controller.userRoleController,
                  hintText: 'For example: frontend intern candidate'.tr,
                  validator: controller.validateRequired,
                  textInputAction: TextInputAction.next,
                ),
                const SizedBox(height: AppDimensions.sm),
                _SuggestionWrap(
                  suggestions: const <String>[
                    'Frontend intern candidate',
                    'Customer',
                    'Passenger',
                    'Student',
                  ],
                  onSelected: (String value) {
                    controller.userRoleController.text = value.tr;
                  },
                ),
                const SizedBox(height: AppDimensions.lg),
                _FieldLabel(label: 'Your intent'.tr),
                _LongTextField(
                  controller: controller.userIntentController,
                  hintText:
                      'What are you trying to achieve in this conversation?'.tr,
                  validator: controller.validateOptionalLonger,
                  minLines: 2,
                  maxLines: 3,
                ),
                const SizedBox(height: AppDimensions.sm),
                _SuggestionWrap(
                  suggestions: const <String>[
                    'Explain my situation clearly',
                    'Ask for help politely',
                    'Make a good impression',
                    'Solve the problem quickly',
                  ],
                  onSelected: (String value) {
                    controller.userIntentController.text = value.tr;
                  },
                ),
              ],
            ),
          ),
        );
      case 2:
        return Obx(
          () => _StepSectionCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                _FieldLabel(label: 'AI role'.tr),
                AuthTextField(
                  controller: controller.aiRoleController,
                  hintText: 'For example: HR recruiter'.tr,
                  validator: controller.validateRequired,
                  textInputAction: TextInputAction.next,
                ),
                const SizedBox(height: AppDimensions.sm),
                _SuggestionWrap(
                  suggestions: const <String>[
                    'HR recruiter',
                    'Receptionist',
                    'Airline service agent',
                    'Customer support agent',
                  ],
                  onSelected: (String value) {
                    controller.aiRoleController.text = value.tr;
                  },
                ),
                const SizedBox(height: AppDimensions.lg),
                _FieldLabel(label: 'AI display name'.tr),
                AuthTextField(
                  controller: controller.aiDisplayNameController,
                  hintText: 'Choose a friendly name for the AI partner'.tr,
                  validator: controller.validateRequired,
                  textInputAction: TextInputAction.next,
                ),
                const SizedBox(height: AppDimensions.sm),
                _FieldLabel(label: 'AI primary goal'.tr),
                _LongTextField(
                  controller: controller.aiPrimaryGoalController,
                  hintText: 'What should the AI try to achieve in role?'.tr,
                  validator: controller.validateOptionalLonger,
                  minLines: 2,
                  maxLines: 3,
                ),
                const SizedBox(height: AppDimensions.sm),
                _FieldLabel(label: 'AI behavior style'.tr),
                _LongTextField(
                  controller: controller.aiBehaviorStyleController,
                  hintText:
                      'For example: calm, professional, a bit challenging'.tr,
                  validator: controller.validateOptionalLonger,
                  minLines: 2,
                  maxLines: 3,
                ),
                const SizedBox(height: AppDimensions.sm),
                _SuggestionWrap(
                  suggestions: const <String>[
                    'Warm and patient',
                    'Professional and direct',
                    'Busy but helpful',
                    'Challenging but fair',
                  ],
                  onSelected: (String value) {
                    controller.aiBehaviorStyleController.text = value.tr;
                  },
                ),
                const SizedBox(height: AppDimensions.lg),
                _FieldLabel(label: 'Gender presentation'.tr),
                _ChipWrap(
                  values: const <String>['NEUTRAL', 'FEMALE', 'MALE'],
                  selectedValue: controller.aiGenderPresentation.value,
                  labelBuilder: _genderLabel,
                  onSelected: controller.selectGender,
                ),
                const SizedBox(height: AppDimensions.md),
                _FieldLabel(label: 'Voice tone'.tr),
                _ChipWrap(
                  values: const <String>[
                    'FRIENDLY',
                    'WARM',
                    'CALM',
                    'CONFIDENT',
                    'FORMAL',
                  ],
                  selectedValue: controller.aiVoiceTone.value,
                  labelBuilder: _toneLabel,
                  onSelected: controller.selectTone,
                ),
                const SizedBox(height: AppDimensions.md),
                _FieldLabel(label: 'Accent preference'.tr),
                AuthTextField(
                  controller: controller.aiAccentController,
                  hintText: 'British, American, neutral...'.tr,
                  validator: controller.validateOptionalLonger,
                  textInputAction: TextInputAction.done,
                ),
              ],
            ),
          ),
        );
      case 3:
      default:
        return Obx(
          () => _StepSectionCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                _FieldLabel(label: 'Difficulty'.tr),
                _ChipWrap(
                  values: const <String>['A1', 'A2', 'B1', 'B2'],
                  selectedValue: controller.difficulty.value,
                  labelBuilder: (String value) => value,
                  onSelected: controller.selectDifficulty,
                ),
                const SizedBox(height: AppDimensions.md),
                _FieldLabel(label: 'Conversation length'.tr),
                Text(
                  'Choose how much room you want for the dialogue.'.tr,
                  style: AppTextStyles.bodySmall.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
                const SizedBox(height: AppDimensions.sm),
                _ChipWrap(
                  values: const <String>['SHORT', 'MEDIUM', 'LONG'],
                  selectedValue: controller.conversationLength.value,
                  labelBuilder: _conversationLengthLabel,
                  onSelected: controller.selectConversationLength,
                ),
                const SizedBox(height: AppDimensions.sm),
                _DurationSlider(
                  minutes: controller.targetMinutes.value,
                  onChanged: controller.selectTargetMinutes,
                ),
                const SizedBox(height: AppDimensions.md),
                _FieldLabel(label: 'Custom instructions'.tr),
                _LongTextField(
                  controller: controller.customInstructionsController,
                  hintText: 'Any special coaching rule or situation detail'.tr,
                  validator: controller.validateOptionalLonger,
                  minLines: 4,
                  maxLines: 5,
                ),
                const SizedBox(height: AppDimensions.sm),
                _SuggestionWrap(
                  suggestions: const <String>[
                    'Keep feedback gentle and brief',
                    'Ask short follow-up questions',
                    'Use simple English first',
                  ],
                  onSelected: (String value) {
                    controller.customInstructionsController.text = value.tr;
                  },
                ),
                const SizedBox(height: AppDimensions.lg),
                _FieldLabel(label: 'Special conditions'.tr),
                _LongTextField(
                  controller: controller.specialConditionsController,
                  hintText: 'Separate quick notes with commas'.tr,
                  validator: controller.validateOptionalLonger,
                  minLines: 2,
                  maxLines: 3,
                ),
              ],
            ),
          ),
        );
    }
  }
}

class _StepSectionCard extends StatelessWidget {
  const _StepSectionCard({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppDimensions.radiusLg),
        border: Border.all(color: AppColors.primary200.withValues(alpha: 0.9)),
      ),
      padding: const EdgeInsets.all(AppDimensions.lg),
      child: child,
    );
  }
}

class _SectionCard extends StatelessWidget {
  const _SectionCard({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppDimensions.xl),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppDimensions.radiusXl),
        border: Border.all(color: AppColors.primary200.withValues(alpha: 0.88)),
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: AppColors.primary900.withValues(alpha: 0.06),
            blurRadius: 20,
            offset: const Offset(0, 12),
          ),
        ],
      ),
      child: child,
    );
  }
}

class _StepSupportCard extends StatelessWidget {
  const _StepSupportCard({
    required this.title,
    required this.subtitle,
    required this.child,
  });

  final String title;
  final String subtitle;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppDimensions.xl),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppDimensions.radiusXl),
        border: Border.all(color: AppColors.primary200.withValues(alpha: 0.88)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(title, style: AppTextStyles.h3),
          const SizedBox(height: AppDimensions.xs),
          Text(
            subtitle,
            style: AppTextStyles.bodySmall.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: AppDimensions.lg),
          child,
        ],
      ),
    );
  }
}

class _TopBackButton extends StatelessWidget {
  const _TopBackButton({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(AppDimensions.radiusFull),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppDimensions.radiusFull),
        child: Container(
          width: 42,
          height: 42,
          alignment: Alignment.center,
          child: const Icon(
            Icons.arrow_back_ios_new_rounded,
            size: AppDimensions.iconMd,
            color: AppColors.textPrimary,
          ),
        ),
      ),
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
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppDimensions.radiusFull),
        border: Border.all(color: AppColors.primary200),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Icon(icon, size: AppDimensions.iconSm, color: AppColors.textPrimary),
          const SizedBox(width: AppDimensions.xs),
          Text(
            label,
            style: AppTextStyles.labelMedium.copyWith(
              color: AppColors.textPrimary,
            ),
          ),
        ],
      ),
    );
  }
}

class _PracticeIntroCard extends StatelessWidget {
  const _PracticeIntroCard({
    required this.title,
    required this.subtitle,
    required this.eyebrow,
    required this.status,
  });

  final String title;
  final String subtitle;
  final String eyebrow;
  final String status;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppDimensions.xl),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppDimensions.radiusXl),
        border: Border.all(color: AppColors.primary200.withValues(alpha: 0.88)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            eyebrow,
            style: AppTextStyles.labelMedium.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: AppDimensions.sm),
          Text(
            title,
            style: AppTextStyles.h1.copyWith(color: AppColors.textPrimary),
          ),
          const SizedBox(height: AppDimensions.xs),
          Text(
            subtitle,
            style: AppTextStyles.bodyMedium.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: AppDimensions.md),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(AppDimensions.md),
            decoration: BoxDecoration(
              color: AppColors.neutral50,
              borderRadius: BorderRadius.circular(AppDimensions.radiusLg),
              border: Border.all(color: AppColors.neutral200),
            ),
            child: Text(
              status,
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.textPrimary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SuggestionWrap extends StatelessWidget {
  const _SuggestionWrap({required this.suggestions, required this.onSelected});

  final List<String> suggestions;
  final ValueChanged<String> onSelected;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: AppDimensions.sm,
      runSpacing: AppDimensions.sm,
      children: suggestions
          .map(
            (String suggestion) => InkWell(
              onTap: () => onSelected(suggestion),
              borderRadius: BorderRadius.circular(AppDimensions.radiusFull),
              splashColor: AppColors.primary200,
              highlightColor: AppColors.primary50,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppDimensions.md,
                  vertical: AppDimensions.sm,
                ),
                decoration: BoxDecoration(
                  color: AppColors.primary50,
                  borderRadius: BorderRadius.circular(AppDimensions.radiusFull),
                  border: Border.all(
                    color: AppColors.primary200.withValues(alpha: 0.92),
                  ),
                ),
                child: Text(
                  suggestion.tr,
                  style: AppTextStyles.labelMedium.copyWith(
                    color: AppColors.primary800,
                  ),
                ),
              ),
            ),
          )
          .toList(),
    );
  }
}

class _PresetCard extends StatelessWidget {
  const _PresetCard({required this.preset, required this.onTap});

  final CustomPracticePreset preset;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppDimensions.radiusLg),
      child: Container(
        width: 220,
        padding: const EdgeInsets.all(AppDimensions.lg),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(AppDimensions.radiusLg),
          border: Border.all(color: AppColors.primary200),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(preset.title.tr, style: AppTextStyles.h3),
            const SizedBox(height: AppDimensions.xs),
            Text(
              preset.subtitle.tr,
              style: AppTextStyles.bodySmall.copyWith(
                color: AppColors.textSecondary,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            const Spacer(),
            Text(
              'Use this preset'.tr,
              style: AppTextStyles.labelMedium.copyWith(
                color: AppColors.textPrimary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _FieldLabel extends StatelessWidget {
  const _FieldLabel({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppDimensions.sm),
      child: Text(label, style: AppTextStyles.labelLarge),
    );
  }
}

class _ChipWrap extends StatelessWidget {
  const _ChipWrap({
    required this.values,
    required this.selectedValue,
    required this.labelBuilder,
    required this.onSelected,
  });

  final List<String> values;
  final String selectedValue;
  final String Function(String value) labelBuilder;
  final ValueChanged<String> onSelected;

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: Theme.of(context).copyWith(
        splashColor: AppColors.primary200,
        highlightColor: AppColors.primary50,
      ),
      child: Wrap(
        spacing: AppDimensions.sm,
        runSpacing: AppDimensions.sm,
        children: values
            .map(
              (String value) => ChoiceChip(
                label: Text(
                  labelBuilder(value).tr,
                  style: AppTextStyles.labelMedium.copyWith(
                    color: selectedValue == value
                        ? AppColors.primary900
                        : AppColors.textPrimary,
                    fontWeight: selectedValue == value ? FontWeight.w600 : null,
                  ),
                ),
                selected: selectedValue == value,
                onSelected: (_) => onSelected(value),
                selectedColor: AppColors.primary50,
                backgroundColor: Colors.white,
                side: BorderSide(
                  color: selectedValue == value
                      ? AppColors.primary800
                      : AppColors.primary200,
                  width: selectedValue == value ? 1.2 : 0.8,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppDimensions.radiusFull),
                ),
                showCheckmark: false,
                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
            )
            .toList(),
      ),
    );
  }
}

class _DurationSlider extends StatelessWidget {
  const _DurationSlider({required this.minutes, required this.onChanged});

  final int minutes;
  final ValueChanged<double> onChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppDimensions.md,
        vertical: AppDimensions.sm,
      ),
      decoration: BoxDecoration(
        color: AppColors.primary50,
        borderRadius: BorderRadius.circular(AppDimensions.radiusLg),
        border: Border.all(color: AppColors.primary200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            children: <Widget>[
              Expanded(
                child: Text(
                  'Session time'.tr,
                  style: AppTextStyles.labelMedium.copyWith(
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              Text(
                '$minutes ${'min'.tr}',
                style: AppTextStyles.labelLarge.copyWith(
                  color: AppColors.primary900,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
          SliderTheme(
            data: SliderTheme.of(context).copyWith(
              activeTrackColor: AppColors.primary800,
              inactiveTrackColor: AppColors.primary200,
              thumbColor: AppColors.primary800,
              overlayColor: AppColors.primary200.withValues(alpha: 0.32),
              trackHeight: 5,
            ),
            child: Slider(
              value: minutes.toDouble(),
              min: 5,
              max: 30,
              divisions: 25,
              label: '$minutes ${'min'.tr}',
              onChanged: onChanged,
            ),
          ),
          Text(
            'Pick any duration from 5 to 30 minutes.'.tr,
            style: AppTextStyles.caption.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}

class _LongTextField extends StatelessWidget {
  const _LongTextField({
    required this.controller,
    required this.hintText,
    this.validator,
    this.minLines = 4,
    this.maxLines = 6,
  });

  final TextEditingController controller;
  final String hintText;
  final String? Function(String?)? validator;
  final int minLines;
  final int maxLines;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      validator: validator,
      minLines: minLines,
      maxLines: maxLines,
      style: AppTextStyles.bodyLarge,
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: AppTextStyles.bodyLarge.copyWith(
          color: AppColors.primary300,
        ),
        helperText: ' ',
        helperStyle: AppTextStyles.caption.copyWith(
          color: Colors.transparent,
          height: 1.2,
        ),
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.all(AppDimensions.xl),
        errorStyle: AppTextStyles.caption.copyWith(
          color: AppColors.error,
          height: 1.2,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: BorderSide(
            color: AppColors.primary200.withValues(alpha: 0.9),
            width: 0.9,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: BorderSide(
            color: AppColors.primary200.withValues(alpha: 0.9),
            width: 0.9,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: const BorderSide(color: AppColors.primary800, width: 1.2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: const BorderSide(color: AppColors.error, width: 1),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: const BorderSide(color: AppColors.error, width: 1.2),
        ),
      ),
    );
  }
}

String _contextTypeLabel(String value) {
  switch (value) {
    case 'INTERVIEW':
      return 'Interview';
    case 'WORK':
      return 'Work';
    case 'TRAVEL':
      return 'Travel';
    case 'PHONE_CALL':
      return 'Phone call';
    case 'CUSTOMER_SERVICE':
      return 'Customer service';
    case 'SOCIAL':
      return 'Social';
    case 'MEDICAL':
      return 'Medical';
    case 'OTHER':
    default:
      return 'Other';
  }
}

String _channelLabel(String value) {
  switch (value) {
    case 'PHONE_CALL':
      return 'Phone call';
    case 'VIDEO_CALL':
      return 'Video call';
    case 'IN_PERSON':
    default:
      return 'In person';
  }
}

String _genderLabel(String value) {
  switch (value) {
    case 'FEMALE':
      return 'Female';
    case 'MALE':
      return 'Male';
    case 'NEUTRAL':
    default:
      return 'Neutral';
  }
}

String _toneLabel(String value) {
  switch (value) {
    case 'WARM':
      return 'Warm';
    case 'CALM':
      return 'Calm';
    case 'CONFIDENT':
      return 'Confident';
    case 'FORMAL':
      return 'Formal';
    case 'FRIENDLY':
    default:
      return 'Friendly';
  }
}

String _conversationLengthLabel(String value) {
  switch (value) {
    case 'SHORT':
      return 'Short • ~8 min'.tr;
    case 'LONG':
      return 'Long • ~18 min'.tr;
    case 'MEDIUM':
    default:
      return 'Medium • ~12 min'.tr;
  }
}
