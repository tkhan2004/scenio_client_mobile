import 'package:get/get.dart';

import '../../domain/repositories/user_repository.dart';
import 'account_onboarding_viewmodel.dart';

class AccountOnboardingBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AccountOnboardingViewModel>(
      () => AccountOnboardingViewModel(
        userRepository: Get.find<UserRepository>(),
      ),
    );
  }
}
