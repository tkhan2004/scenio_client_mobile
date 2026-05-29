import '../../data/models/custom_practice_model.dart';
import '../../data/models/home_dashboard_model.dart';
import '../../data/models/learning_plan_model.dart';
import '../../data/models/realtime_token_model.dart';
import '../../data/models/session_flow_model.dart';
import '../entities/message_entity.dart';
import '../entities/scene_entity.dart';

abstract class LearningRepository {
  Future<HomeDashboardModel> fetchDashboard();

  Future<LearningPlanResponseModel> fetchCurrentLearningPlan();

  Future<LearningPlanResponseModel> refreshLearningPlan();

  Future<LearningPlanResponseModel> completeLearningPlanStep(String stepId);

  Future<RoadmapCompletionSummaryModel> fetchRoadmapCompletionSummary(
    String planId,
  );

  Future<StartNextRoadmapModel> startNextRoadmap(String planId);

  Future<List<SceneEntity>> fetchScenes({
    SceneCategory? category,
    SceneDifficulty? difficulty,
  });

  Future<SceneEntity> fetchSceneDetail(String sceneId);

  Future<SessionStartModel> startSession({
    required String sceneId,
    String modality = 'TEXT',
    String? voiceProfileId,
  });

  Future<RealtimeTokenModel> createRealtimeToken(String sessionId);

  Future<CustomPracticeStartModel> startCustomSession(
    CustomPracticeDraft draft,
  );

  Future<void> syncMessage({
    required String sessionId,
    required String source,
    required String content,
    int? turnIndex,
    String? providerEventId,
    int? audioStartMs,
    int? audioEndMs,
  });

  Future<SessionResultModel> completeSession(String sessionId);

  Future<SessionResultModel> fetchSessionResult(String sessionId);

  Future<void> abandonSession(String sessionId);

  Future<MessageEntity> requestHint(String sessionId);
}
