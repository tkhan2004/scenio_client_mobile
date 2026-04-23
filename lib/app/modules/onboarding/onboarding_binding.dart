import 'package:get/get.dart';
import '../../core/storage/storage_service.dart';
import '../../domain/repositories/user_repository.dart';
import 'onboarding_viewmodel.dart';

class OnboardingBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<OnboardingViewModel>(
      () => OnboardingViewModel(
        storageService: Get.find<StorageService>(),
        userRepository: Get.find<UserRepository>(),
      ),
    );
  }
}
