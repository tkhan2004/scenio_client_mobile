import 'dart:async';

import 'package:get/get.dart';
import '../../core/constants/app_strings.dart';
import '../../core/network/api_response.dart';
import '../../core/storage/storage_service.dart';
import '../../domain/repositories/user_repository.dart';
import '../../routes/app_routes.dart';

class OnboardingViewModel extends GetxController {
  OnboardingViewModel({
    required StorageService storageService,
    required UserRepository userRepository,
  }) : _storageService = storageService,
       _userRepository = userRepository;

  final StorageService _storageService;
  final UserRepository _userRepository;
  final RxInt currentPage = 0.obs;

  int get pageCount => AppStrings.onboardingTitles.length;
  int get currentIndex => currentPage.value;
  bool get isLastPage => currentIndex == pageCount - 1;
  String get tagline => AppStrings.onboardingTagline;
  String get title => AppStrings.onboardingTitles[currentIndex];
  String get subtitle => AppStrings.onboardingSubtitles[currentIndex];

  void nextPage() {
    if (isLastPage) {
      getStarted();
      return;
    }

    currentPage.value += 1;
  }

  void getStarted() {
    unawaited(_getStarted());
  }

  Future<void> _getStarted() async {
    if (_storageService.hasSession) {
      try {
        await _userRepository.completeOnboarding();
      } on ApiException {
        // Keep the app moving even if the survey-mark endpoint is temporarily unavailable.
      } catch (_) {
        // Ignore onboarding sync failures and fall back to local progress.
      }
    }
    await _storageService.markOnboardingSeen();
    Get.offNamed(_storageService.hasSession ? Routes.home : Routes.auth);
  }
}
