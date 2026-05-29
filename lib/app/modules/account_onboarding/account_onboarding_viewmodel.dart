import 'dart:async';

import 'package:get/get.dart';

import '../../core/constants/app_strings.dart';
import '../../core/network/api_response.dart';
import '../../core/utils/scenio_alerts.dart';
import '../../domain/repositories/user_repository.dart';
import '../../routes/app_routes.dart';

class AccountOnboardingViewModel extends GetxController {
  AccountOnboardingViewModel({required UserRepository userRepository})
    : _userRepository = userRepository;

  final UserRepository _userRepository;

  final RxList<String> selectedLearningGoals = <String>[].obs;
  final RxString selectedLevel = ''.obs;
  final RxString selectedStudyFrequency = ''.obs;
  final RxList<String> selectedSelfAssessments = <String>[].obs;
  final RxString learningGoalError = ''.obs;
  final RxString levelError = ''.obs;
  final RxString studyFrequencyError = ''.obs;
  final RxString selfAssessmentError = ''.obs;
  final RxBool isSubmitting = false.obs;
  final RxInt currentStep = 0.obs;

  int get totalSteps => 5;
  bool get isFirstStep => currentStep.value == 0;
  bool get isLastStep => currentStep.value == totalSteps - 1;
  String get progressLabel =>
      '${'Step'.tr} ${currentStep.value + 1} ${'of'.tr} $totalSteps';
  String get primaryButtonLabel {
    if (isSubmitting.value) return AppStrings.accountOnboardingSavingButton;
    return isLastStep ? AppStrings.accountOnboardingSubmitButton : 'Next'.tr;
  }

  void selectLearningGoal(String value) {
    _toggleValue(selectedLearningGoals, value);
    learningGoalError.value = '';
  }

  void selectLevel(String value) {
    selectedLevel.value = value;
    levelError.value = '';
  }

  void selectStudyFrequency(String value) {
    selectedStudyFrequency.value = value;
    studyFrequencyError.value = '';
  }

  void selectSelfAssessment(String value) {
    _toggleValue(selectedSelfAssessments, value);
    selfAssessmentError.value = '';
  }

  void previousStep() {
    if (isFirstStep) return;
    currentStep.value = currentStep.value - 1;
  }

  void handlePrimaryAction() {
    if (isSubmitting.value) {
      return;
    }

    if (!isLastStep) {
      if (_validateCurrentStep()) {
        currentStep.value = currentStep.value + 1;
      }
      return;
    }

    unawaited(_submit());
  }

  void _toggleValue(RxList<String> values, String value) {
    if (values.contains(value)) {
      values.remove(value);
      return;
    }

    values.add(value);
  }

  Future<void> _submit() async {
    if (!_validate()) {
      return;
    }

    isSubmitting.value = true;
    try {
      await _userRepository.completeOnboarding(
        level: selectedLevel.value,
        learningGoal: selectedLearningGoals.first,
        studyFrequency: selectedStudyFrequency.value,
        selfAssessment: selectedSelfAssessments.first,
      );
      ScenioAlert.show(
        title: AppStrings.appName,
        message: AppStrings.accountOnboardingSuccessMessage,
        isSuccess: true,
      );
      Get.offAllNamed(Routes.home);
    } catch (error) {
      final String message = error is ApiException
          ? error.message
          : error.toString().replaceFirst('Exception: ', '');
      ScenioAlert.show(
        title: AppStrings.appName,
        message: message,
        isError: true,
      );
    } finally {
      isSubmitting.value = false;
    }
  }

  bool _validate() {
    bool isValid = true;

    if (selectedLearningGoals.isEmpty) {
      learningGoalError.value = AppStrings.authRequiredFieldMessage;
      isValid = false;
    }

    if (selectedLevel.value.isEmpty) {
      levelError.value = AppStrings.authRequiredFieldMessage;
      isValid = false;
    }

    if (selectedStudyFrequency.value.isEmpty) {
      studyFrequencyError.value = AppStrings.authRequiredFieldMessage;
      isValid = false;
    }

    if (selectedSelfAssessments.isEmpty) {
      selfAssessmentError.value = AppStrings.authRequiredFieldMessage;
      isValid = false;
    }

    return isValid;
  }

  bool _validateCurrentStep() {
    switch (currentStep.value) {
      case 0:
        if (selectedLearningGoals.isEmpty) {
          learningGoalError.value = AppStrings.authRequiredFieldMessage;
          return false;
        }
        return true;
      case 1:
        if (selectedLevel.value.isEmpty) {
          levelError.value = AppStrings.authRequiredFieldMessage;
          return false;
        }
        return true;
      case 2:
        if (selectedStudyFrequency.value.isEmpty) {
          studyFrequencyError.value = AppStrings.authRequiredFieldMessage;
          return false;
        }
        return true;
      case 3:
        if (selectedSelfAssessments.isEmpty) {
          selfAssessmentError.value = AppStrings.authRequiredFieldMessage;
          return false;
        }
        return true;
      case 4:
      default:
        return true;
    }
  }
}
