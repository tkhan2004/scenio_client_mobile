import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../core/constants/app_strings.dart';
import '../../core/utils/scenio_alerts.dart';
import '../../routes/app_routes.dart';

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
  final TextEditingController birthDateController = TextEditingController();
  final TextEditingController registerPasswordController =
      TextEditingController();

  final Rx<AuthMode> mode = AuthMode.login.obs;
  final RxInt registerStep = 0.obs;
  final RxBool rememberMe = true.obs;
  final RxBool obscureLoginPassword = true.obs;
  final RxBool obscureRegisterPassword = true.obs;
  final RxString selectedGender = ''.obs;
  final RxString genderError = ''.obs;

  bool get isLogin => mode.value == AuthMode.login;
  bool get isRegister => mode.value == AuthMode.register;
  bool get isRegisterStepOne => registerStep.value == 0;
  bool get isRegisterStepTwo => registerStep.value == 1;
  int get registerStepCount => 2;
  String get registerStepTitle => isRegisterStepOne
      ? AppStrings.authRegisterStepOneTitle
      : AppStrings.authRegisterStepTwoTitle;
  String get registerStepCaption => isRegisterStepOne
      ? AppStrings.authRegisterStepOneCaption
      : AppStrings.authRegisterStepTwoCaption;

  void showLogin() {
    _dismissKeyboard();
    _resetRegisterStep();
    mode.value = AuthMode.login;
  }

  void showRegister() {
    _dismissKeyboard();
    _resetRegisterStep();
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

  void nextRegisterStep() {
    final FormState? formState = registerFormKey.currentState;
    if (formState == null || !formState.validate()) return;

    _dismissKeyboard();
    registerStep.value = 1;
  }

  void previousRegisterStep() {
    _dismissKeyboard();
    if (registerStep.value > 0) {
      registerStep.value -= 1;
    }
  }

  void handleRegisterBackNavigation() {
    if (isRegisterStepTwo) {
      previousRegisterStep();
      return;
    }

    showLogin();
  }

  void setBirthDate(DateTime date) {
    birthDateController.text = _formatDate(date);
  }

  void selectGender(String gender) {
    selectedGender.value = gender;
    genderError.value = '';
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

  String? validateBirthDate(String? value) {
    return _validateRequired(value);
  }

  Future<void> submitLogin() async {
    final FormState? formState = loginFormKey.currentState;
    if (formState == null || !formState.validate()) return;

    _goToHome();
  }

  Future<void> submitRegister() async {
    final FormState? formState = registerFormKey.currentState;
    if (formState == null || !formState.validate()) return;
    if (!_validateGenderSelection()) return;

    _goToHome();
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

  bool _validateGenderSelection() {
    if (selectedGender.value.isEmpty) {
      genderError.value = AppStrings.authRequiredFieldMessage;
      return false;
    }
    genderError.value = '';
    return true;
  }

  void _resetRegisterStep() {
    registerStep.value = 0;
    genderError.value = '';
  }

  void _dismissKeyboard() {
    FocusManager.instance.primaryFocus?.unfocus();
  }

  void _goToHome() {
    _dismissKeyboard();
    Get.offAllNamed(Routes.home);
  }

  String _formatDate(DateTime date) {
    final String day = date.day.toString().padLeft(2, '0');
    final String month = date.month.toString().padLeft(2, '0');
    return '$day/$month/${date.year}';
  }

  void _showNotice(String message) {
    ScenioAlert.show(
      title: 'Scenio',
      message: message,
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
    birthDateController.dispose();
    registerPasswordController.dispose();
    super.onClose();
  }
}
