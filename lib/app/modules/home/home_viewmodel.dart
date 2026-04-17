import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../core/constants/app_strings.dart';
import '../../domain/entities/message_entity.dart';
import '../../domain/entities/scene_entity.dart';
import '../../domain/entities/session_entity.dart';
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
      label: AppStrings.homeTabVocabulary,
      icon: Icons.layers_outlined,
      activeIcon: Icons.layers_rounded,
    ),
    HomeTabItem(
      label: AppStrings.homeTabPractice,
      icon: Icons.graphic_eq_rounded,
      activeIcon: Icons.graphic_eq_rounded,
    ),
    HomeTabItem(
      label: AppStrings.homeTabProfile,
      icon: Icons.person_outline_rounded,
      activeIcon: Icons.person_rounded,
    ),
  ];

  String get displayName => AppStrings.homeDisplayName;
  String get greetingSubtitle => AppStrings.homeGreetingSubtitle;

  List<HomeQuickStat> get quickStats => <HomeQuickStat>[
    HomeQuickStat(
      label: AppStrings.homeStatXp,
      value: '320',
      icon: Icons.stars_rounded,
      tint: Color(0xFFEF9F27),
    ),
    HomeQuickStat(
      label: AppStrings.homeStatStreak,
      value: '7',
      icon: Icons.local_fire_department_rounded,
      tint: Color(0xFF1D9E75),
    ),
    HomeQuickStat(
      label: AppStrings.homeStatSaved,
      value: '18',
      icon: Icons.bookmark_rounded,
      tint: Color(0xFF457FAF),
    ),
  ];

  List<HomeMissionCardData> get todayMissions => <HomeMissionCardData>[
    HomeMissionCardData(
      title: AppStrings.homeMissionOneTitle,
      subtitle: AppStrings.homeMissionOneSubtitle,
      current: hasActiveSession
          ? currentSession!.completedTurns.clamp(0, 1).toInt()
          : 0,
      target: 1,
      xpReward: 50,
    ),
    HomeMissionCardData(
      title: AppStrings.homeMissionTwoTitle,
      subtitle: AppStrings.homeMissionTwoSubtitle,
      current: hasActiveSession
          ? currentSession!.completedTurns.clamp(0, 3).toInt()
          : 1,
      target: 3,
      xpReward: 30,
    ),
  ];

  List<SceneEntity> get scenes => const <SceneEntity>[
    SceneEntity(
      id: 'cafe-small-talk',
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
        'Perfect. That will be ready in a couple of minutes. You can pay at the counter.',
      ],
    ),
    SceneEntity(
      id: 'airport-check-in',
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
        'Perfect. Here is your boarding pass. Boarding begins at gate twelve in forty minutes.',
      ],
    ),
    SceneEntity(
      id: 'job-interview',
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
    SceneEntity(
      id: 'hotel-front-desk',
      title: 'Hotel front desk',
      category: SceneCategory.service,
      difficulty: SceneDifficulty.a2,
      estimatedMinutes: 7,
      characterName: 'Emma',
      characterRole: 'Receptionist',
      description:
          'Check in at a hotel, confirm your room details, and ask for one service politely.',
      mission:
          'Finish a hotel check-in and request one helpful service in polite English.',
      vocabularyPreview: <String>[
        'reservation',
        'single room',
        'late checkout',
      ],
      starterPrompt:
          'Good evening. Welcome to Blue Harbor Hotel. Do you have a reservation with us?',
      aiReplyPool: <String>[
        'Thank you. I can see your booking here. Would you like a quiet room if one is available?',
        'Breakfast starts at seven on the second floor. Is there anything else you need tonight?',
        'Of course. I have noted your request. Enjoy your stay with us.',
      ],
    ),
  ];

  List<SceneCategory?> get sceneCategoryFilters => <SceneCategory?>[
    null,
    ...SceneCategory.values,
  ];

  List<SceneDifficulty?> get sceneDifficultyFilters => <SceneDifficulty?>[
    null,
    ...SceneDifficulty.values,
  ];

  SceneEntity get heroScene => currentSessionScene ?? recommendedScenes.first;

  SceneEntity? get currentSessionScene =>
      currentSession == null ? null : sceneById(currentSession!.sceneId);

  SessionEntity? get currentSession => activeSession.value;

  bool get hasActiveSession =>
      activeSession.value != null &&
      activeSession.value!.status == SessionStatus.active;

  List<SceneEntity> get recommendedScenes => scenes.take(3).toList();

  List<SceneEntity> get filteredScenes {
    final String query = sceneSearchQuery.value.trim().toLowerCase();

    return scenes.where((SceneEntity scene) {
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

  void selectTab(int index) {
    if (index < 0 || index >= tabs.length) return;
    currentIndex.value = index;
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
    Get.toNamed(Routes.sceneDetail, arguments: scene.id);
  }

  void handleHeroSceneTap() {
    if (hasActiveSession) {
      openPracticeSession();
      return;
    }

    openSceneDetails(heroScene);
  }

  void openPracticeSession() {
    if (!hasActiveSession) return;
    Get.toNamed(Routes.practiceSession, arguments: currentSession!.id);
  }

  bool hasActiveSessionForScene(String sceneId) {
    return hasActiveSession && currentSession!.sceneId == sceneId;
  }

  bool hasActiveSessionOutsideScene(String sceneId) {
    return hasActiveSession && currentSession!.sceneId != sceneId;
  }

  SceneEntity sceneById(String sceneId) {
    return scenes.firstWhere((SceneEntity scene) => scene.id == sceneId);
  }

  SessionEntity startOrResumeScene(SceneEntity scene, {bool forceNew = false}) {
    if (hasActiveSession && !forceNew) {
      return currentSession!;
    }

    final SessionEntity session = SessionEntity(
      id: 'session-${scene.id}-${DateTime.now().millisecondsSinceEpoch}',
      sceneId: scene.id,
      sceneTitle: scene.title,
      characterName: scene.characterName,
      characterRole: scene.characterRole,
      difficultyLabel: scene.difficultyLabel,
      mission: scene.mission,
      startedAt: DateTime.now(),
      status: SessionStatus.active,
      completedTurns: 0,
      targetTurns: 3,
    );

    activeSession.value = session;
    activeMessages.assignAll(<MessageEntity>[
      MessageEntity(
        id: '${session.id}-welcome',
        sessionId: session.id,
        author: MessageAuthor.ai,
        text: scene.starterPrompt,
        createdAt: DateTime.now(),
      ),
    ]);
    practiceState.value = PracticeRealtimeState.userListening;
    return session;
  }

  Future<void> submitPracticeReply(String text) async {
    if (!hasActiveSession) return;

    final SceneEntity scene = currentSessionScene!;
    final SessionEntity session = currentSession!;
    final int nextTurn = (session.completedTurns + 1)
        .clamp(0, session.targetTurns)
        .toInt();

    activeMessages.add(
      MessageEntity(
        id: '${session.id}-user-$nextTurn',
        sessionId: session.id,
        author: MessageAuthor.user,
        text: text.trim(),
        createdAt: DateTime.now(),
      ),
    );

    activeSession.value = session.copyWith(completedTurns: nextTurn);
    practiceState.value = PracticeRealtimeState.aiThinking;
    await Future<void>.delayed(const Duration(milliseconds: 650));

    final int replyIndex = (nextTurn - 1)
        .clamp(0, scene.aiReplyPool.length - 1)
        .toInt();
    final String aiReply = scene.aiReplyPool[replyIndex];

    activeMessages.add(
      MessageEntity(
        id: '${session.id}-ai-$nextTurn',
        sessionId: session.id,
        author: MessageAuthor.ai,
        text: aiReply,
        createdAt: DateTime.now(),
      ),
    );

    practiceState.value = PracticeRealtimeState.aiSpeaking;
    await Future<void>.delayed(const Duration(milliseconds: 900));
    if (hasActiveSession) {
      practiceState.value = PracticeRealtimeState.userListening;
    }
  }

  void setPracticeState(PracticeRealtimeState state) {
    practiceState.value = state;
  }

  SessionResultEntity completeCurrentSession() {
    final SessionEntity session = currentSession!;
    final SessionResultEntity result = SessionResultEntity(
      sessionId: session.id,
      sceneId: session.sceneId,
      sceneTitle: session.sceneTitle,
      characterName: session.characterName,
      xpEarned: 50 + (session.completedTurns * 20),
      grammarScore: 78 + (session.completedTurns * 4),
      vocabularyScore: 74 + (session.completedTurns * 5),
      naturalnessScore: 76 + (session.completedTurns * 4),
      completedTurns: session.completedTurns,
      targetTurns: session.targetTurns,
      transcript: activeMessages.toList(growable: false),
    );

    lastCompletedResult.value = result;
    activeSession.value = session.copyWith(status: SessionStatus.completed);
    activeSession.value = null;
    activeMessages.clear();
    practiceState.value = PracticeRealtimeState.idle;
    return result;
  }

  void abandonCurrentSession() {
    if (!hasActiveSession) return;

    final SessionEntity session = currentSession!;
    activeSession.value = session.copyWith(status: SessionStatus.abandoned);
    activeSession.value = null;
    activeMessages.clear();
    practiceState.value = PracticeRealtimeState.idle;
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

  String _formatSessionStart(DateTime time) {
    final String hour = time.hour.toString().padLeft(2, '0');
    final String minute = time.minute.toString().padLeft(2, '0');
    return 'at $hour:$minute';
  }
}
