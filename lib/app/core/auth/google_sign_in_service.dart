import 'package:flutter/foundation.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../config/app_env.dart';
import '../network/api_response.dart';

class GoogleSignInService {
  GoogleSignInService() : _googleSignIn = GoogleSignIn.instance;

  final GoogleSignIn _googleSignIn;

  bool _isInitialized = false;

  bool get isConfiguredForCurrentPlatform =>
      kIsWeb || _serverClientId != null;

  String get unavailableMessage =>
      'Google Sign-In chưa sẵn sàng trên build này. Hãy điền SCENIO_GOOGLE_CLIENT_ID và SCENIO_GOOGLE_SERVER_CLIENT_ID trong .env, đồng thời cấu hình iOS GoogleSignIn.xcconfig rồi chạy lại app.';

  String? get _clientId => AppEnv.maybeGet('SCENIO_GOOGLE_CLIENT_ID');
  String? get _serverClientId =>
      AppEnv.maybeGet('SCENIO_GOOGLE_SERVER_CLIENT_ID');

  Future<String> signInAndGetIdToken() async {
    if (!isConfiguredForCurrentPlatform) {
      throw ApiException(message: unavailableMessage);
    }

    await _ensureInitialized();

    if (!_googleSignIn.supportsAuthenticate()) {
      throw const ApiException(
        message:
            'Google Sign-In chưa được hỗ trợ trên nền tảng này trong bản hiện tại.',
      );
    }

    try {
      final GoogleSignInAccount account = await _googleSignIn.authenticate();
      final String? idToken = account.authentication.idToken;

      if (idToken == null || idToken.trim().isEmpty) {
        throw const ApiException(
          message:
              'Không lấy được Google ID token. Hãy kiểm tra lại cấu hình OAuth client.',
        );
      }

      return idToken;
    } on GoogleSignInException catch (error) {
      if (error.code == GoogleSignInExceptionCode.canceled) {
        throw const ApiException(
          message: 'Bạn đã huỷ thao tác đăng nhập Google.',
        );
      }

      throw ApiException(
        message:
            error.description ??
            'Google Sign-In hiện chưa thể hoàn tất. Hãy kiểm tra lại cấu hình OAuth.',
      );
    }
  }

  Future<void> signOut() async {
    if (!_isInitialized) {
      return;
    }

    try {
      await _googleSignIn.signOut();
    } catch (_) {
      // Ignore native Google session cleanup failures.
    }
  }

  Future<void> _ensureInitialized() async {
    if (_isInitialized) {
      return;
    }

    await _googleSignIn.initialize(
      clientId: _clientId,
      serverClientId: _serverClientId,
    );
    _isInitialized = true;
  }
}
