import 'package:get/get.dart';
import '../../domain/repositories/auth_repository.dart';
import '../../core/storage/storage_service.dart';
import 'splash_viewmodel.dart';

class SplashBinding extends Bindings {
  @override
  void dependencies() {
    Get.put<SplashViewModel>(
      SplashViewModel(
        storageService: Get.find<StorageService>(),
        authRepository: Get.find<AuthRepository>(),
      ),
    );
  }
}
