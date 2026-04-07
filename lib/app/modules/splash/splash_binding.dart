import 'package:get/get.dart';
import 'splash_viewmodel.dart';

class SplashBinding extends Bindings {
  @override
  void dependencies() {
    Get.put<SplashViewModel>(SplashViewModel());
  }
}
