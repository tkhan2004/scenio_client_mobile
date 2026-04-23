import 'package:get/get.dart';

import 'custom_practice_viewmodel.dart';

class CustomPracticeBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<CustomPracticeViewModel>(CustomPracticeViewModel.new);
  }
}
