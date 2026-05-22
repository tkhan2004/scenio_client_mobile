import '../../core/network/api_client.dart';
import '../../core/network/api_endpoints.dart';

class UserProvider {
  UserProvider({required ApiClient apiClient}) : _apiClient = apiClient;

  final ApiClient _apiClient;

  Future<Map<String, dynamic>> getMe() {
    return _apiClient.get(ApiEndpoints.usersMe);
  }

  Future<Map<String, dynamic>> updateMe({
    String? displayName,
    String? avatarUrl,
  }) {
    final Map<String, dynamic> data = <String, dynamic>{
      'displayName': displayName,
      'avatarUrl': avatarUrl,
    }..removeWhere((String _, dynamic value) => value == null);

    return _apiClient.patch(ApiEndpoints.usersMe, data: data);
  }

  Future<void> completeOnboarding({
    String? level,
    String? learningGoal,
    String? studyFrequency,
    String? selfAssessment,
  }) async {
    final Map<String, dynamic> data = <String, dynamic>{
      'level': level,
      'learningGoal': learningGoal,
      'studyFrequency': studyFrequency,
      'selfAssessment': selfAssessment,
    }..removeWhere((String _, dynamic value) => value == null);

    await _apiClient.patch(ApiEndpoints.usersOnboarding, data: data);
  }

  Future<Map<String, dynamic>> getProgress() {
    return _apiClient.get(ApiEndpoints.usersProgress);
  }

  Future<Map<String, dynamic>> getBadges() {
    return _apiClient.get(ApiEndpoints.usersBadges);
  }
}
