import 'dart:async';

import 'package:get/get.dart';
import '../../core/constants/app_strings.dart';
import '../../core/storage/storage_service.dart';
import '../../routes/app_routes.dart';

class OnboardingViewModel extends GetxController {
  OnboardingViewModel({required StorageService storageService})
    : _storageService = storageService;

  final StorageService _storageService;
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
    await _storageService.markOnboardingSeen();
    Get.offNamed(_storageService.hasSession ? Routes.home : Routes.auth);
  }
}
