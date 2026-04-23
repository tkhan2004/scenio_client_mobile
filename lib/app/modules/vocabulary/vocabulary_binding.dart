import 'package:get/get.dart';

import '../../core/network/api_client.dart';
import '../../data/providers/vocab_provider.dart';
import '../../data/repositories/vocab_repository_impl.dart';
import '../../domain/repositories/vocab_repository.dart';
import 'vocabulary_viewmodel.dart';

class VocabularyBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<VocabProvider>(
      () => VocabProvider(apiClient: Get.find<ApiClient>()),
      fenix: true,
    );
    Get.lazyPut<VocabRepository>(
      () => VocabRepositoryImpl(provider: Get.find<VocabProvider>()),
      fenix: true,
    );
    Get.lazyPut<VocabularyViewModel>(
      () => VocabularyViewModel(repository: Get.find<VocabRepository>()),
      fenix: true,
    );
  }
}
