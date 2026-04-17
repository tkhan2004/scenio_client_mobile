import 'package:get/get.dart';

import 'chat_viewmodel.dart';

class ChatBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ChatViewModel>(ChatViewModel.new);
  }
}
