import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../core/constants/app_strings.dart';
import '../../core/network/api_response.dart';
import '../../core/utils/scenio_alerts.dart';
import '../../data/models/auth_session_model.dart';
import '../../domain/repositories/auth_repository.dart';
import '../../routes/app_routes.dart';

enum AuthMode { login, register }

class AuthViewModel extends GetxController {
  AuthViewModel({required AuthRepository repository})
    : _repository = repository;

  final AuthRepository _repository;
  final GlobalKey<FormState> loginFormKey = GlobalKey<FormState>();
  final GlobalKey<FormState> registerFormKey = GlobalKey<FormState>();

  final TextEditingController loginIdentifierController =
      TextEditingController();
  final TextEditingController loginPasswordController = TextEditingController();
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController registerPasswordController =
      TextEditingController();

  final Rx<AuthMode> mode = AuthMode.login.obs;
  final RxBool rememberMe = true.obs;
  final RxBool obscureLoginPassword = true.obs;
  final RxBool obscureRegisterPassword = true.obs;
  final RxBool isSubmittingLogin = false.obs;
  final RxBool isSubmittingRegister = false.obs;
  final RxBool isSubmittingGoogle = false.obs;

  bool get isLogin => mode.value == AuthMode.login;
  bool get isRegister => mode.value == AuthMode.register;
  bool get isGoogleSignInAvailable => _repository.isGoogleSignInAvailable;
  String get googleSignInHint =>
      _repository.googleSignInUnavailableMessage ??
      AppStrings.authGoogleReadyMessage;

  void showLogin() {
    _dismissKeyboard();
    mode.value = AuthMode.login;
  }

  void showRegister() {
    _dismissKeyboard();
    mode.value = AuthMode.register;
  }

  void toggleRememberMe() {
    rememberMe.value = !rememberMe.value;
  }

  void toggleLoginPasswordVisibility() {
    obscureLoginPassword.value = !obscureLoginPassword.value;
  }

  void toggleRegisterPasswordVisibility() {
    obscureRegisterPassword.value = !obscureRegisterPassword.value;
  }

  void handleRegisterBackNavigation() {
    showLogin();
  }

  String? validateIdentifier(String? value) {
    return validateEmail(value);
  }

  String? validateName(String? value) {
    return _validateRequired(value);
  }

  String? validateEmail(String? value) {
    final String? requiredError = _validateRequired(value);
    if (requiredError != null) return requiredError;

    final String email = value!.trim();
    final bool isValid = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$').hasMatch(email);

    if (!isValid) return AppStrings.authInvalidEmailMessage;
    return null;
  }

  String? validatePassword(String? value) {
    final String? requiredError = _validateRequired(value);
    if (requiredError != null) return requiredError;

    if (value!.trim().length < 6) {
      return AppStrings.authPasswordTooShortMessage;
    }
    return null;
  }

  void submitLogin() {
    unawaited(_submitLogin());
  }

  Future<void> _submitLogin() async {
    final FormState? formState = loginFormKey.currentState;
    if (formState == null || !formState.validate()) return;

    isSubmittingLogin.value = true;
    try {
      final session = await _repository.login(
        email: loginIdentifierController.text.trim(),
        password: loginPasswordController.text.trim(),
      );
      _handleAuthenticatedSession(
        session,
        successMessage: AppStrings.authLoginSuccessMessage,
      );
    } catch (error) {
      _showError(error);
    } finally {
      isSubmittingLogin.value = false;
    }
  }

  void submitRegister() {
    unawaited(_submitRegister());
  }

  Future<void> _submitRegister() async {
    final FormState? formState = registerFormKey.currentState;
    if (formState == null || !formState.validate()) return;

    isSubmittingRegister.value = true;
    try {
      final String displayName =
          '${firstNameController.text.trim()} ${lastNameController.text.trim()}'
              .trim();
      final AuthSessionModel session = await _repository.register(
        email: emailController.text.trim(),
        password: registerPasswordController.text.trim(),
        displayName: displayName,
      );
      _handleAuthenticatedSession(
        session,
        successMessage: AppStrings.authRegisterSuccessMessage,
      );
    } catch (error) {
      _showError(error);
    } finally {
      isSubmittingRegister.value = false;
    }
  }

  void handleForgotPassword() {
    _showNotice(AppStrings.authForgotPasswordMessage);
  }

  void handleGoogleSignIn() {
    unawaited(_handleGoogleSignIn());
  }

  Future<void> _handleGoogleSignIn() async {
    if (isSubmittingGoogle.value) {
      return;
    }

    if (!isGoogleSignInAvailable) {
      _showNotice(googleSignInHint);
      return;
    }

    _dismissKeyboard();
    isSubmittingGoogle.value = true;
    try {
      final AuthSessionModel session = await _repository.loginWithGoogle();
      _handleAuthenticatedSession(
        session,
        successMessage: AppStrings.authGoogleSuccessMessage,
      );
    } catch (error) {
      _showError(error);
    } finally {
      isSubmittingGoogle.value = false;
    }
  }

  String? _validateRequired(String? value) {
    if (value == null || value.trim().isEmpty) {
      return AppStrings.authRequiredFieldMessage;
    }
    return null;
  }

  void _dismissKeyboard() {
    FocusManager.instance.primaryFocus?.unfocus();
  }

  void _handleAuthenticatedSession(
    AuthSessionModel session, {
    required String successMessage,
  }) {
    _dismissKeyboard();
    _showSuccess(successMessage);

    if (session.needsOnboarding) {
      Get.offAllNamed(Routes.accountOnboarding);
      return;
    }

    if (session.needsLevelTest) {
      _showLevelTestNoticeAfterSuccess();
    }

    Get.offAllNamed(Routes.home);
  }

  void _showNotice(String message) {
    ScenioAlert.show(title: AppStrings.appName, message: message);
  }

  void _showSuccess(String message) {
    ScenioAlert.show(
      title: AppStrings.appName,
      message: message,
      icon: Icons.check_circle_outline_rounded,
      isSuccess: true,
    );
  }

  void _showLevelTestNoticeAfterSuccess() {
    Future<void>.delayed(const Duration(milliseconds: 3200), () {
      if (Get.currentRoute != Routes.home) return;

      ScenioAlert.show(
        title: AppStrings.appName,
        message: AppStrings.authLevelTestPendingMessage,
      );
    });
  }

  void _showError(Object error) {
    final String message = error is ApiException
        ? error.message
        : error.toString().replaceFirst('Exception: ', '');
    ScenioAlert.show(
      title: AppStrings.appName,
      message: message,
      isError: true,
    );
  }

  @override
  void onClose() {
    loginIdentifierController.dispose();
    loginPasswordController.dispose();
    firstNameController.dispose();
    lastNameController.dispose();
    emailController.dispose();
    registerPasswordController.dispose();
    super.onClose();
  }
}
