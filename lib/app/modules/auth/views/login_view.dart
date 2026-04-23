import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/constants/app_dimensions.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/constants/app_text_styles.dart';
import '../auth_viewmodel.dart';
import '../widgets/auth_primary_button.dart';
import '../widgets/auth_text_field.dart';

class LoginView extends StatelessWidget {
  const LoginView({super.key, required this.viewModel});

  final AuthViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    return Form(
      key: viewModel.loginFormKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(AppStrings.authIdentifierLabel, style: AppTextStyles.labelLarge),
          SizedBox(height: AppDimensions.sm),
          AuthTextField(
            controller: viewModel.loginIdentifierController,
            hintText: AppStrings.authIdentifierHint,
            keyboardType: TextInputType.emailAddress,
            textInputAction: TextInputAction.next,
            validator: viewModel.validateIdentifier,
            autofillHints: const <String>[
              AutofillHints.username,
              AutofillHints.email,
            ],
          ),
          SizedBox(height: AppDimensions.xl),
          Text(AppStrings.authPasswordLabel, style: AppTextStyles.labelLarge),
          SizedBox(height: AppDimensions.sm),
          Obx(
            () => AuthTextField(
              controller: viewModel.loginPasswordController,
              hintText: AppStrings.authPasswordHint,
              obscureText: viewModel.obscureLoginPassword.value,
              textInputAction: TextInputAction.done,
              validator: viewModel.validatePassword,
              autofillHints: const <String>[AutofillHints.password],
              onToggleObscure: viewModel.toggleLoginPasswordVisibility,
              onFieldSubmitted: (_) => viewModel.submitLogin(),
            ),
          ),
          const SizedBox(height: AppDimensions.lg),
          Row(
            children: <Widget>[
              Obx(
                () => _RememberMeToggle(
                  value: viewModel.rememberMe.value,
                  onTap: viewModel.toggleRememberMe,
                ),
              ),
              Spacer(),
              TextButton(
                onPressed: viewModel.handleForgotPassword,
                child: Text(
                  AppStrings.authForgotPassword,
                  style: AppTextStyles.labelLarge,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class LoginFooter extends StatelessWidget {
  const LoginFooter({super.key, required this.viewModel});

  final AuthViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    return Column(
      key: key,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        AuthPrimaryButton(
          label: AppStrings.authLoginButton,
          onPressed: viewModel.submitLogin,
        ),
      ],
    );
  }
}

class _RememberMeToggle extends StatelessWidget {
  const _RememberMeToggle({required this.value, required this.onTap});

  final bool value;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppDimensions.radiusFull),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            width: 24,
            height: 24,
            decoration: BoxDecoration(
              color: value ? const Color(0xFFE6F8F0) : Colors.white,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: value
                    ? const Color(0xFF1D9E75)
                    : const Color(0xFFD3D1C7),
                width: 1,
              ),
            ),
            child: value
                ? const Icon(
                    Icons.check_rounded,
                    size: 18,
                    color: Color(0xFF1D9E75),
                  )
                : null,
          ),
          SizedBox(width: AppDimensions.md),
          Text(AppStrings.authRememberMe, style: AppTextStyles.bodyMedium),
        ],
      ),
    );
  }
}
