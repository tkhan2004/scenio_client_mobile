import 'package:get/get.dart';
import '../../core/storage/storage_service.dart';
import '../../domain/repositories/auth_repository.dart';
import '../../domain/repositories/learning_repository.dart';
import '../../domain/repositories/user_repository.dart';
import '../profile/profile_viewmodel.dart';
import '../vocabulary/vocabulary_binding.dart';
import 'home_viewmodel.dart';

class HomeBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<HomeViewModel>(
      () => HomeViewModel(
        repository: Get.find<LearningRepository>(),
        authRepository: Get.find<AuthRepository>(),
        storageService: Get.find<StorageService>(),
      ),
    );
    VocabularyBinding().dependencies();
    Get.lazyPut<ProfileViewModel>(
      () => ProfileViewModel(
        authRepository: Get.find<AuthRepository>(),
        userRepository: Get.find<UserRepository>(),
      ),
    );
  }
}
