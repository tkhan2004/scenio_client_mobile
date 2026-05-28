import 'package:get/get.dart';

import '../../domain/repositories/learning_repository.dart';
import 'roadmap_completion_viewmodel.dart';

class RoadmapCompletionBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<RoadmapCompletionViewModel>(
      () => RoadmapCompletionViewModel(
        repository: Get.find<LearningRepository>(),
      ),
    );
  }
}
