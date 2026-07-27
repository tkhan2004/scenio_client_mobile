import '../models/custom_practice_model.dart';
import '../../domain/entities/message_entity.dart';
import '../../domain/entities/scene_entity.dart';
import '../../domain/repositories/learning_repository.dart';
import '../models/home_dashboard_model.dart';
import '../models/learning_plan_model.dart';
import '../models/realtime_token_model.dart';
import '../models/scene_api_model.dart';
import '../models/session_flow_model.dart';
import '../providers/learning_provider.dart';

class LearningRepositoryImpl implements LearningRepository {
  LearningRepositoryImpl({required LearningProvider provider})
    : _provider = provider;

  final LearningProvider _provider;

  @override
  Future<HomeDashboardModel> fetchDashboard() async {
    return HomeDashboardModel.fromMap(await _provider.fetchDashboard());
  }

  @override
  Future<LearningPlanResponseModel> fetchCurrentLearningPlan() async {
    return LearningPlanResponseModel.fromMap(
      await _provider.fetchCurrentLearningPlan(),
    );
  }

  @override
  Future<LearningPlanResponseModel> refreshLearningPlan() async {
    return LearningPlanResponseModel.fromMap(
      await _provider.refreshLearningPlan(),
    );
  }

  @override
  Future<LearningPlanResponseModel> completeLearningPlanStep(
    String stepId,
  ) async {
    return LearningPlanResponseModel.fromMap(
      await _provider.completeLearningPlanStep(stepId),
    );
  }

  @override
  Future<RoadmapCompletionSummaryModel> fetchRoadmapCompletionSummary(
    String planId,
  ) async {
    final Map<String, dynamic> map = await _provider
        .fetchRoadmapCompletionSummary(planId);
    final Object? completionSummary = map['completionSummary'];
    return RoadmapCompletionSummaryModel.fromMap(
      completionSummary is Map<String, dynamic> ? completionSummary : map,
    );
  }

  @override
  Future<StartNextRoadmapModel> startNextRoadmap(String planId) async {
    return StartNextRoadmapModel.fromMap(
      await _provider.startNextRoadmap(planId),
    );
  }

  @override
  Future<List<SceneEntity>> fetchScenes({
    SceneCategory? category,
    SceneDifficulty? difficulty,
  }) async {
    final Map<String, dynamic> map = await _provider.fetchScenes(
      category: category != null ? _mapCategoryQuery(category) : null,
      difficulty: difficulty?.label,
    );
    final List<dynamic> rawScenes =
        map['scenes'] as List<dynamic>? ?? <dynamic>[];
    return rawScenes
        .whereType<Map<String, dynamic>>()
        .map(
          (Map<String, dynamic> item) => SceneApiModel.fromMap(item).toEntity(),
        )
        .toList();
  }

  @override
  Future<SceneEntity> fetchSceneDetail(String sceneId) async {
    final Map<String, dynamic> map = await _provider.fetchSceneDetail(sceneId);
    return SceneApiModel.fromMap(
      map['scene'] as Map<String, dynamic>? ?? <String, dynamic>{},
    ).toEntity();
  }

  @override
  Future<SessionStartModel> startSession({
    required String sceneId,
    String modality = 'TEXT',
    String? voiceProfileId,
  }) async {
    return SessionStartModel.fromMap(
      await _provider.startSession(
        sceneId: sceneId,
        modality: modality,
        voiceProfileId: voiceProfileId,
      ),
    );
  }

  @override
  Future<RealtimeTokenModel> createRealtimeToken(String sessionId) async {
    return RealtimeTokenModel.fromMap(
      await _provider.createRealtimeToken(sessionId),
    );
  }

  @override
  Future<CustomPracticeStartModel> startCustomSession(
    CustomPracticeDraft draft,
  ) async {
    return CustomPracticeStartModel.fromMap(
      await _provider.startCustomSession(draft),
    );
  }

  @override
  Future<List<SavedCustomPracticeModel>> fetchRecentCustomPractices({
    int limit = 10,
  }) async {
    final Map<String, dynamic> map = await _provider.fetchRecentCustomPractices(
      limit: limit,
    );
    return (map['items'] as List<dynamic>? ?? const <dynamic>[])
        .whereType<Map<String, dynamic>>()
        .map(SavedCustomPracticeModel.fromMap)
        .toList(growable: false);
  }

  @override
  Future<MessageEntity?> syncMessage({
    required String sessionId,
    required String source,
    required String content,
    int? turnIndex,
    bool generateAiReply = false,
    String? providerEventId,
    int? audioStartMs,
    int? audioEndMs,
  }) async {
    final Map<String, dynamic> map = await _provider.syncMessage(
      sessionId: sessionId,
      source: source,
      content: content,
      turnIndex: turnIndex,
      generateAiReply: generateAiReply,
      providerEventId: providerEventId,
      audioStartMs: audioStartMs,
      audioEndMs: audioEndMs,
    );

    final Map<String, dynamic>? messageMap =
        map['aiReply'] as Map<String, dynamic>?;
    if (messageMap == null) {
      return null;
    }

    final Map<String, dynamic> feedbackDetails =
        messageMap['feedbackDetails'] as Map<String, dynamic>? ??
        <String, dynamic>{};

    return MessageEntity(
      id: messageMap['id'] as String? ?? '',
      sessionId: sessionId,
      author: _mapRepositoryMessageAuthor(
        messageMap['role'] as String? ?? 'AI',
      ),
      text: messageMap['content'] as String? ?? '',
      createdAt:
          DateTime.tryParse(messageMap['createdAt'] as String? ?? '') ??
          DateTime.now(),
      isHint: messageMap['isHint'] as bool? ?? false,
      hasError: messageMap['hasError'] as bool?,
      errorType: messageMap['errorType'] as String?,
      originalPhrase: messageMap['originalPhrase'] as String?,
      suggestion: messageMap['suggestion'] as String?,
      explanation: messageMap['explanation'] as String?,
      isGood: messageMap['isGood'] as bool?,
      feedbackIssues:
          (feedbackDetails['issues'] as List<dynamic>? ?? const <dynamic>[])
              .whereType<Map<String, dynamic>>()
              .map<MessageFeedbackIssueModel>(MessageFeedbackIssueModel.fromMap)
              .map((MessageFeedbackIssueModel issue) => issue.toEntity())
              .toList(growable: false),
    );
  }

  @override
  Future<SessionResultModel> completeSession(String sessionId) async {
    return SessionResultModel.fromMap(
      await _provider.completeSession(sessionId),
      fallbackSceneId: '',
      fallbackTargetTurns: 3,
    );
  }

  @override
  Future<SessionResultModel> fetchSessionResult(String sessionId) async {
    return SessionResultModel.fromMap(
      await _provider.fetchSessionResult(sessionId),
      fallbackSceneId: '',
      fallbackTargetTurns: 3,
    );
  }

  @override
  Future<void> abandonSession(String sessionId) async {
    await _provider.abandonSession(sessionId);
  }

  @override
  Future<MessageEntity> requestHint(String sessionId) async {
    final Map<String, dynamic> map = await _provider.requestHint(sessionId);
    final Map<String, dynamic> messageMap =
        map['message'] as Map<String, dynamic>? ?? <String, dynamic>{};

    return MessageEntity(
      id: messageMap['id'] as String? ?? '',
      sessionId: sessionId,
      author: MessageAuthor.ai,
      text: messageMap['content'] as String? ?? '',
      createdAt:
          DateTime.tryParse(messageMap['createdAt'] as String? ?? '') ??
          DateTime.now(),
      isHint: messageMap['isHint'] as bool? ?? true,
    );
  }
}

String _mapCategoryQuery(SceneCategory category) {
  switch (category) {
    case SceneCategory.travel:
      return 'TRAVEL';
    case SceneCategory.work:
      return 'WORK';
    case SceneCategory.social:
      return 'SOCIAL';
    case SceneCategory.service:
      return 'SOCIAL';
    case SceneCategory.dailyLife:
      return 'DAILY';
  }
}

MessageAuthor _mapRepositoryMessageAuthor(String raw) {
  switch (raw.toUpperCase()) {
    case 'USER':
      return MessageAuthor.user;
    case 'SYSTEM':
      return MessageAuthor.system;
    case 'AI':
    default:
      return MessageAuthor.ai;
  }
}
