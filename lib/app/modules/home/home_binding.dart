import 'package:get/get.dart';
import '../profile/profile_viewmodel.dart';
import '../vocabulary/vocabulary_binding.dart';
import 'home_viewmodel.dart';

class HomeBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<HomeViewModel>(HomeViewModel.new);
    VocabularyBinding().dependencies();
    Get.lazyPut<ProfileViewModel>(ProfileViewModel.new);
  }
}
