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

  final RxString selectedLearningGoal = ''.obs;
  final RxString selectedLevel = ''.obs;
  final RxString selectedStudyFrequency = ''.obs;
  final RxString selectedSelfAssessment = ''.obs;
  final RxString learningGoalError = ''.obs;
  final RxString levelError = ''.obs;
  final RxString studyFrequencyError = ''.obs;
  final RxString selfAssessmentError = ''.obs;
  final RxBool isSubmitting = false.obs;

  void selectLearningGoal(String value) {
    selectedLearningGoal.value = value;
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
    selectedSelfAssessment.value = value;
    selfAssessmentError.value = '';
  }

  void submit() {
    if (isSubmitting.value) {
      return;
    }

    unawaited(_submit());
  }

  Future<void> _submit() async {
    if (!_validate()) {
      return;
    }

    isSubmitting.value = true;
    try {
      await _userRepository.completeOnboarding(
        level: selectedLevel.value,
        learningGoal: selectedLearningGoal.value,
        studyFrequency: selectedStudyFrequency.value,
        selfAssessment: selectedSelfAssessment.value,
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

    if (selectedLearningGoal.value.isEmpty) {
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

    if (selectedSelfAssessment.value.isEmpty) {
      selfAssessmentError.value = AppStrings.authRequiredFieldMessage;
      isValid = false;
    }

    return isValid;
  }
}
