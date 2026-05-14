import 'package:get/get.dart';

import 'core/auth/google_sign_in_service.dart';
import 'core/network/api_client.dart';
import 'core/realtime/realtime_conversation_service.dart';
import 'core/storage/storage_service.dart';
import 'data/providers/auth_provider.dart';
import 'data/providers/learning_provider.dart';
import 'data/providers/user_provider.dart';
import 'data/repositories/auth_repository_impl.dart';
import 'data/repositories/learning_repository_impl.dart';
import 'data/repositories/user_repository_impl.dart';
import 'domain/repositories/auth_repository.dart';
import 'domain/repositories/learning_repository.dart';
import 'domain/repositories/user_repository.dart';

class AppBinding extends Bindings {
  @override
  void dependencies() {
    Get.put<StorageService>(StorageService(), permanent: true);
    Get.put<ApiClient>(
      ApiClient(storageService: Get.find<StorageService>()),
      permanent: true,
    );
    Get.put<GoogleSignInService>(GoogleSignInService(), permanent: true);
    Get.put<RealtimeConversationService>(
      RealtimeConversationService(),
      permanent: true,
    );

    Get.lazyPut<AuthProvider>(
      () => AuthProvider(apiClient: Get.find<ApiClient>()),
      fenix: true,
    );
    Get.lazyPut<AuthRepository>(
      () => AuthRepositoryImpl(
        provider: Get.find<AuthProvider>(),
        storageService: Get.find<StorageService>(),
        googleSignInService: Get.find<GoogleSignInService>(),
      ),
      fenix: true,
    );

    Get.lazyPut<LearningProvider>(
      () => LearningProvider(apiClient: Get.find<ApiClient>()),
      fenix: true,
    );
    Get.lazyPut<LearningRepository>(
      () => LearningRepositoryImpl(provider: Get.find<LearningProvider>()),
      fenix: true,
    );

    Get.lazyPut<UserProvider>(
      () => UserProvider(apiClient: Get.find<ApiClient>()),
      fenix: true,
    );
    Get.lazyPut<UserRepository>(
      () => UserRepositoryImpl(provider: Get.find<UserProvider>()),
      fenix: true,
    );
  }
}
