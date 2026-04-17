import 'package:get/get.dart';

import 'scene_detail_viewmodel.dart';

class SceneDetailBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SceneDetailViewModel>(SceneDetailViewModel.new);
  }
}
