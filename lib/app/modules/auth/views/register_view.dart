import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/constants/app_dimensions.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/constants/app_text_styles.dart';
import '../auth_viewmodel.dart';
import '../widgets/auth_primary_button.dart';
import '../widgets/auth_text_field.dart';
import '../widgets/social_login_button.dart';

class RegisterView extends StatelessWidget {
  const RegisterView({super.key, required this.viewModel});

  final AuthViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    return Form(
      key: viewModel.registerFormKey,
      child: Column(
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
              const SizedBox(width: AppDimensions.md),
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
          const SizedBox(height: AppDimensions.md),
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
          const SizedBox(height: AppDimensions.md),
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
                onFieldSubmitted: (_) => viewModel.submitRegister(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class RegisterFooter extends StatelessWidget {
  const RegisterFooter({super.key, required this.viewModel});

  final AuthViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Column(
        key: key,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          AuthPrimaryButton(
            label: AppStrings.authRegisterButton,
            onPressed: viewModel.submitRegister,
          ),
          const SizedBox(height: AppDimensions.lg),
          Row(
            children: <Widget>[
              const Expanded(child: Divider(height: 1)),
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppDimensions.md,
                ),
                child: Text(
                  AppStrings.authSocialDivider,
                  style: AppTextStyles.labelMedium,
                ),
              ),
              const Expanded(child: Divider(height: 1)),
            ],
          ),
          const SizedBox(height: AppDimensions.lg),
          SocialLoginButton(
            label: AppStrings.authGoogleButton,
            leading: const GoogleSocialMark(),
            onPressed: viewModel.handleGoogleSignIn,
            isLoading: viewModel.isSubmittingGoogle.value,
            isEnabled: viewModel.isGoogleSignInAvailable,
          ),
          if (!viewModel.isGoogleSignInAvailable) ...<Widget>[
            const SizedBox(height: AppDimensions.sm),
            Text(
              viewModel.googleSignInHint,
              textAlign: TextAlign.center,
              style: AppTextStyles.bodySmall.copyWith(
                color: const Color(0xFF7B8794),
              ),
            ),
          ],
        ],
      ),
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
