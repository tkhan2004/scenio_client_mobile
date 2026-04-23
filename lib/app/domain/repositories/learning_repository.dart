import '../../data/models/custom_practice_model.dart';
import '../../data/models/home_dashboard_model.dart';
import '../../data/models/session_flow_model.dart';
import '../entities/message_entity.dart';
import '../entities/scene_entity.dart';

abstract class LearningRepository {
  Future<HomeDashboardModel> fetchDashboard();

  Future<List<SceneEntity>> fetchScenes({
    SceneCategory? category,
    SceneDifficulty? difficulty,
  });

  Future<SceneEntity> fetchSceneDetail(String sceneId);

  Future<SessionStartModel> startSession({required String sceneId});

  Future<CustomPracticeStartModel> startCustomSession(
    CustomPracticeDraft draft,
  );

  Future<void> syncMessage({
    required String sessionId,
    required String source,
    required String content,
    required int turnIndex,
  });

  Future<void> completeSession(String sessionId);

  Future<SessionResultModel> fetchSessionResult(String sessionId);

  Future<void> abandonSession(String sessionId);

  Future<MessageEntity> requestHint(String sessionId);
}
