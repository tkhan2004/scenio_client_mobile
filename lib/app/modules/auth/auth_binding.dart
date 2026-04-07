import 'package:get/get.dart';
import 'auth_viewmodel.dart';

class AuthBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AuthViewModel>(() => AuthViewModel());
  }
}
