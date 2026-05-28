import 'dart:async';

import 'package:get/get.dart';

import '../../core/constants/app_strings.dart';
import '../../core/network/api_response.dart';
import '../../core/utils/scenio_alerts.dart';
import '../../data/models/learning_plan_model.dart';
import '../../domain/entities/scene_entity.dart';
import '../../domain/repositories/learning_repository.dart';
import '../../routes/app_routes.dart';
import '../home/home_viewmodel.dart';

class LearningPlanViewModel extends GetxController {
  LearningPlanViewModel({required LearningRepository repository})
    : _repository = repository;

  final LearningRepository _repository;

  final Rxn<LearningPlanResponseModel> plan = Rxn<LearningPlanResponseModel>();
  final RxBool isLoading = false.obs;
  final RxBool isRefreshing = false.obs;
  final RxString completingStepId = ''.obs;
  bool _completionNavigationScheduled = false;

  LearningPlanResponseModel? get currentPlan => plan.value;
  bool get hasPlan => plan.value != null;

  @override
  void onInit() {
    super.onInit();
    final Object? args = Get.arguments;
    if (args is LearningPlanResponseModel) {
      plan.value = args;
    } else if (Get.isRegistered<HomeViewModel>()) {
      plan.value = Get.find<HomeViewModel>().currentLearningPlan;
    }

    unawaited(load());
  }

  Future<void> load() async {
    if (isLoading.value) return;

    isLoading.value = true;
    try {
      _setPlan(await _repository.fetchCurrentLearningPlan());
    } on ApiException catch (error) {
      if (error.statusCode == 409) {
        plan.value = null;
        _showError(
          'Roadmap chưa sẵn sàng. Hãy hoàn tất onboarding để Scenio tạo lộ trình học phù hợp.'
              .tr,
        );
        return;
      }
      _showError(error.message);
    } catch (_) {
      _showError('Không thể tải lộ trình học lúc này.');
    } finally {
      isLoading.value = false;
    }
  }

  void refreshPlan() {
    unawaited(_refreshPlan());
  }

  Future<void> _refreshPlan() async {
    if (isRefreshing.value) return;

    isRefreshing.value = true;
    try {
      _setPlan(await _repository.refreshLearningPlan());
      ScenioAlert.show(
        title: AppStrings.appName,
        message: 'Đã làm mới lộ trình học của bạn.',
        isSuccess: true,
      );
    } on ApiException catch (error) {
      _showError(error.message);
    } catch (_) {
      _showError('Không thể làm mới lộ trình lúc này.');
    } finally {
      isRefreshing.value = false;
    }
  }

  void openNextStep() {
    final LearningPlanResponseModel? value = plan.value;
    final LearningPlanNextStepModel? nextStep = value?.nextStep;
    if (value == null || nextStep == null) return;

    final LearningPlanStepModel? step = _findStep(nextStep.id);
    if (step != null) {
      openStep(step);
      return;
    }

    final String? sceneId = nextStep.sceneId;
    if (sceneId == null || sceneId.isEmpty) return;
    unawaited(_openSceneById(sceneId));
  }

  void openStep(LearningPlanStepModel step) {
    final SceneEntity? scene = step.scene;
    if (scene != null) {
      Get.toNamed(Routes.sceneDetail, arguments: scene);
      return;
    }

    final String? sceneId = step.sceneId;
    if (sceneId != null && sceneId.isNotEmpty) {
      unawaited(_openSceneById(sceneId));
      return;
    }

    switch (step.type) {
      case 'VOCABULARY_REVIEW':
        _openHomeTab(3);
        return;
      case 'CUSTOM_PRACTICE':
      case 'GRAMMAR_PRACTICE':
        Get.toNamed(Routes.customPractice);
        return;
      case 'RETRY_SCENE':
      case 'SCENE':
      default:
        _showError('Bước này chưa có ngữ cảnh để mở.');
    }
  }

  void completeStep(LearningPlanStepModel step) {
    if (step.status == 'COMPLETED' || completingStepId.value.isNotEmpty) {
      return;
    }

    unawaited(_completeStep(step));
  }

  Future<void> _completeStep(LearningPlanStepModel step) async {
    completingStepId.value = step.id;
    try {
      _setPlan(await _repository.completeLearningPlanStep(step.id));
      ScenioAlert.show(
        title: AppStrings.appName,
        message: 'Đã cập nhật tiến độ lộ trình.',
        isSuccess: true,
      );
    } on ApiException catch (error) {
      _showError(error.message);
    } catch (_) {
      _showError('Không thể cập nhật bước học lúc này.');
    } finally {
      completingStepId.value = '';
    }
  }

  Future<void> _openSceneById(String sceneId) async {
    try {
      final SceneEntity scene = await _repository.fetchSceneDetail(sceneId);
      await Get.toNamed(Routes.sceneDetail, arguments: scene);
    } catch (_) {
      _showError('Không thể mở ngữ cảnh của bước học này.');
    }
  }

  void _openHomeTab(int index) {
    Get.offAllNamed(Routes.home);
    Future<void>.delayed(Duration.zero, () {
      if (!Get.isRegistered<HomeViewModel>()) return;
      Get.find<HomeViewModel>().selectTab(index);
    });
  }

  LearningPlanStepModel? _findStep(String stepId) {
    final List<LearningPlanStepModel> steps = plan.value?.steps ?? const [];
    for (final LearningPlanStepModel step in steps) {
      if (step.id == stepId) return step;
    }
    return null;
  }

  void _setPlan(LearningPlanResponseModel value) {
    plan.value = value;
    if (Get.isRegistered<HomeViewModel>()) {
      Get.find<HomeViewModel>().learningPlan.value = value;
    }
    _openCompletionIfReady(value);
  }

  void _openCompletionIfReady(LearningPlanResponseModel value) {
    if (_completionNavigationScheduled) return;
    if (value.completionSummary == null && !value.plan.isCompleted) return;

    _completionNavigationScheduled = true;
    Future<void>.delayed(Duration.zero, () {
      if (Get.currentRoute == Routes.roadmapCompletion) return;
      Get.toNamed(Routes.roadmapCompletion, arguments: value);
    });
  }

  void _showError(String message) {
    ScenioAlert.show(
      title: AppStrings.appName,
      message: message,
      isError: true,
    );
  }
}
