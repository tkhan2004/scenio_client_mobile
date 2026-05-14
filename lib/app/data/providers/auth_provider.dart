import '../../core/network/api_client.dart';
import '../../core/network/api_endpoints.dart';

class AuthProvider {
  AuthProvider({required ApiClient apiClient}) : _apiClient = apiClient;

  final ApiClient _apiClient;

  Future<Map<String, dynamic>> login({
    required String email,
    required String password,
  }) {
    return _apiClient.post(
      ApiEndpoints.authLogin,
      data: <String, dynamic>{'email': email, 'password': password},
    );
  }

  Future<Map<String, dynamic>> register({
    required String email,
    required String password,
    required String displayName,
  }) {
    return _apiClient.post(
      ApiEndpoints.authRegister,
      data: <String, dynamic>{
        'email': email,
        'password': password,
        'displayName': displayName,
      },
    );
  }

  Future<Map<String, dynamic>> googleLogin({required String idToken}) {
    return _apiClient.post(
      ApiEndpoints.authGoogle,
      data: <String, dynamic>{'idToken': idToken},
    );
  }

  Future<Map<String, dynamic>> refresh({
    required String refreshToken,
  }) {
    return _apiClient.post(
      ApiEndpoints.authRefresh,
      data: <String, dynamic>{'refreshToken': refreshToken},
    );
  }

  Future<Map<String, dynamic>> verifyToken() {
    return _apiClient.get(ApiEndpoints.authVerifyToken);
  }

  Future<void> logout({
    required String refreshToken,
  }) async {
    await _apiClient.post(
      ApiEndpoints.authLogout,
      data: <String, dynamic>{'refreshToken': refreshToken},
    );
  }
}
