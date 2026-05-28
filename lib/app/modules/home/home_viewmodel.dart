import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../core/constants/app_strings.dart';
import '../../core/network/api_response.dart';
import '../../core/storage/storage_service.dart';
import '../../core/utils/scenio_alerts.dart';
import '../../data/models/custom_practice_model.dart';
import '../../data/models/home_dashboard_model.dart';
import '../../data/models/learning_plan_model.dart';
import '../../data/models/realtime_token_model.dart';
import '../../data/models/session_flow_model.dart';
import '../../domain/entities/message_entity.dart';
import '../../domain/entities/scene_entity.dart';
import '../../domain/entities/session_entity.dart';
import '../../domain/entities/user_entity.dart';
import '../../domain/repositories/auth_repository.dart';
import '../../domain/repositories/learning_repository.dart';
import '../../domain/repositories/notifications_repository.dart';
import '../../routes/app_routes.dart';

class HomeTabItem {
  const HomeTabItem({
    required this.label,
    required this.icon,
    required this.activeIcon,
  });

  final String label;
  final IconData icon;
  final IconData activeIcon;
}

class HomeQuickStat {
  const HomeQuickStat({
    required this.label,
    required this.value,
    required this.icon,
    required this.tint,
  });

  final String label;
  final String value;
  final IconData icon;
  final Color tint;
}

class HomeMissionCardData {
  const HomeMissionCardData({
    required this.title,
    required this.subtitle,
    required this.current,
    required this.target,
    required this.xpReward,
  });

  final String title;
  final String subtitle;
  final int current;
  final int target;
  final int xpReward;

  double get progress => target == 0 ? 0 : current / target;
}

class HomeViewModel extends GetxController {
  HomeViewModel({
    required LearningRepository repository,
    required AuthRepository authRepository,
    required NotificationsRepository notificationsRepository,
    required StorageService storageService,
  }) : _repository = repository,
       _authRepository = authRepository,
       _notificationsRepository = notificationsRepository,
       _storageService = storageService;

  final LearningRepository _repository;
  final AuthRepository _authRepository;
  final NotificationsRepository _notificationsRepository;
  final StorageService _storageService;

  final RxInt currentIndex = 0.obs;
  final RxDouble dashboardSheetProgress = 0.0.obs;
  final RxString sceneSearchQuery = ''.obs;
  final Rxn<SceneCategory> selectedCategory = Rxn<SceneCategory>();
  final Rxn<SceneDifficulty> selectedDifficulty = Rxn<SceneDifficulty>();
  final Rxn<SessionEntity> activeSession = Rxn<SessionEntity>();
  final Rx<PracticeRealtimeState> practiceState =
      PracticeRealtimeState.idle.obs;
  final RxList<MessageEntity> activeMessages = <MessageEntity>[].obs;
  final Rxn<SessionResultEntity> lastCompletedResult =
      Rxn<SessionResultEntity>();
  final Rxn<UserEntity> currentUser = Rxn<UserEntity>();
  final Rxn<LearningPlanResponseModel> learningPlan =
      Rxn<LearningPlanResponseModel>();
  final RxBool isLoadingDashboard = false.obs;
  final RxBool isLoadingScenes = false.obs;
  final RxBool isRefreshingLearningPlan = false.obs;
  final RxInt unreadNotificationsCount = 0.obs;

  final RxList<SceneEntity> _scenes = <SceneEntity>[..._fallbackScenes()].obs;
  final RxList<SceneEntity> _recommendedScenes = <SceneEntity>[
    ..._fallbackScenes().take(3),
  ].obs;
  final RxList<HomeMissionCardData> _todayMissions = <HomeMissionCardData>[
    ..._fallbackMissions(),
  ].obs;

  List<HomeTabItem> get tabs => <HomeTabItem>[
    HomeTabItem(
      label: AppStrings.homeTabHome,
      icon: Icons.home_outlined,
      activeIcon: Icons.home_rounded,
    ),
    HomeTabItem(
      label: AppStrings.homeTabScenes,
      icon: Icons.theater_comedy_outlined,
      activeIcon: Icons.theater_comedy_rounded,
    ),
    HomeTabItem(
      label: AppStrings.homeTabPractice,
      icon: Icons.graphic_eq_rounded,
      activeIcon: Icons.graphic_eq_rounded,
    ),
    HomeTabItem(
      label: AppStrings.homeTabVocabulary,
      icon: Icons.layers_outlined,
      activeIcon: Icons.layers_rounded,
    ),
    HomeTabItem(
      label: AppStrings.homeTabProfile,
      icon: Icons.person_outline_rounded,
      activeIcon: Icons.person_rounded,
    ),
  ];

  String get displayName {
    final String? currentName = currentUser.value?.effectiveDisplayName.trim();
    if (currentName != null &&
        currentName.isNotEmpty &&
        !_isGenericDisplayName(currentName)) {
      return currentName;
    }

    final String? storedName = _storageService.displayName?.trim();
    if (storedName != null &&
        storedName.isNotEmpty &&
        !_isGenericDisplayName(storedName)) {
      return storedName;
    }

    return AppStrings.homeDisplayName;
  }

  String get greetingSubtitle => AppStrings.homeGreetingSubtitle;

  List<HomeQuickStat> get quickStats => <HomeQuickStat>[
    HomeQuickStat(
      label: AppStrings.homeStatXp,
      value: '${currentUser.value?.totalXp ?? 320}',
      icon: Icons.stars_rounded,
      tint: const Color(0xFFEF9F27),
    ),
    HomeQuickStat(
      label: AppStrings.homeStatStreak,
      value: '${currentUser.value?.streakDays ?? 7}',
      icon: Icons.local_fire_department_rounded,
      tint: const Color(0xFF1D9E75),
    ),
    HomeQuickStat(
      label: AppStrings.homeStatSaved,
      value: '18',
      icon: Icons.bookmark_rounded,
      tint: const Color(0xFF457FAF),
    ),
  ];

  List<HomeMissionCardData> get todayMissions => _todayMissions;
  List<SceneEntity> get scenes => _scenes;
  LearningPlanResponseModel? get currentLearningPlan => learningPlan.value;
  bool get hasLearningPlan => learningPlan.value != null;
  String get learningPlanFocusLabel =>
      _labelForFocusSkill(learningPlan.value?.plan.focusSkill);
  String get learningPlanProgressLabel {
    final LearningPlanResponseModel? plan = learningPlan.value;
    if (plan == null) return '0/0 steps';
    return '${plan.completedSteps}/${plan.totalSteps} steps';
  }

  String get learningPlanWeeklyTargetLabel {
    final LearningPlanResponseModel? plan = learningPlan.value;
    if (plan == null) return '3 sessions / week';
    return '${plan.plan.weeklyTarget} sessions / week';
  }

  String get learningPlanOutcomeLabel {
    final LearningPlanResponseModel? plan = learningPlan.value;
    if (plan == null) {
      return 'Build clear, confident replies across everyday scenes.';
    }

    final String goal = (plan.plan.learningGoal ?? '').toUpperCase();
    switch (goal) {
      case 'WORK':
        return 'Handle workplace conversations with clearer structure.';
      case 'TRAVEL':
        return 'Handle everyday travel situations clearly and confidently.';
      case 'DAILY':
        return 'Keep short daily conversations natural and easy to follow.';
      default:
        return 'Improve real-life speaking through guided scene practice.';
    }
  }

  String get learningPlanPhaseLabel {
    final LearningPlanResponseModel? plan = learningPlan.value;
    if (plan == null || plan.totalSteps == 0) return 'Roadmap setup';
    if (plan.progress >= 0.75) return 'Final polish';
    if (plan.progress >= 0.38) return 'Core practice';
    if (plan.completedSteps > 0) return 'Foundation building';
    return 'Start here';
  }

  String get learningPlanNextReason {
    final LearningPlanResponseModel? plan = learningPlan.value;
    LearningPlanStepModel? matchingStep;
    if (plan != null) {
      for (final LearningPlanStepModel step in plan.steps) {
        if (step.id == plan.nextStep?.id) {
          matchingStep = step;
          break;
        }
      }
    }

    final String? reason = matchingStep?.reason?.trim();
    if (reason != null && reason.isNotEmpty) return reason;

    return 'This step keeps your roadmap moving and gives Scenio fresh data for the next feedback.';
  }

  String get learningPlanSuggestedDayLabel {
    final int target = learningPlan.value?.plan.weeklyTarget ?? 3;
    if (target >= 4) return 'Mon / Wed / Fri / Sun';
    if (target == 3) return 'Tue / Thu / Sat';
    if (target == 2) return 'Tue / Fri';
    return 'Thursday';
  }

  List<SceneCategory?> get sceneCategoryFilters => <SceneCategory?>[
    null,
    ...SceneCategory.values,
  ];

  List<SceneDifficulty?> get sceneDifficultyFilters => <SceneDifficulty?>[
    null,
    ...SceneDifficulty.values,
  ];

  SceneEntity get heroScene => currentSessionScene ?? recommendedScenes.first;

  SceneEntity? get currentSessionScene {
    final SessionEntity? session = currentSession;
    if (session == null) return null;

    for (final SceneEntity scene in _scenes) {
      if (scene.id == session.sceneId) {
        return scene;
      }
      if (scene.title.toLowerCase() == session.sceneTitle.toLowerCase()) {
        return scene;
      }
    }

    return null;
  }

  SessionEntity? get currentSession => activeSession.value;

  bool get hasActiveSession =>
      activeSession.value != null &&
      activeSession.value!.status == SessionStatus.active;

  List<SceneEntity> get recommendedScenes => _recommendedScenes.isNotEmpty
      ? _recommendedScenes
      : _scenes.take(3).toList(growable: false);

  List<SceneEntity> get filteredScenes {
    final String query = sceneSearchQuery.value.trim().toLowerCase();

    return _scenes.where((SceneEntity scene) {
      final bool matchesQuery =
          query.isEmpty ||
          scene.title.toLowerCase().contains(query) ||
          scene.description.toLowerCase().contains(query) ||
          scene.characterRole.toLowerCase().contains(query) ||
          scene.mission.toLowerCase().contains(query);
      final bool matchesCategory =
          selectedCategory.value == null ||
          scene.category == selectedCategory.value;
      final bool matchesDifficulty =
          selectedDifficulty.value == null ||
          scene.difficulty == selectedDifficulty.value;
      return matchesQuery && matchesCategory && matchesDifficulty;
    }).toList();
  }

  String get continueCardLabel => hasActiveSession
      ? AppStrings.homeContinueResumeLabel
      : AppStrings.homeContinueStartLabel;

  String get continueCardTitle => heroScene.title;

  String get continueCardTime => hasActiveSession
      ? 'Started ${_formatSessionStart(currentSession!.startedAt)}'
      : 'Suggested next • ${heroScene.estimatedMinutes} min';

  String get continueCardCharacter =>
      '${heroScene.characterName} • ${heroScene.characterRole}';

  String get continueCardMeta =>
      '${heroScene.categoryLabel} • ${heroScene.difficultyLabel} • ${heroScene.estimatedMinutes} min';

  String get continueBadgeValue => heroScene.difficultyLabel;

  String get continueStatusLabel => hasActiveSession
      ? AppStrings.homeContinueStatusActive
      : AppStrings.homeContinueStatusReady;

  String get continueStatusValue => hasActiveSession
      ? '${currentSession!.completedTurns}/${currentSession!.targetTurns} turns'
      : heroScene.categoryLabel;

  @override
  void onInit() {
    super.onInit();
    unawaited(_bootstrap());
  }

  Future<void> _bootstrap() async {
    if (!_authRepository.hasSession) {
      Get.offAllNamed(Routes.auth);
      return;
    }

    _hydrateCachedActiveSession();
    isLoadingDashboard.value = true;
    isLoadingScenes.value = true;

    try {
      final HomeDashboardModel dashboard = await _repository.fetchDashboard();
      currentUser.value = dashboard.user;
      unawaited(refreshNotificationSummary());
      await _loadLearningPlanQuietly();
      _todayMissions.assignAll(
        dashboard.missions
            .map(
              (HomeMissionModel mission) => HomeMissionCardData(
                title: mission.title,
                subtitle: mission.description,
                current: mission.current,
                target: mission.target,
                xpReward: mission.xp,
              ),
            )
            .toList(),
      );
      _recommendedScenes.assignAll(
        dashboard.recommendedScenes.cast<SceneEntity>(),
      );

      final List<SceneEntity> fetchedScenes = await _repository.fetchScenes();
      if (fetchedScenes.isNotEmpty) {
        _scenes.assignAll(fetchedScenes);
      }

      if (dashboard.inProgressSession != null) {
        _hydrateInProgressSession(dashboard.inProgressSession, replace: true);
      } else if (activeSession.value != null) {
        activeSession.value = null;
        activeMessages.clear();
        await _storageService.clearActivePracticeSession();
      }
    } on ApiException catch (error) {
      if (error.statusCode == 401) {
        await _handleUnauthorized();
        return;
      }
      _showError(error.message);
    } catch (_) {
      _showError('Không thể tải dữ liệu Home từ backend.');
    } finally {
      isLoadingDashboard.value = false;
      isLoadingScenes.value = false;
    }
  }

  Future<void> _loadLearningPlanQuietly() async {
    try {
      learningPlan.value = await _repository.fetchCurrentLearningPlan();
    } catch (_) {
      // Home vẫn dùng được nếu learning plan đang tạm lỗi hoặc backend chưa seed.
    }
  }

  Future<void> refreshNotificationSummary() async {
    try {
      final page = await _notificationsRepository.fetchNotifications(
        page: 1,
        limit: 5,
      );
      unreadNotificationsCount.value = page.unreadCount;
    } catch (_) {
      // Badge lỗi không nên chặn Home.
    }
  }

  void _hydrateCachedActiveSession() {
    if (activeSession.value != null) return;

    final Map<String, dynamic>? snapshot =
        _storageService.activePracticeSession;
    if (snapshot == null) return;

    final String id = snapshot['id'] as String? ?? '';
    if (id.isEmpty) return;

    final SessionEntity session = SessionEntity(
      id: id,
      sceneId: snapshot['sceneId'] as String? ?? '',
      sceneTitle: snapshot['sceneTitle'] as String? ?? 'Practice Session',
      characterName: snapshot['characterName'] as String? ?? 'AI',
      characterRole: snapshot['characterRole'] as String? ?? 'AI partner',
      difficultyLabel: snapshot['difficultyLabel'] as String? ?? 'A2',
      mission:
          snapshot['mission'] as String? ??
          'Continue the conversation naturally.',
      startedAt:
          DateTime.tryParse(snapshot['startedAt'] as String? ?? '') ??
          DateTime.now(),
      status: SessionStatus.active,
      completedTurns: (snapshot['completedTurns'] as num?)?.toInt() ?? 0,
      targetTurns: (snapshot['targetTurns'] as num?)?.toInt() ?? 3,
    );

    activeSession.value = session;
    _ensureSceneForResume(
      sceneId: session.sceneId,
      sceneTitle: session.sceneTitle,
      characterName: session.characterName,
    );
    activeMessages.assignAll(<MessageEntity>[
      MessageEntity(
        id: '${session.id}-cached-resume',
        sessionId: session.id,
        author: MessageAuthor.ai,
        text: 'Your previous practice is still active. Continue when ready.',
        createdAt: DateTime.now(),
      ),
    ]);
    practiceState.value = PracticeRealtimeState.userListening;
  }

  void _hydrateInProgressSession(
    InProgressSessionModel? inProgressSession, {
    bool replace = false,
  }) {
    if (inProgressSession == null ||
        (!replace && activeSession.value != null)) {
      return;
    }

    final SceneEntity scene = _ensureSceneForResume(
      sceneId: '',
      sceneTitle: inProgressSession.sceneTitle,
      characterName: inProgressSession.characterName,
    );

    activeSession.value = SessionEntity(
      id: inProgressSession.id,
      sceneId: scene.id,
      sceneTitle: scene.title,
      characterName: scene.characterName,
      characterRole: scene.characterRole,
      difficultyLabel: scene.difficultyLabel,
      mission: scene.mission,
      startedAt: inProgressSession.startedAt,
      status: SessionStatus.active,
      completedTurns: 0,
      targetTurns: 3,
    );

    activeMessages.assignAll(<MessageEntity>[
      MessageEntity(
        id: '${inProgressSession.id}-resume',
        sessionId: inProgressSession.id,
        author: MessageAuthor.ai,
        text: 'Let’s continue where we left off whenever you are ready.',
        createdAt: DateTime.now(),
      ),
    ]);
    practiceState.value = PracticeRealtimeState.userListening;
    unawaited(_persistActiveSession());
  }

  Future<void> _persistActiveSession() async {
    final SessionEntity? session = activeSession.value;
    if (session == null || session.status != SessionStatus.active) {
      await _storageService.clearActivePracticeSession();
      return;
    }

    await _storageService.saveActivePracticeSession(<String, dynamic>{
      'id': session.id,
      'sceneId': session.sceneId,
      'sceneTitle': session.sceneTitle,
      'characterName': session.characterName,
      'characterRole': session.characterRole,
      'difficultyLabel': session.difficultyLabel,
      'mission': session.mission,
      'startedAt': session.startedAt.toIso8601String(),
      'completedTurns': session.completedTurns,
      'targetTurns': session.targetTurns,
    });
  }

  void selectTab(int index) {
    if (index < 0 || index >= tabs.length) return;
    currentIndex.value = index;
  }

  void openNotifications() {
    unawaited(_openNotifications());
  }

  Future<void> _openNotifications() async {
    await Get.toNamed(Routes.notifications);
    await refreshNotificationSummary();
  }

  void updateSceneSearch(String value) {
    sceneSearchQuery.value = value;
  }

  void selectSceneCategory(SceneCategory? category) {
    selectedCategory.value = category;
  }

  void selectSceneDifficulty(SceneDifficulty? difficulty) {
    selectedDifficulty.value = difficulty;
  }

  void openSceneDetails(SceneEntity scene) {
    unawaited(_openSceneDetails(scene));
  }

  Future<void> _openSceneDetails(SceneEntity scene) async {
    try {
      final SceneEntity detailedScene = await _repository.fetchSceneDetail(
        scene.id,
      );
      _replaceOrInsertScene(detailedScene);
      await Get.toNamed(Routes.sceneDetail, arguments: detailedScene);
    } catch (_) {
      await Get.toNamed(Routes.sceneDetail, arguments: scene);
    }
  }

  void handleHeroSceneTap() {
    if (hasActiveSession) {
      openPracticeSession();
      return;
    }

    openSceneDetails(heroScene);
  }

  void handleLearningPlanTap() {
    Get.toNamed(Routes.learningPlan, arguments: learningPlan.value);
  }

  void openLearningPlanNextStep() {
    unawaited(_openLearningPlanNextStep());
  }

  Future<void> _openLearningPlanNextStep() async {
    final LearningPlanNextStepModel? nextStep = learningPlan.value?.nextStep;
    final String? sceneId = nextStep?.sceneId;

    if (sceneId == null || sceneId.isEmpty) {
      handleLearningPlanTap();
      return;
    }

    SceneEntity? localScene;
    for (final SceneEntity scene in _scenes) {
      if (scene.id == sceneId) {
        localScene = scene;
        break;
      }
    }
    if (localScene != null) {
      openSceneDetails(localScene);
      return;
    }

    try {
      final SceneEntity scene = await _repository.fetchSceneDetail(sceneId);
      _replaceOrInsertScene(scene);
      openSceneDetails(scene);
    } catch (_) {
      handleLearningPlanTap();
    }
  }

  void refreshLearningPlan() {
    unawaited(_refreshLearningPlan());
  }

  Future<void> _refreshLearningPlan() async {
    if (isRefreshingLearningPlan.value) return;

    isRefreshingLearningPlan.value = true;
    try {
      learningPlan.value = await _repository.refreshLearningPlan();
      ScenioAlert.show(
        title: AppStrings.appName,
        message: 'Đã làm mới lộ trình học của bạn.',
        isSuccess: true,
      );
    } on ApiException catch (error) {
      _showError(error.message);
    } catch (_) {
      _showError('Không thể làm mới lộ trình lúc này.');
    } finally {
      isRefreshingLearningPlan.value = false;
    }
  }

  void openPracticeSession() {
    if (!hasActiveSession) return;
    Get.toNamed(Routes.practiceSession, arguments: currentSession!.id);
  }

  void openCustomPractice() {
    Get.toNamed(Routes.customPractice);
  }

  bool hasActiveSessionForScene(String sceneId) {
    return hasActiveSession && currentSession!.sceneId == sceneId;
  }

  bool hasActiveSessionOutsideScene(String sceneId) {
    return hasActiveSession && currentSession!.sceneId != sceneId;
  }

  SceneEntity sceneById(String sceneId) {
    return _scenes.firstWhere(
      (SceneEntity scene) => scene.id == sceneId,
      orElse: () => _scenes.first,
    );
  }

  void beginScenePractice(SceneEntity scene, {bool forceNew = false}) {
    unawaited(_beginScenePractice(scene, forceNew: forceNew));
  }

  Future<void> _beginScenePractice(
    SceneEntity scene, {
    bool forceNew = false,
  }) async {
    if (hasActiveSession && !forceNew) {
      openPracticeSession();
      return;
    }

    if (hasActiveSession && forceNew) {
      await _abandonCurrentSession(showAlert: false);
    }

    try {
      final SessionStartModel start = await _repository.startSession(
        sceneId: scene.id,
        modality: 'VOICE',
      );
      activeSession.value = start.toSessionEntity(scene);
      activeMessages.assignAll(<MessageEntity>[start.toOpeningMessage()]);
      practiceState.value = PracticeRealtimeState.userListening;
      unawaited(_persistActiveSession());
      openPracticeSession();
    } on ApiException catch (error) {
      if (error.statusCode == 409 &&
          error.code == 'SESSION_ALREADY_ACTIVE' &&
          error.details is List<dynamic>) {
        _hydrateConflictingActiveSession(error.details as List<dynamic>);
        openPracticeSession();
        return;
      }

      if (error.statusCode == 401) {
        await _handleUnauthorized();
        return;
      }

      _showError(error.message);
    } catch (_) {
      _showError('Không thể bắt đầu phiên luyện tập lúc này.');
    }
  }

  Future<bool> startCustomPracticeSession(
    CustomPracticeDraft draft, {
    bool replaceActive = true,
  }) async {
    if (hasActiveSession && !replaceActive) {
      openPracticeSession();
      return false;
    }

    if (hasActiveSession && replaceActive) {
      await _abandonCurrentSession(showAlert: false);
    }

    try {
      final CustomPracticeStartModel start = await _repository
          .startCustomSession(draft);
      final SceneEntity syntheticScene = start.toSyntheticScene();
      _replaceOrInsertScene(syntheticScene);
      activeSession.value = start.toSessionEntity(syntheticScene);
      activeMessages.assignAll(<MessageEntity>[start.toOpeningMessage()]);
      practiceState.value = PracticeRealtimeState.userListening;
      unawaited(_persistActiveSession());
      return true;
    } on ApiException catch (error) {
      if (error.statusCode == 409 &&
          error.code == 'SESSION_ALREADY_ACTIVE' &&
          error.details is List<dynamic>) {
        _hydrateConflictingActiveSession(error.details as List<dynamic>);
        return true;
      }

      if (error.statusCode == 401) {
        await _handleUnauthorized();
        return false;
      }

      _showError(error.message);
      return false;
    } catch (_) {
      _showError('Không thể bắt đầu custom practice lúc này.');
      return false;
    }
  }

  void _hydrateConflictingActiveSession(List<dynamic> details) {
    final Map<String, String> detailMap = <String, String>{};
    for (final dynamic item in details) {
      if (item is Map<String, dynamic>) {
        final String field = item['field'] as String? ?? '';
        final String message = item['message'] as String? ?? '';
        if (field.isNotEmpty) {
          detailMap[field] = message;
        }
      }
    }

    final SceneEntity scene = _ensureSceneForResume(
      sceneId: detailMap['activeSession.sceneId'] ?? '',
      sceneTitle: detailMap['activeSession.sceneTitle'] ?? 'Practice Session',
      characterName: detailMap['activeSession.characterName'] ?? 'AI',
    );

    activeSession.value = SessionEntity(
      id: detailMap['activeSession.id'] ?? '',
      sceneId: scene.id,
      sceneTitle: scene.title,
      characterName: scene.characterName,
      characterRole: scene.characterRole,
      difficultyLabel: scene.difficultyLabel,
      mission: scene.mission,
      startedAt:
          DateTime.tryParse(detailMap['activeSession.startedAt'] ?? '') ??
          DateTime.now(),
      status: SessionStatus.active,
      completedTurns: 0,
      targetTurns: 3,
    );
    activeMessages.assignAll(<MessageEntity>[
      MessageEntity(
        id: '${activeSession.value!.id}-conflict',
        sessionId: activeSession.value!.id,
        author: MessageAuthor.ai,
        text: 'You already have an active practice. Let’s continue it here.',
        createdAt: DateTime.now(),
      ),
    ]);
    practiceState.value = PracticeRealtimeState.userListening;
    unawaited(_persistActiveSession());
  }

  SceneEntity _ensureSceneForResume({
    required String sceneId,
    required String sceneTitle,
    required String characterName,
  }) {
    for (final SceneEntity scene in _scenes) {
      if (sceneId.isNotEmpty && scene.id == sceneId) {
        return scene;
      }

      if (scene.title.toLowerCase() == sceneTitle.toLowerCase()) {
        return scene;
      }
    }

    final SceneEntity syntheticScene = SceneEntity(
      id: sceneId.isNotEmpty ? sceneId : 'synthetic-${sceneTitle.hashCode}',
      title: sceneTitle,
      category: SceneCategory.dailyLife,
      difficulty: SceneDifficulty.a2,
      estimatedMinutes: 8,
      characterName: characterName,
      characterRole: 'AI partner',
      description: 'Resume your current practice session from the backend.',
      mission: 'Continue the conversation naturally and finish the scene.',
      vocabularyPreview: const <String>[],
      starterPrompt: '',
      aiReplyPool: const <String>[
        'Thanks. Please continue.',
        'I understand. What would you say next?',
        'Great. Let’s finish this naturally.',
      ],
    );
    _replaceOrInsertScene(syntheticScene);
    return syntheticScene;
  }

  Future<void> submitPracticeReply(String text) async {
    if (!hasActiveSession) return;

    final SceneEntity scene = currentSessionScene ?? _scenes.first;
    final SessionEntity session = currentSession!;
    final int nextTurn = (session.completedTurns + 1).clamp(0, 3).toInt();
    final String trimmedText = text.trim();

    final MessageEntity userMessage = MessageEntity(
      id: '${session.id}-user-$nextTurn-${DateTime.now().millisecondsSinceEpoch}',
      sessionId: session.id,
      author: MessageAuthor.user,
      text: trimmedText,
      createdAt: DateTime.now(),
    );

    activeMessages.add(userMessage);
    activeSession.value = session.copyWith(completedTurns: nextTurn);
    unawaited(_persistActiveSession());
    practiceState.value = PracticeRealtimeState.aiThinking;

    try {
      await _repository.syncMessage(
        sessionId: session.id,
        source: 'USER_TEXT',
        content: trimmedText,
        turnIndex: nextTurn,
      );
    } on ApiException catch (error) {
      if (error.statusCode == 401) {
        await _handleUnauthorized();
        return;
      }
      _showError(error.message);
    } catch (_) {
      _showError('Không thể đồng bộ câu trả lời của bạn.');
    }

    await Future<void>.delayed(const Duration(milliseconds: 620));

    final int replyIndex = (nextTurn - 1).clamp(
      0,
      scene.aiReplyPool.length - 1,
    );
    final String aiReply = scene.aiReplyPool[replyIndex];
    final MessageEntity aiMessage = MessageEntity(
      id: '${session.id}-ai-$nextTurn-${DateTime.now().millisecondsSinceEpoch}',
      sessionId: session.id,
      author: MessageAuthor.ai,
      text: aiReply,
      createdAt: DateTime.now(),
    );

    activeMessages.add(aiMessage);

    try {
      await _repository.syncMessage(
        sessionId: session.id,
        source: 'AI_TEXT',
        content: aiReply,
        turnIndex: nextTurn,
      );
    } catch (_) {
      // Giữ local AI placeholder để test flow UI ngay cả khi sync AI turn lỗi.
    }

    practiceState.value = PracticeRealtimeState.aiSpeaking;
    await Future<void>.delayed(const Duration(milliseconds: 900));
    if (hasActiveSession) {
      practiceState.value = PracticeRealtimeState.userListening;
    }
  }

  Future<RealtimeTokenModel> createRealtimeTokenForCurrentSession() {
    final SessionEntity? session = currentSession;
    if (session == null) {
      throw StateError('No active session');
    }
    return _repository.createRealtimeToken(session.id);
  }

  void appendRealtimeTranscriptMessage({
    required MessageAuthor author,
    required String content,
    String? providerEventId,
  }) {
    final SessionEntity? session = currentSession;
    if (session == null || content.trim().isEmpty) return;

    final int nextTurn = author == MessageAuthor.user
        ? (session.completedTurns + 1).clamp(0, session.targetTurns).toInt()
        : session.completedTurns;

    activeMessages.add(
      MessageEntity(
        id:
            providerEventId ??
            '${session.id}-${author.name}-${DateTime.now().millisecondsSinceEpoch}',
        sessionId: session.id,
        author: author,
        text: content.trim(),
        createdAt: DateTime.now(),
      ),
    );

    if (author == MessageAuthor.user) {
      activeSession.value = session.copyWith(completedTurns: nextTurn);
      unawaited(_persistActiveSession());
    }
  }

  Future<void> syncAudioTranscript({
    required MessageAuthor author,
    required String content,
    String? providerEventId,
    int? audioStartMs,
    int? audioEndMs,
  }) async {
    final SessionEntity? session = currentSession;
    if (session == null || content.trim().isEmpty) return;

    await _repository.syncMessage(
      sessionId: session.id,
      source: author == MessageAuthor.user ? 'USER_AUDIO' : 'AI_AUDIO',
      content: content,
      providerEventId: providerEventId,
      audioStartMs: audioStartMs,
      audioEndMs: audioEndMs,
    );
  }

  Future<void> requestHint() => _requestHint();

  Future<void> _requestHint() async {
    if (!hasActiveSession) return;

    try {
      practiceState.value = PracticeRealtimeState.aiThinking;
      final MessageEntity hintMessage = await _repository.requestHint(
        currentSession!.id,
      );
      activeMessages.add(hintMessage);
      practiceState.value = PracticeRealtimeState.aiSpeaking;
      await Future<void>.delayed(const Duration(milliseconds: 720));
      if (hasActiveSession) {
        practiceState.value = PracticeRealtimeState.userListening;
      }
    } on ApiException catch (error) {
      if (error.statusCode == 401) {
        await _handleUnauthorized();
        return;
      }
      practiceState.value = PracticeRealtimeState.userListening;
      _showError(error.message);
    } catch (_) {
      practiceState.value = PracticeRealtimeState.userListening;
      _showError('Không thể xin hint lúc này.');
    }
  }

  void setPracticeState(PracticeRealtimeState state) {
    practiceState.value = state;
  }

  Future<SessionResultEntity> completeCurrentSession() async {
    final SessionEntity session = currentSession!;

    await _repository.completeSession(session.id);
    final SessionResultModel resultModel = await _repository.fetchSessionResult(
      session.id,
    );
    final SessionResultEntity result = resultModel.toEntity(
      completedTurns: session.completedTurns,
      targetTurns: session.targetTurns,
    );

    lastCompletedResult.value = result;
    activeSession.value = null;
    activeMessages.clear();
    await _storageService.clearActivePracticeSession();
    practiceState.value = PracticeRealtimeState.idle;
    unawaited(_bootstrap());
    return result;
  }

  void abandonCurrentSession() {
    unawaited(_abandonCurrentSession());
  }

  Future<void> _abandonCurrentSession({bool showAlert = true}) async {
    final SessionEntity? session = currentSession;
    if (session == null) return;

    try {
      await _repository.abandonSession(session.id);
    } catch (_) {
      // Dù backend abandon lỗi, vẫn dọn local state để user không bị kẹt UI.
    } finally {
      activeSession.value = null;
      activeMessages.clear();
      await _storageService.clearActivePracticeSession();
      practiceState.value = PracticeRealtimeState.idle;
      if (showAlert) {
        ScenioAlert.show(
          title: AppStrings.appName,
          message: AppStrings.practiceLeaveSnackbar,
          icon: Icons.check_circle_outline_rounded,
          isSuccess: true,
        );
      }
    }
  }

  void updateDashboardSheetProgress({
    required double extent,
    required double minExtent,
    required double maxExtent,
  }) {
    final double progress = maxExtent <= minExtent
        ? 0.0
        : ((extent - minExtent) / (maxExtent - minExtent)).clamp(0.0, 1.0);
    dashboardSheetProgress.value = progress;
  }

  Future<void> _handleUnauthorized() async {
    await _storageService.clearSession();
    if (Get.currentRoute != Routes.auth) {
      Get.offAllNamed(Routes.auth);
    }
  }

  bool _isGenericDisplayName(String value) {
    final String normalized = value.trim().toLowerCase();
    return normalized == 'scenio learner' ||
        normalized == 'learner' ||
        normalized == 'user';
  }

  void _replaceOrInsertScene(SceneEntity scene) {
    final int index = _scenes.indexWhere(
      (SceneEntity item) => item.id == scene.id,
    );
    if (index >= 0) {
      _scenes[index] = scene;
      return;
    }
    _scenes.insert(0, scene);
  }

  void _showError(String message) {
    ScenioAlert.show(
      title: AppStrings.appName,
      message: message,
      isError: true,
    );
  }

  String _labelForFocusSkill(String? raw) {
    switch (raw?.toUpperCase()) {
      case 'GRAMMAR':
        return AppStrings.profileSkillGrammar;
      case 'VOCABULARY':
        return AppStrings.profileSkillVocabulary;
      case 'NATURALNESS':
        return AppStrings.profileSkillNaturalness;
      case 'CONFIDENCE':
        return Get.locale?.languageCode == 'vi' ? 'Tự tin' : 'Confidence';
      default:
        return Get.locale?.languageCode == 'vi' ? 'Cá nhân hóa' : 'Personal';
    }
  }

  String _formatSessionStart(DateTime time) {
    final String hour = time.hour.toString().padLeft(2, '0');
    final String minute = time.minute.toString().padLeft(2, '0');
    return 'at $hour:$minute';
  }
}

List<HomeMissionCardData> _fallbackMissions() {
  return const <HomeMissionCardData>[
    HomeMissionCardData(
      title: 'Complete one scene',
      subtitle: 'Finish a short guided conversation today.',
      current: 0,
      target: 1,
      xpReward: 50,
    ),
    HomeMissionCardData(
      title: 'Take three turns',
      subtitle: 'Reply naturally for three guided turns.',
      current: 1,
      target: 3,
      xpReward: 30,
    ),
  ];
}

List<SceneEntity> _fallbackScenes() {
  return const <SceneEntity>[
    SceneEntity(
      id: 'fallback-cafe-small-talk',
      title: 'Cafe small talk',
      category: SceneCategory.dailyLife,
      difficulty: SceneDifficulty.a2,
      estimatedMinutes: 6,
      characterName: 'Mia',
      characterRole: 'Friendly barista',
      description:
          'Order a drink, answer a follow-up question, and close the conversation naturally.',
      mission:
          'Complete a smooth cafe order from greeting to payment without losing confidence.',
      vocabularyPreview: <String>['iced latte', 'for here', 'receipt'],
      starterPrompt:
          'Hi there. Welcome in. What can I get started for you today?',
      aiReplyPool: <String>[
        'Great choice. Would you like that hot or iced?',
        'Absolutely. Anything to eat with your drink today?',
        'Perfect. That will be ready in a couple of minutes.',
      ],
    ),
    SceneEntity(
      id: 'fallback-airport-check-in',
      title: 'Airport check-in',
      category: SceneCategory.travel,
      difficulty: SceneDifficulty.a2,
      estimatedMinutes: 8,
      characterName: 'David',
      characterRole: 'Check-in staff',
      description:
          'Answer travel questions clearly and respond to quick airport instructions.',
      mission:
          'Check in for your flight, confirm baggage details, and ask one useful follow-up question.',
      vocabularyPreview: <String>['passport', 'boarding pass', 'checked bag'],
      starterPrompt:
          'Good afternoon. May I see your passport and booking confirmation, please?',
      aiReplyPool: <String>[
        'Thank you. Are you checking in any bags today?',
        'Your seat is near the window. Is that okay for you?',
        'Perfect. Here is your boarding pass.',
      ],
    ),
    SceneEntity(
      id: 'fallback-job-interview',
      title: 'Job interview',
      category: SceneCategory.work,
      difficulty: SceneDifficulty.b1,
      estimatedMinutes: 10,
      characterName: 'Sarah',
      characterRole: 'Interviewer',
      description:
          'Introduce yourself, describe your strengths, and answer follow-up questions with calm structure.',
      mission:
          'Deliver a clear self-introduction and handle a short interview exchange with confidence.',
      vocabularyPreview: <String>['experience', 'strengths', 'responsibility'],
      starterPrompt:
          'Thanks for joining us today. Could you start by telling me a little about yourself?',
      aiReplyPool: <String>[
        'That sounds good. What would you say is one strength you bring to a team?',
        'Can you give me a quick example from your previous work or study experience?',
        'Thank you. Do you have any questions for me before we finish?',
      ],
    ),
  ];
}
