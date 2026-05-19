import '../../core/auth/google_sign_in_service.dart';
import '../../core/storage/storage_service.dart';
import '../../core/network/api_response.dart';
import '../../domain/repositories/auth_repository.dart';
import '../models/auth_session_model.dart';
import '../providers/auth_provider.dart';

class AuthRepositoryImpl implements AuthRepository {
  AuthRepositoryImpl({
    required AuthProvider provider,
    required StorageService storageService,
    required GoogleSignInService googleSignInService,
  }) : _provider = provider,
       _storageService = storageService,
       _googleSignInService = googleSignInService;

  final AuthProvider _provider;
  final StorageService _storageService;
  final GoogleSignInService _googleSignInService;
  bool _needsAccountOnboarding = false;

  @override
  bool get needsAccountOnboarding => _needsAccountOnboarding;

  @override
  bool get isGoogleSignInAvailable =>
      _googleSignInService.isConfiguredForCurrentPlatform;

  @override
  String? get googleSignInUnavailableMessage =>
      isGoogleSignInAvailable ? null : _googleSignInService.unavailableMessage;

  @override
  bool get hasSession => _storageService.hasSession;

  @override
  Future<AuthSessionModel> login({
    required String email,
    required String password,
  }) async {
    final AuthSessionModel session = AuthSessionModel.fromMap(
      await _provider.login(email: email, password: password),
    );
    _needsAccountOnboarding = session.needsOnboarding;
    await _storageService.saveSession(
      accessToken: session.accessToken,
      refreshToken: session.refreshToken,
      displayName: session.user.effectiveDisplayName,
    );
    return session;
  }

  @override
  Future<AuthSessionModel> register({
    required String email,
    required String password,
    required String displayName,
  }) async {
    final AuthSessionModel session = AuthSessionModel.fromMap(
      await _provider.register(
        email: email,
        password: password,
        displayName: displayName,
      ),
    );
    _needsAccountOnboarding = session.needsOnboarding;
    await _storageService.saveSession(
      accessToken: session.accessToken,
      refreshToken: session.refreshToken,
      displayName: session.user.effectiveDisplayName,
    );
    return session;
  }

  @override
  Future<AuthSessionModel> loginWithGoogle() async {
    final String idToken = await _googleSignInService.signInAndGetIdToken();
    final AuthSessionModel session = AuthSessionModel.fromMap(
      await _provider.googleLogin(idToken: idToken),
    );
    _needsAccountOnboarding = session.needsOnboarding;
    await _storageService.saveSession(
      accessToken: session.accessToken,
      refreshToken: session.refreshToken,
      displayName: session.user.effectiveDisplayName,
    );
    return session;
  }

  @override
  Future<bool> ensureValidSession() async {
    if (!hasSession) {
      return false;
    }

    try {
      final Map<String, dynamic> verification = await _provider.verifyToken();
      final Map<String, dynamic> userMap =
          verification['user'] as Map<String, dynamic>? ?? <String, dynamic>{};
      _needsAccountOnboarding = userMap['needsOnboarding'] == true;
      return true;
    } on ApiException catch (error) {
      if (error.statusCode != 401) {
        return true;
      }

      final String? refreshToken = _storageService.refreshToken;
      if (refreshToken == null || refreshToken.isEmpty) {
        await clearSession();
        return false;
      }

      try {
        final Map<String, dynamic> refreshed = await _provider.refresh(
          refreshToken: refreshToken,
        );
        final String newAccessToken = refreshed['accessToken'] as String? ?? '';
        if (newAccessToken.isEmpty) {
          await clearSession();
          return false;
        }
        await _storageService.saveAccessToken(newAccessToken);
        return true;
      } catch (_) {
        await clearSession();
        return false;
      }
    } catch (_) {
      return true;
    }
  }

  @override
  Future<void> logout() async {
    final String? refreshToken = _storageService.refreshToken;
    try {
      if (refreshToken != null && refreshToken.isNotEmpty) {
        await _provider.logout(refreshToken: refreshToken);
      }
    } finally {
      await _googleSignInService.signOut();
      await clearSession();
    }
  }

  @override
  Future<void> clearSession() {
    _needsAccountOnboarding = false;
    return _storageService.clearSession();
  }
}
