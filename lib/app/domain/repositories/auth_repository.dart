import '../../data/models/auth_session_model.dart';

abstract class AuthRepository {
  bool get hasSession;
  bool get needsAccountOnboarding;
  bool get isGoogleSignInAvailable;
  String? get googleSignInUnavailableMessage;

  Future<AuthSessionModel> login({
    required String email,
    required String password,
  });

  Future<AuthSessionModel> register({
    required String email,
    required String password,
    required String displayName,
  });

  Future<AuthSessionModel> loginWithGoogle();

  Future<bool> ensureValidSession();

  Future<void> logout();

  Future<void> clearSession();
}
