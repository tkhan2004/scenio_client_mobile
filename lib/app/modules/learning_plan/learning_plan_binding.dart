import 'package:get/get.dart';

import '../../domain/repositories/learning_repository.dart';
import 'learning_plan_viewmodel.dart';

class LearningPlanBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<LearningPlanViewModel>(
      () => LearningPlanViewModel(repository: Get.find<LearningRepository>()),
    );
  }
}
