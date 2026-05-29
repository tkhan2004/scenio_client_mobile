import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

import '../../core/constants/app_strings.dart';
import '../../data/models/custom_practice_model.dart';
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

    _startRecommendedCustomPractice(action);
  }

  Future<void> _startRecommendedCustomPractice(
    SessionNextLearningActionEntity action,
  ) async {
    final CustomPracticeDraft draft = _buildFollowUpCustomDraft(action);
    final bool started = await homeViewModel.startCustomPracticeSession(draft);
    if (!started || homeViewModel.currentSession == null) {
      _fallbackToSceneSearch(action);
      return;
    }

    Get.offNamed(
      Routes.practiceSession,
      arguments: homeViewModel.currentSession!.id,
    );
  }

  void _fallbackToSceneSearch(SessionNextLearningActionEntity action) {
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

  CustomPracticeDraft _buildFollowUpCustomDraft(
    SessionNextLearningActionEntity action,
  ) {
    final String focus = action.focus.toUpperCase();
    final String sourceTitle = result.sceneTitle.trim().isEmpty
        ? 'the previous conversation'
        : result.sceneTitle.trim();
    final String suggestedTopic = action.suggestedSceneQuery.trim().isEmpty
        ? '$sourceTitle follow-up conversation'
        : action.suggestedSceneQuery.trim();

    return CustomPracticeDraft(
      practiceGoal: _followUpGoal(focus, sourceTitle),
      successOutcome: _followUpOutcome(focus),
      topicSummary:
          'A follow-up conversation similar to "$sourceTitle", focused on $suggestedTopic.',
      contextType: _contextTypeFromTitle(sourceTitle),
      location: '',
      conversationChannel: 'VIDEO_CALL',
      userRole: 'English learner continuing a previous practice topic',
      userIntent:
          'Practice the same topic again with better structure, clearer wording, and more natural replies.',
      aiRole: '${result.characterName} follow-up coach',
      aiDisplayName: result.characterName.trim().isEmpty
          ? 'Coach'
          : result.characterName,
      aiBehaviorStyle:
          'Supportive, realistic, and focused on asking follow-up questions that force clearer answers.',
      aiPrimaryGoal:
          'Run a similar conversation and push the learner to improve ${_focusLabel(focus)}.',
      aiGenderPresentation: 'NEUTRAL',
      aiVoiceTone: 'FRIENDLY',
      aiAccentPreference: '',
      difficulty: _recommendedDifficulty,
      conversationLength: result.targetTurns >= 5 ? 'LONG' : 'MEDIUM',
      targetMinutes: result.targetTurns >= 5 ? 18 : 12,
      customInstructions:
          'Start with a new opening question, not the exact same opening. Keep the topic similar, but change the situation slightly. Prioritize ${_focusLabel(focus)}. At the end, give concise feedback with one corrected sentence and one next action.',
      specialConditions: <String>[
        'similar topic, new angle',
        'follow-up after previous session',
        '${_focusLabel(focus)} focus',
      ],
    );
  }

  String get _recommendedDifficulty {
    if (averageScore >= 78) return 'B1';
    if (averageScore <= 55) return 'A2';
    return 'A2';
  }

  String _followUpGoal(String focus, String sourceTitle) {
    switch (focus) {
      case 'GRAMMAR':
        return 'Repeat a similar "$sourceTitle" conversation and answer with cleaner sentence structure.';
      case 'VOCABULARY':
        return 'Repeat a similar "$sourceTitle" conversation and use more specific words and phrases.';
      case 'NATURALNESS':
      default:
        return 'Repeat a similar "$sourceTitle" conversation and make the replies sound more natural.';
    }
  }

  String _followUpOutcome(String focus) {
    switch (focus) {
      case 'GRAMMAR':
        return 'Finish the session with at least three complete answers using clear tense and structure.';
      case 'VOCABULARY':
        return 'Use at least three concrete topic-specific phrases without repeating vague wording.';
      case 'NATURALNESS':
      default:
        return 'Answer the main questions naturally without translating word by word from Vietnamese.';
    }
  }

  String _focusLabel(String focus) {
    switch (focus) {
      case 'GRAMMAR':
        return 'grammar and sentence structure';
      case 'VOCABULARY':
        return 'specific vocabulary';
      case 'NATURALNESS':
      default:
        return 'natural English phrasing';
    }
  }

  String _contextTypeFromTitle(String title) {
    final String lower = title.toLowerCase();
    if (lower.contains('interview') || lower.contains('hr')) {
      return 'INTERVIEW';
    }
    if (lower.contains('travel') ||
        lower.contains('airport') ||
        lower.contains('hotel')) {
      return 'TRAVEL';
    }
    if (lower.contains('call') || lower.contains('phone')) {
      return 'PHONE_CALL';
    }
    if (lower.contains('work') ||
        lower.contains('meeting') ||
        lower.contains('project')) {
      return 'WORK';
    }
    return 'OTHER';
  }
}
