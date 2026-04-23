import '../../data/models/auth_session_model.dart';

abstract class AuthRepository {
  bool get hasSession;

  Future<AuthSessionModel> login({
    required String email,
    required String password,
  });

  Future<AuthSessionModel> register({
    required String email,
    required String password,
    required String displayName,
  });

  Future<bool> ensureValidSession();

  Future<void> logout();

  Future<void> clearSession();
}
