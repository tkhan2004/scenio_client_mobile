import '../../core/network/api_client.dart';
import '../../core/network/api_endpoints.dart';

class UserProvider {
  UserProvider({required ApiClient apiClient}) : _apiClient = apiClient;

  final ApiClient _apiClient;

  Future<void> completeOnboarding({
    String? learningGoal,
    String? studyFrequency,
    String? selfAssessment,
  }) async {
    final Map<String, dynamic> data = <String, dynamic>{
      'learningGoal': learningGoal,
      'studyFrequency': studyFrequency,
      'selfAssessment': selfAssessment,
    }..removeWhere((String _, dynamic value) => value == null);

    await _apiClient.patch(
      ApiEndpoints.usersOnboarding,
      data: data,
    );
  }
}
