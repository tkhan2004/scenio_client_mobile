import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../core/constants/app_strings.dart';
import '../../core/network/api_response.dart';
import '../../core/utils/scenio_alerts.dart';
import '../../data/models/auth_session_model.dart';
import '../../domain/repositories/auth_repository.dart';
import '../../domain/repositories/user_repository.dart';
import '../../routes/app_routes.dart';

enum AuthMode { login, register }

class AuthViewModel extends GetxController {
  AuthViewModel({
    required AuthRepository repository,
    required UserRepository userRepository,
  }) : _repository = repository,
       _userRepository = userRepository;

  final AuthRepository _repository;
  final UserRepository _userRepository;
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
  final RxInt registerStep = 0.obs;
  final RxBool rememberMe = true.obs;
  final RxBool obscureLoginPassword = true.obs;
  final RxBool obscureRegisterPassword = true.obs;
  final RxString selectedLearningGoal = ''.obs;
  final RxString selectedStudyFrequency = ''.obs;
  final RxString selectedSelfAssessment = ''.obs;
  final RxString learningGoalError = ''.obs;
  final RxString studyFrequencyError = ''.obs;
  final RxString selfAssessmentError = ''.obs;
  final RxBool isSubmittingLogin = false.obs;
  final RxBool isSubmittingRegister = false.obs;

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

  void selectLearningGoal(String value) {
    selectedLearningGoal.value = value;
    learningGoalError.value = '';
  }

  void selectStudyFrequency(String value) {
    selectedStudyFrequency.value = value;
    studyFrequencyError.value = '';
  }

  void selectSelfAssessment(String value) {
    selectedSelfAssessment.value = value;
    selfAssessmentError.value = '';
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
      _handleAuthenticatedSession(session);
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
    if (!_validateOnboardingSelections()) return;

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
      await _userRepository.completeOnboarding(
        learningGoal: selectedLearningGoal.value,
        studyFrequency: selectedStudyFrequency.value,
        selfAssessment: selectedSelfAssessment.value,
      );
      _handleAuthenticatedSession(session, ignoreOnboardingFlag: true);
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
    _showNotice(AppStrings.authGoogleReadyMessage);
  }

  String? _validateRequired(String? value) {
    if (value == null || value.trim().isEmpty) {
      return AppStrings.authRequiredFieldMessage;
    }
    return null;
  }

  bool _validateOnboardingSelections() {
    bool isValid = true;

    if (selectedLearningGoal.value.isEmpty) {
      learningGoalError.value = AppStrings.authRequiredFieldMessage;
      isValid = false;
    } else {
      learningGoalError.value = '';
    }

    if (selectedStudyFrequency.value.isEmpty) {
      studyFrequencyError.value = AppStrings.authRequiredFieldMessage;
      isValid = false;
    } else {
      studyFrequencyError.value = '';
    }

    if (selectedSelfAssessment.value.isEmpty) {
      selfAssessmentError.value = AppStrings.authRequiredFieldMessage;
      isValid = false;
    } else {
      selfAssessmentError.value = '';
    }

    return isValid;
  }

  void _resetRegisterStep() {
    registerStep.value = 0;
    learningGoalError.value = '';
    studyFrequencyError.value = '';
    selfAssessmentError.value = '';
  }

  void _dismissKeyboard() {
    FocusManager.instance.primaryFocus?.unfocus();
  }

  void _handleAuthenticatedSession(
    AuthSessionModel session, {
    bool ignoreOnboardingFlag = false,
  }) {
    _dismissKeyboard();

    if (!ignoreOnboardingFlag && session.needsOnboarding) {
      Get.offAllNamed(Routes.onboarding);
      return;
    }

    if (session.needsLevelTest) {
      _showNotice(AppStrings.authLevelTestPendingMessage);
    }

    Get.offAllNamed(Routes.home);
  }
  void _showNotice(String message) {
    ScenioAlert.show(title: 'Scenio', message: message);
  }

  void _showError(Object error) {
    final String message = error is ApiException
        ? error.message
        : error.toString().replaceFirst('Exception: ', '');
    ScenioAlert.show(title: 'Scenio', message: message, isError: true);
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
