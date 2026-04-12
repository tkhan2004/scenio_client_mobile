import 'package:get/get.dart';
import '../../core/constants/app_strings.dart';
import '../../routes/app_routes.dart';

class OnboardingViewModel extends GetxController {
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
    Get.offNamed(Routes.auth);
  }
}
