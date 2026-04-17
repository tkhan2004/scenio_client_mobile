import 'package:get/get.dart';

import '../../domain/entities/session_entity.dart';
import '../home/home_viewmodel.dart';

class SessionResultViewModel extends GetxController {
  late final SessionResultEntity result;
  final HomeViewModel homeViewModel = Get.find<HomeViewModel>();

  @override
  void onInit() {
    super.onInit();
    final Object? rawArgument = Get.arguments;
    result = rawArgument is SessionResultEntity
        ? rawArgument
        : homeViewModel.lastCompletedResult.value!;
  }
}
