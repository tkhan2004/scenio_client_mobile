import '../../core/network/api_client.dart';
import '../../core/network/api_endpoints.dart';
import '../models/custom_practice_model.dart';

class LearningProvider {
  LearningProvider({required ApiClient apiClient}) : _apiClient = apiClient;

  final ApiClient _apiClient;

  Future<Map<String, dynamic>> fetchDashboard() {
    return _apiClient.get(ApiEndpoints.homeDashboard);
  }

  Future<Map<String, dynamic>> fetchCurrentLearningPlan() {
    return _apiClient.get(ApiEndpoints.learningPlanCurrent);
  }

  Future<Map<String, dynamic>> refreshLearningPlan() {
    return _apiClient.post(
      ApiEndpoints.learningPlanRefresh,
      data: <String, dynamic>{},
    );
  }

  Future<Map<String, dynamic>> completeLearningPlanStep(String stepId) {
    return _apiClient.patch(ApiEndpoints.learningPlanStepComplete(stepId));
  }

  Future<Map<String, dynamic>> fetchScenes({
    String? category,
    String? difficulty,
  }) {
    return _apiClient.get(
      ApiEndpoints.scenes,
      queryParameters: <String, dynamic>{
        'page': 1,
        'limit': 20,
        'category': category,
        'difficulty': difficulty,
      },
    );
  }

  Future<Map<String, dynamic>> fetchSceneDetail(String sceneId) {
    return _apiClient.get(ApiEndpoints.sceneDetail(sceneId));
  }

  Future<Map<String, dynamic>> startSession({
    required String sceneId,
    String modality = 'TEXT',
    String? voiceProfileId,
  }) {
    final Map<String, dynamic> data = <String, dynamic>{
      'sceneId': sceneId,
      'modality': modality,
    };
    if (voiceProfileId != null) {
      data['voiceProfileId'] = voiceProfileId;
    }

    return _apiClient.post(ApiEndpoints.startSession, data: data);
  }

  Future<Map<String, dynamic>> createRealtimeToken(String sessionId) {
    return _apiClient.post(
      ApiEndpoints.sessionRealtimeToken(sessionId),
      data: <String, dynamic>{},
    );
  }

  Future<Map<String, dynamic>> startCustomSession(CustomPracticeDraft draft) {
    return _apiClient.post(
      ApiEndpoints.startCustomSession,
      data: draft.toRequestMap(),
    );
  }

  Future<Map<String, dynamic>> syncMessage({
    required String sessionId,
    required String source,
    required String content,
    int? turnIndex,
    String? providerEventId,
    int? audioStartMs,
    int? audioEndMs,
  }) {
    final Map<String, dynamic> data = <String, dynamic>{
      'source': source,
      'content': content,
      'isFinal': true,
    };
    if (turnIndex != null) {
      data['turnIndex'] = turnIndex;
    }
    if (providerEventId != null) {
      data['providerEventId'] = providerEventId;
    }
    if (audioStartMs != null) {
      data['audioStartMs'] = audioStartMs;
    }
    if (audioEndMs != null) {
      data['audioEndMs'] = audioEndMs;
    }

    return _apiClient.post(ApiEndpoints.sessionMessage(sessionId), data: data);
  }

  Future<Map<String, dynamic>> completeSession(String sessionId) {
    return _apiClient.post(
      ApiEndpoints.sessionComplete(sessionId),
      data: <String, dynamic>{},
    );
  }

  Future<Map<String, dynamic>> fetchSessionResult(String sessionId) {
    return _apiClient.get(ApiEndpoints.sessionResult(sessionId));
  }

  Future<Map<String, dynamic>> abandonSession(String sessionId) {
    return _apiClient.patch(ApiEndpoints.sessionAbandon(sessionId));
  }

  Future<Map<String, dynamic>> requestHint(String sessionId) {
    return _apiClient.post(
      ApiEndpoints.sessionHint(sessionId),
      data: <String, dynamic>{},
    );
  }
}
