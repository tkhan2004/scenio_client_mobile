import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_strings.dart';

enum AuthMode { login, register }

class AuthViewModel extends GetxController {
  final GlobalKey<FormState> loginFormKey = GlobalKey<FormState>();
  final GlobalKey<FormState> registerFormKey = GlobalKey<FormState>();

  final TextEditingController loginIdentifierController =
      TextEditingController();
  final TextEditingController loginPasswordController = TextEditingController();
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController registerPasswordController =
      TextEditingController();

  final Rx<AuthMode> mode = AuthMode.login.obs;
  final RxBool rememberMe = true.obs;
  final RxBool obscureLoginPassword = true.obs;
  final RxBool obscureRegisterPassword = true.obs;

  bool get isLogin => mode.value == AuthMode.login;
  bool get isRegister => mode.value == AuthMode.register;
  String get brandName => AppStrings.appName;

  void showLogin() {
    mode.value = AuthMode.login;
  }

  void showRegister() {
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

  String? validateIdentifier(String? value) {
    return _validateRequired(value);
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

  String? validatePhone(String? value) {
    final String? requiredError = _validateRequired(value);
    if (requiredError != null) return requiredError;

    final String digitsOnly = value!.replaceAll(RegExp(r'\D'), '');
    if (digitsOnly.length < 8 || digitsOnly.length > 15) {
      return AppStrings.authInvalidPhoneMessage;
    }
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

  Future<void> submitLogin() async {
    final FormState? formState = loginFormKey.currentState;
    if (formState == null || !formState.validate()) return;

    _showNotice(AppStrings.authLoginReadyMessage);
  }

  Future<void> submitRegister() async {
    final FormState? formState = registerFormKey.currentState;
    if (formState == null || !formState.validate()) return;

    _showNotice(AppStrings.authRegisterReadyMessage);
  }

  void handleForgotPassword() {
    _showNotice(AppStrings.authForgotPasswordMessage);
  }

  void handleGoogleSignIn() {
    _showNotice(AppStrings.authGoogleReadyMessage);
  }

  void handleFacebookSignIn() {
    _showNotice(AppStrings.authFacebookReadyMessage);
  }

  String? _validateRequired(String? value) {
    if (value == null || value.trim().isEmpty) {
      return AppStrings.authRequiredFieldMessage;
    }
    return null;
  }

  void _showNotice(String message) {
    Get.snackbar(
      AppStrings.appName,
      message,
      snackPosition: SnackPosition.BOTTOM,
      margin: const EdgeInsets.all(16),
      backgroundColor: AppColors.primary800,
      colorText: Colors.white,
    );
  }

  @override
  void onClose() {
    loginIdentifierController.dispose();
    loginPasswordController.dispose();
    firstNameController.dispose();
    lastNameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    registerPasswordController.dispose();
    super.onClose();
  }
}
