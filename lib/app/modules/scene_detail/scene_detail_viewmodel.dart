import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../core/constants/app_strings.dart';
import '../../domain/entities/scene_entity.dart';
import '../../domain/entities/session_entity.dart';
import '../home/home_viewmodel.dart';

class SceneDetailViewModel extends GetxController {
  final HomeViewModel homeViewModel = Get.find<HomeViewModel>();
  late final SceneEntity scene;

  bool get hasCurrentSceneActive =>
      homeViewModel.hasActiveSessionForScene(scene.id);
  bool get hasAnotherActiveSession =>
      homeViewModel.hasActiveSessionOutsideScene(scene.id);
  SessionEntity? get otherSession => homeViewModel.currentSession;

  String get primaryCtaLabel => hasCurrentSceneActive
      ? AppStrings.sceneDetailContinueButton
      : hasAnotherActiveSession
      ? AppStrings.sceneDetailResumeCurrentButton
      : AppStrings.sceneDetailStartButton;

  @override
  void onInit() {
    super.onInit();
    final Object? rawArgument = Get.arguments;
    if (rawArgument is SceneEntity) {
      scene = rawArgument;
      return;
    }

    final String? sceneId = rawArgument is String ? rawArgument : null;
    scene = sceneId == null
        ? homeViewModel.scenes.first
        : homeViewModel.sceneById(sceneId);
  }

  void handlePrimaryCta() {
    if (hasCurrentSceneActive || hasAnotherActiveSession) {
      homeViewModel.openPracticeSession();
      return;
    }

    homeViewModel.beginScenePractice(scene);
  }

  void forceStartNew() {
    unawaited(
      Future<void>.microtask(
        () => homeViewModel.beginScenePractice(scene, forceNew: true),
      ),
    );
  }

  IconData iconForScene() {
    switch (scene.category) {
      case SceneCategory.dailyLife:
        return Icons.local_cafe_rounded;
      case SceneCategory.travel:
        return Icons.flight_takeoff_rounded;
      case SceneCategory.work:
        return Icons.work_rounded;
      case SceneCategory.social:
        return Icons.groups_rounded;
      case SceneCategory.service:
        return Icons.hotel_rounded;
    }
  }
}
