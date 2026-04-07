import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_strings.dart';
import '../../routes/app_routes.dart';

class OnboardingViewModel extends GetxController {
  final RxInt currentPage = 0.obs;

  int get pageCount => AppStrings.onboardingTitles.length;
  int get currentIndex => currentPage.value;
  String get brandName => AppStrings.appName;
  String get tagline => AppStrings.onboardingTagline;
  String get title => AppStrings.onboardingTitles[currentIndex];
  String get subtitle => AppStrings.onboardingSubtitles[currentIndex];

  Color get accentColor => <Color>[
    AppColors.secondary500,
    AppColors.primary500,
    AppColors.accent500,
    AppColors.primary700,
  ][currentIndex];

  Color get accentSoftColor => <Color>[
    AppColors.secondary50,
    AppColors.primary50,
    AppColors.accent50,
    AppColors.primary200,
  ][currentIndex];

  void nextPage() {
    currentPage.value = (currentPage.value + 1) % pageCount;
  }

  void getStarted() {
    Get.toNamed(Routes.auth);
  }
}
