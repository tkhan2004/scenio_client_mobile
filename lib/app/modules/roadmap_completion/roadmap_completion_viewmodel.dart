import 'package:get/get.dart';

import '../../data/models/learning_plan_model.dart';
import '../../routes/app_routes.dart';

class RoadmapCompletionViewModel extends GetxController {
  late final LearningPlanResponseModel? plan;

  @override
  void onInit() {
    super.onInit();
    final Object? rawArgument = Get.arguments;
    plan = rawArgument is LearningPlanResponseModel ? rawArgument : null;
  }

  String get title => plan?.plan.title ?? 'Travel English A2 Roadmap';

  String get level => plan?.plan.level ?? 'A2';

  String get focusSkill => plan?.plan.focusSkill ?? 'CONFIDENCE';

  List<String> get completedScenes {
    final List<String> sceneTitles =
        plan?.steps
            .where((LearningPlanStepModel step) => step.scene != null)
            .map((LearningPlanStepModel step) => step.scene!.title)
            .take(4)
            .toList(growable: false) ??
        const <String>[];

    if (sceneTitles.isNotEmpty) return sceneTitles;
    return const <String>[
      'Airport Check-in',
      'Hotel Check-in',
      'Cafe small talk',
      'At the Pharmacy',
    ];
  }

  void startNextRoadmap() {
    Get.offAllNamed(Routes.home);
  }

  void backHome() {
    Get.offAllNamed(Routes.home);
  }
}
