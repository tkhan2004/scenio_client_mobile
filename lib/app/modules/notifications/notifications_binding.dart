import 'package:get/get.dart';

import '../../domain/repositories/learning_repository.dart';
import '../../domain/repositories/notifications_repository.dart';
import 'notifications_viewmodel.dart';

class NotificationsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<NotificationsViewModel>(
      () => NotificationsViewModel(
        notificationsRepository: Get.find<NotificationsRepository>(),
        learningRepository: Get.find<LearningRepository>(),
      ),
    );
  }
}
