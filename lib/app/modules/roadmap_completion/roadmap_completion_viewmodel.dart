import 'package:get/get.dart';

import '../../core/constants/app_strings.dart';
import '../../core/network/api_response.dart';
import '../../core/utils/scenio_alerts.dart';
import '../../data/models/learning_plan_model.dart';
import '../../domain/repositories/learning_repository.dart';
import '../../routes/app_routes.dart';
import '../home/home_viewmodel.dart';

class RoadmapCompletionViewModel extends GetxController {
  RoadmapCompletionViewModel({required LearningRepository repository})
    : _repository = repository;

  final LearningRepository _repository;

  final Rxn<LearningPlanResponseModel> plan = Rxn<LearningPlanResponseModel>();
  final Rxn<RoadmapCompletionSummaryModel> summary =
      Rxn<RoadmapCompletionSummaryModel>();
  final RxBool isLoading = false.obs;
  final RxBool isStartingNext = false.obs;

  String _planId = '';

  @override
  void onInit() {
    super.onInit();
    final Object? rawArgument = Get.arguments;
    if (rawArgument is LearningPlanResponseModel) {
      plan.value = rawArgument;
      summary.value = rawArgument.completionSummary;
      _planId = rawArgument.plan.id;
    } else if (rawArgument is RoadmapCompletionSummaryModel) {
      summary.value = rawArgument;
      _planId = rawArgument.planId;
    } else if (rawArgument is String) {
      _planId = rawArgument;
    }

    if (summary.value == null && _planId.isNotEmpty) {
      loadSummary();
    }
  }

  String get title =>
      summary.value?.title ??
      plan.value?.plan.title ??
      'Travel English A2 Roadmap';

  String get level => summary.value?.level ?? plan.value?.plan.level ?? 'A2';

  String get focusSkill =>
      summary.value?.nextRoadmap?.focusSkill ??
      plan.value?.plan.focusSkill ??
      'CONFIDENCE';

  int get xpBonus =>
      summary.value?.reward.xpBonus ?? plan.value?.plan.reward.xpBonus ?? 120;

  String get badgeTitle {
    final String? value =
        summary.value?.reward.badgeTitle ?? plan.value?.plan.reward.badgeTitle;
    if (value != null && value.trim().isNotEmpty) return value;
    return 'Completion badge'.tr;
  }

  String get nextRoadmapTitle =>
      summary.value?.nextRoadmap?.title ?? 'Travel Vocabulary Expansion';

  RoadmapScoreDeltaModel get scoreDelta =>
      summary.value?.scoreDelta ??
      const RoadmapScoreDeltaModel(
        grammar: RoadmapSkillDeltaModel(before: 62, after: 74),
        vocabulary: RoadmapSkillDeltaModel(before: 66, after: 73),
        naturalness: RoadmapSkillDeltaModel(before: 58, after: 71),
      );

  List<String> get completedScenes {
    final List<String> summaryScenes =
        summary.value?.completedScenes ?? const [];
    if (summaryScenes.isNotEmpty) return summaryScenes;

    final List<String> sceneTitles =
        plan.value?.steps
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

  Future<void> loadSummary() async {
    if (isLoading.value) return;
    isLoading.value = true;
    try {
      summary.value = await _repository.fetchRoadmapCompletionSummary(_planId);
    } on ApiException catch (error) {
      ScenioAlert.show(
        title: AppStrings.appName,
        message: error.message,
        isError: true,
      );
    } finally {
      isLoading.value = false;
    }
  }

  void startNextRoadmap() {
    if (_planId.isEmpty || isStartingNext.value) return;
    _startNextRoadmap();
  }

  Future<void> _startNextRoadmap() async {
    isStartingNext.value = true;
    try {
      final StartNextRoadmapModel result = await _repository.startNextRoadmap(
        _planId,
      );
      final LearningPlanResponseModel? nextPlan = result.nextPlan;
      if (nextPlan != null && Get.isRegistered<HomeViewModel>()) {
        Get.find<HomeViewModel>().learningPlan.value = nextPlan;
      }
      Get.offAllNamed(Routes.learningPlan, arguments: nextPlan);
    } on ApiException catch (error) {
      ScenioAlert.show(
        title: AppStrings.appName,
        message: error.message,
        isError: true,
      );
    } finally {
      isStartingNext.value = false;
    }
  }

  void backHome() {
    Get.offAllNamed(Routes.home);
  }
}
