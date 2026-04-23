import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class StorageService extends GetxService {
  static const String _boxName = 'scenio_mobile';
  static const String _accessTokenKey = 'access_token';
  static const String _refreshTokenKey = 'refresh_token';
  static const String _seenOnboardingKey = 'seen_onboarding';

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
  bool get hasSession =>
      (accessToken?.isNotEmpty ?? false) && (refreshToken?.isNotEmpty ?? false);
  bool get hasSeenOnboarding => _box.read<bool>(_seenOnboardingKey) ?? false;

  Future<void> saveSession({
    required String accessToken,
    required String refreshToken,
  }) async {
    await _box.write(_accessTokenKey, accessToken);
    await _box.write(_refreshTokenKey, refreshToken);
  }

  Future<void> saveAccessToken(String accessToken) async {
    await _box.write(_accessTokenKey, accessToken);
  }

  Future<void> clearSession() async {
    await _box.remove(_accessTokenKey);
    await _box.remove(_refreshTokenKey);
  }

  Future<void> markOnboardingSeen() async {
    await _box.write(_seenOnboardingKey, true);
  }
}
