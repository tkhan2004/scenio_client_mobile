import 'package:get/get.dart';

import '../../domain/repositories/vocab_repository.dart';
import '../vocabulary/vocabulary_binding.dart';
import 'chat_viewmodel.dart';

class ChatBinding extends Bindings {
  @override
  void dependencies() {
    if (!Get.isRegistered<VocabRepository>()) {
      VocabularyBinding().dependencies();
    }
    Get.lazyPut<ChatViewModel>(ChatViewModel.new);
  }
}
