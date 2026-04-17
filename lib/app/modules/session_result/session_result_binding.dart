import 'package:get/get.dart';

import 'session_result_viewmodel.dart';

class SessionResultBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SessionResultViewModel>(SessionResultViewModel.new);
  }
}
