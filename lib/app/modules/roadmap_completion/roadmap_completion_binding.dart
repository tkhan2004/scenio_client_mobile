import 'package:get/get.dart';

import 'roadmap_completion_viewmodel.dart';

class RoadmapCompletionBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<RoadmapCompletionViewModel>(() => RoadmapCompletionViewModel());
  }
}
