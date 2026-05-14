import 'package:get/get.dart';
import '../../domain/repositories/auth_repository.dart';
import 'auth_viewmodel.dart';

class AuthBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AuthViewModel>(
      () => AuthViewModel(repository: Get.find<AuthRepository>()),
    );
  }
}
