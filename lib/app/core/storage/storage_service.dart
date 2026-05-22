import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class StorageService extends GetxService {
  static const String _boxName = 'scenio_mobile';
  static const String _accessTokenKey = 'access_token';
  static const String _refreshTokenKey = 'refresh_token';
  static const String _seenOnboardingKey = 'seen_onboarding';
  static const String _displayNameKey = 'display_name';
  static const String _activePracticeSessionKey = 'active_practice_session';

  static Future<void> init() async {
    await GetStorage.init(_boxName);
  }

  late final GetStorage _box;

  @override
  void onInit() {
    super.onInit();
    _box = GetStorage(_boxName);
  }

  String? get accessToken => _box.read<String>(_accessTokenKey);
  String? get refreshToken => _box.read<String>(_refreshTokenKey);
  String? get displayName => _box.read<String>(_displayNameKey);
  Map<String, dynamic>? get activePracticeSession {
    final dynamic value = _box.read(_activePracticeSessionKey);
    if (value is Map) {
      return Map<String, dynamic>.from(value);
    }
    return null;
  }

  bool get hasSession =>
      (accessToken?.isNotEmpty ?? false) && (refreshToken?.isNotEmpty ?? false);
  bool get hasSeenOnboarding => _box.read<bool>(_seenOnboardingKey) ?? false;

  Future<void> saveSession({
    required String accessToken,
    required String refreshToken,
    String? displayName,
  }) async {
    await _box.write(_accessTokenKey, accessToken);
    await _box.write(_refreshTokenKey, refreshToken);
    if (displayName != null && displayName.trim().isNotEmpty) {
      await _box.write(_displayNameKey, displayName.trim());
    }
  }

  Future<void> saveAccessToken(String accessToken) async {
    await _box.write(_accessTokenKey, accessToken);
  }

  Future<void> saveActivePracticeSession(Map<String, dynamic> session) async {
    await _box.write(_activePracticeSessionKey, session);
  }

  Future<void> clearActivePracticeSession() async {
    await _box.remove(_activePracticeSessionKey);
  }

  Future<void> clearSession() async {
    await _box.remove(_accessTokenKey);
    await _box.remove(_refreshTokenKey);
    await _box.remove(_displayNameKey);
    await clearActivePracticeSession();
  }

  Future<void> markOnboardingSeen() async {
    await _box.write(_seenOnboardingKey, true);
  }
}
