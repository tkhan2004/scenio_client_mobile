import 'dart:async';
import 'package:get/get.dart';
import '../../domain/repositories/auth_repository.dart';
import '../../core/storage/storage_service.dart';
import '../../routes/app_routes.dart';

class SplashViewModel extends GetxController {
  SplashViewModel({
    required StorageService storageService,
    required AuthRepository authRepository,
  }) : _storageService = storageService,
       _authRepository = authRepository;

  final StorageService _storageService;
  final AuthRepository _authRepository;
  Timer? _timer;

  @override
  void onReady() {
    super.onReady();
    _timer = Timer(
      const Duration(milliseconds: 1800),
      () => unawaited(_routeNext()),
    );
  }

  Future<void> _routeNext() async {
    if (!_storageService.hasSeenOnboarding) {
      Get.offNamed(Routes.onboarding);
      return;
    }

    if (_storageService.hasSession) {
      final bool hasValidSession = await _authRepository.ensureValidSession();
      if (!hasValidSession) {
        Get.offNamed(Routes.auth);
        return;
      }
      if (_authRepository.needsAccountOnboarding) {
        Get.offNamed(Routes.accountOnboarding);
        return;
      }
      Get.offNamed(Routes.home);
      return;
    }

    Get.offNamed(Routes.auth);
  }

  @override
  void onClose() {
    _timer?.cancel();
    super.onClose();
  }
}
