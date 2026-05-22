import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

import '../../core/constants/app_strings.dart';
import '../../domain/entities/session_entity.dart';
import '../../routes/app_routes.dart';
import '../home/home_viewmodel.dart';

class SessionResultViewModel extends GetxController {
  late final SessionResultEntity result;
  final HomeViewModel homeViewModel = Get.find<HomeViewModel>();

  @override
  void onInit() {
    super.onInit();
    final Object? rawArgument = Get.arguments;
    result = rawArgument is SessionResultEntity
        ? rawArgument
        : homeViewModel.lastCompletedResult.value!;
  }

  bool get hasSpokenCoaching => result.spokenCoaching?.available ?? false;
  bool get hasNextLearningAction => result.nextLearningAction != null;

  int get averageScore {
    return ((result.grammarScore +
                result.vocabularyScore +
                result.naturalnessScore) /
            3)
        .round();
  }

  String get missionOutcomeLabel {
    if (averageScore >= 72 && result.completedTurns >= result.targetTurns) {
      return 'Achieved';
    }
    if (averageScore >= 56 || result.completedTurns >= result.targetTurns) {
      return 'Partially achieved';
    }
    return 'Needs retry';
  }

  String get missionOutcomeDescription {
    if (missionOutcomeLabel == 'Achieved') {
      return 'You stayed in the scene, completed the guided turns, and handled the conversation goal clearly enough for this level.';
    }
    if (missionOutcomeLabel == 'Partially achieved') {
      return 'You kept the conversation moving, but the next session should make your replies longer, cleaner, or more specific.';
    }
    return 'The scene goal still needs another attempt. Retry a similar scene and focus on one complete answer at a time.';
  }

  String get nextStepTitle {
    switch (result.nextLearningAction?.focus.toUpperCase()) {
      case 'GRAMMAR':
        return AppStrings.sessionResultNextStepGrammarTitle;
      case 'VOCABULARY':
        return AppStrings.sessionResultNextStepVocabularyTitle;
      case 'NATURALNESS':
      default:
        return AppStrings.sessionResultNextStepNaturalnessTitle;
    }
  }

  String get nextStepDescription {
    final SessionNextLearningActionEntity? action = result.nextLearningAction;
    if (action == null) return '';

    switch (action.focus.toUpperCase()) {
      case 'GRAMMAR':
        return AppStrings.sessionResultNextStepGrammarBody;
      case 'VOCABULARY':
        return AppStrings.sessionResultNextStepVocabularyBody;
      case 'NATURALNESS':
      default:
        return AppStrings.sessionResultNextStepNaturalnessBody;
    }
  }

  String get nextStepButtonLabel {
    switch (result.nextLearningAction?.focus.toUpperCase()) {
      case 'GRAMMAR':
        return AppStrings.sessionResultNextStepGrammarButton;
      case 'VOCABULARY':
        return AppStrings.sessionResultNextStepVocabularyButton;
      case 'NATURALNESS':
      default:
        return AppStrings.sessionResultNextStepNaturalnessButton;
    }
  }

  void openSceneAgain() {
    final scene = homeViewModel.sceneById(result.sceneId);
    Get.offAllNamed(Routes.home);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final HomeViewModel nextVm = Get.find<HomeViewModel>();
      nextVm.selectTab(1);
      nextVm.openSceneDetails(scene);
    });
  }

  void openRecommendedPractice() {
    final SessionNextLearningActionEntity? action = result.nextLearningAction;
    if (action == null) {
      openSceneAgain();
      return;
    }

    if (action.suggestedSceneQuery.trim().isEmpty) {
      openSceneAgain();
      return;
    }

    Get.offAllNamed(Routes.home);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final HomeViewModel nextVm = Get.find<HomeViewModel>();
      nextVm.selectTab(1);
      nextVm.selectSceneCategory(null);
      nextVm.selectSceneDifficulty(null);
      nextVm.updateSceneSearch(action.suggestedSceneQuery);
    });
  }
}
