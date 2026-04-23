import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_dimensions.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/constants/app_text_styles.dart';
import '../auth_viewmodel.dart';
import '../widgets/auth_primary_button.dart';
import '../widgets/auth_secondary_button.dart';
import '../widgets/auth_text_field.dart';

class RegisterView extends StatelessWidget {
  const RegisterView({super.key, required this.viewModel});

  final AuthViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    return Form(
      key: viewModel.registerFormKey,
      child: Obx(
        () => AnimatedSwitcher(
          duration: const Duration(milliseconds: 180),
          switchInCurve: Curves.easeOutCubic,
          switchOutCurve: Curves.easeInCubic,
          layoutBuilder: _buildTopAlignedLayout,
          transitionBuilder: _buildRegisterFadeTransition,
          child: viewModel.isRegisterStepOne
              ? _RegisterStepOneFields(
                  key: const ValueKey<String>('register_step_one_fields'),
                  viewModel: viewModel,
                )
              : _RegisterStepTwoFields(
                  key: const ValueKey<String>('register_step_two_fields'),
                  viewModel: viewModel,
                ),
        ),
      ),
    );
  }
}

class RegisterFooter extends StatelessWidget {
  const RegisterFooter({super.key, required this.viewModel});

  final AuthViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final bool isStepOne = viewModel.isRegisterStepOne;

      return SizedBox(
        height: AppDimensions.buttonHeight + 4,
        child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 180),
          switchInCurve: Curves.easeOutCubic,
          switchOutCurve: Curves.easeInCubic,
          layoutBuilder: _buildCenteredLayout,
          transitionBuilder: _buildRegisterFadeTransition,
          child: isStepOne
              ? AuthPrimaryButton(
                  key: const ValueKey<String>('register_footer_next'),
                  label: AppStrings.authNextButton,
                  onPressed: viewModel.nextRegisterStep,
                )
              : Row(
                  key: const ValueKey<String>('register_footer_submit'),
                  children: <Widget>[
                    Expanded(
                      child: AuthSecondaryButton(
                        label: AppStrings.authBackButton,
                        onPressed: viewModel.previousRegisterStep,
                      ),
                    ),
                    SizedBox(width: AppDimensions.md),
                    Expanded(
                      child: AuthPrimaryButton(
                        label: AppStrings.authRegisterButton,
                        onPressed: viewModel.submitRegister,
                      ),
                    ),
                  ],
                ),
        ),
      );
    });
  }
}

class RegisterProgressHeader extends StatelessWidget {
  const RegisterProgressHeader({
    super.key,
    required this.currentStep,
    required this.totalSteps,
  });

  final int currentStep;
  final int totalSteps;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Row(
          children: List<Widget>.generate(totalSteps, (int index) {
            final bool isActive = index <= currentStep;
            return Expanded(
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                curve: Curves.easeOutCubic,
                height: 3,
                margin: EdgeInsets.only(
                  right: index == totalSteps - 1 ? 0 : AppDimensions.sm,
                ),
                decoration: BoxDecoration(
                  color: isActive
                      ? AppColors.primary700
                      : AppColors.primary200.withValues(alpha: 0.72),
                  borderRadius: BorderRadius.circular(AppDimensions.radiusFull),
                ),
              ),
            );
          }),
        ),
        SizedBox(height: AppDimensions.xs),
        Text(
          '${AppStrings.authRegisterStepLabel} ${currentStep + 1}/$totalSteps',
          style: AppTextStyles.labelMedium.copyWith(
            color: AppColors.primary500,
          ),
        ),
      ],
    );
  }
}

Widget _buildTopAlignedLayout(
  Widget? currentChild,
  List<Widget> previousChildren,
) {
  return Stack(
    alignment: Alignment.topLeft,
    children: <Widget>[
      ...previousChildren,
      if (currentChild case final Widget child) child,
    ],
  );
}

Widget _buildCenteredLayout(
  Widget? currentChild,
  List<Widget> previousChildren,
) {
  return Stack(
    alignment: Alignment.center,
    children: <Widget>[
      ...previousChildren,
      if (currentChild case final Widget child) child,
    ],
  );
}

Widget _buildRegisterFadeTransition(Widget child, Animation<double> animation) {
  return FadeTransition(opacity: animation, child: child);
}

class _RegisterStepOneFields extends StatelessWidget {
  const _RegisterStepOneFields({super.key, required this.viewModel});

  final AuthViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    return Column(
      key: key,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Row(
          children: <Widget>[
            Expanded(
              child: _LabeledField(
                label: AppStrings.authFirstNameLabel,
                child: AuthTextField(
                  controller: viewModel.firstNameController,
                  hintText: AppStrings.authNameHint,
                  textInputAction: TextInputAction.next,
                  validator: viewModel.validateName,
                  autofillHints: const <String>[AutofillHints.givenName],
                ),
              ),
            ),
            SizedBox(width: AppDimensions.md),
            Expanded(
              child: _LabeledField(
                label: AppStrings.authLastNameLabel,
                child: AuthTextField(
                  controller: viewModel.lastNameController,
                  hintText: AppStrings.authNameHint,
                  textInputAction: TextInputAction.next,
                  validator: viewModel.validateName,
                  autofillHints: const <String>[AutofillHints.familyName],
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: AppDimensions.md),
        _LabeledField(
          label: AppStrings.authEmailLabel,
          child: AuthTextField(
            controller: viewModel.emailController,
            hintText: AppStrings.authEmailHint,
            keyboardType: TextInputType.emailAddress,
            textInputAction: TextInputAction.next,
            validator: viewModel.validateEmail,
            autofillHints: const <String>[AutofillHints.email],
          ),
        ),
        SizedBox(height: AppDimensions.md),
        _LabeledField(
          label: AppStrings.authPasswordLabel,
          child: Obx(
            () => AuthTextField(
              controller: viewModel.registerPasswordController,
              hintText: AppStrings.authPasswordHint,
              obscureText: viewModel.obscureRegisterPassword.value,
              textInputAction: TextInputAction.done,
              validator: viewModel.validatePassword,
              autofillHints: const <String>[AutofillHints.newPassword],
              onToggleObscure: viewModel.toggleRegisterPasswordVisibility,
              onFieldSubmitted: (_) => viewModel.nextRegisterStep(),
            ),
          ),
        ),
      ],
    );
  }
}

class _RegisterStepTwoFields extends StatelessWidget {
  const _RegisterStepTwoFields({super.key, required this.viewModel});

  final AuthViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    return Column(
      key: key,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        _ChoiceSection(
          label: AppStrings.authLearningGoalLabel,
          selectedValue: viewModel.selectedLearningGoal.value,
          errorText: viewModel.learningGoalError.value,
          options: const <_ChoiceOption>[
            _ChoiceOption(label: 'Work', value: 'WORK'),
            _ChoiceOption(label: 'Travel', value: 'TRAVEL'),
            _ChoiceOption(label: 'Daily life', value: 'DAILY'),
            _ChoiceOption(label: 'Mixed', value: 'ALL'),
          ],
          onSelected: viewModel.selectLearningGoal,
        ),
        const SizedBox(height: AppDimensions.md),
        _ChoiceSection(
          label: AppStrings.authStudyFrequencyLabel,
          selectedValue: viewModel.selectedStudyFrequency.value,
          errorText: viewModel.studyFrequencyError.value,
          options: const <_ChoiceOption>[
            _ChoiceOption(label: 'Light', value: 'LIGHT'),
            _ChoiceOption(label: 'Regular', value: 'REGULAR'),
            _ChoiceOption(label: 'Intensive', value: 'INTENSIVE'),
          ],
          onSelected: viewModel.selectStudyFrequency,
        ),
        const SizedBox(height: AppDimensions.md),
        _ChoiceSection(
          label: AppStrings.authSelfAssessmentLabel,
          selectedValue: viewModel.selectedSelfAssessment.value,
          errorText: viewModel.selfAssessmentError.value,
          options: const <_ChoiceOption>[
            _ChoiceOption(label: 'Vocabulary', value: 'VOCABULARY'),
            _ChoiceOption(label: 'Grammar', value: 'GRAMMAR'),
            _ChoiceOption(label: 'Naturalness', value: 'NATURALNESS'),
            _ChoiceOption(label: 'Confidence', value: 'CONFIDENCE'),
          ],
          onSelected: viewModel.selectSelfAssessment,
        ),
      ],
    );
  }
}

class _ChoiceSection extends StatelessWidget {
  const _ChoiceSection({
    required this.label,
    required this.selectedValue,
    required this.errorText,
    required this.options,
    required this.onSelected,
  });

  final String label;
  final String selectedValue;
  final String errorText;
  final List<_ChoiceOption> options;
  final ValueChanged<String> onSelected;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(label, style: AppTextStyles.labelLarge),
        const SizedBox(height: AppDimensions.sm),
        Wrap(
          spacing: AppDimensions.sm,
          runSpacing: AppDimensions.sm,
          children: options.map((_ChoiceOption option) {
            final bool isSelected = selectedValue == option.value;

            return InkWell(
              onTap: () => onSelected(option.value),
              borderRadius: BorderRadius.circular(18),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 180),
                curve: Curves.easeOutCubic,
                padding: const EdgeInsets.symmetric(
                  horizontal: AppDimensions.lg,
                  vertical: AppDimensions.sm,
                ),
                decoration: BoxDecoration(
                  color: isSelected
                      ? AppColors.primary700.withValues(alpha: 0.12)
                      : AppColors.primary50.withValues(alpha: 0.66),
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(
                    color: isSelected
                        ? AppColors.primary700
                        : AppColors.primary200.withValues(alpha: 0.88),
                    width: isSelected ? 1.2 : 0.9,
                  ),
                ),
                child: Text(
                  option.label,
                  style: AppTextStyles.labelLarge.copyWith(
                    color: isSelected
                        ? AppColors.primary800
                        : AppColors.textPrimary,
                  ),
                ),
              ),
            );
          }).toList(),
        ),
        const SizedBox(height: 2),
        SizedBox(
          height: 14,
          child: errorText.isEmpty
              ? const SizedBox.shrink()
              : Text(
                  errorText,
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.error,
                    height: 1.2,
                  ),
                ),
        ),
      ],
    );
  }
}

class _LabeledField extends StatelessWidget {
  const _LabeledField({required this.label, required this.child});

  final String label;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(label, style: AppTextStyles.labelLarge),
        const SizedBox(height: AppDimensions.xs),
        child,
      ],
    );
  }
}

class _ChoiceOption {
  const _ChoiceOption({required this.label, required this.value});

  final String label;
  final String value;
}
