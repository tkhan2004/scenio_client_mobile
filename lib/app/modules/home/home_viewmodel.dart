import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../core/constants/app_strings.dart';

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

class HomeSceneCardData {
  const HomeSceneCardData({
    required this.title,
    required this.subtitle,
    required this.meta,
    required this.icon,
  });

  final String title;
  final String subtitle;
  final String meta;
  final IconData icon;
}



class HomeViewModel extends GetxController {
  final RxInt currentIndex = 0.obs;
  final RxDouble dashboardSheetProgress = 0.0.obs;

  List<HomeTabItem> get tabs => const <HomeTabItem>[
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
      label: AppStrings.homeTabChat,
      icon: Icons.chat_bubble_outline_rounded,
      activeIcon: Icons.chat_bubble_rounded,
    ),
    HomeTabItem(
      label: AppStrings.homeTabProfile,
      icon: Icons.person_outline_rounded,
      activeIcon: Icons.person_rounded,
    ),
  ];

  String get greeting => AppStrings.homeGreeting;
  String get displayName => AppStrings.homeDisplayName;
  String get greetingSubtitle => AppStrings.homeGreetingSubtitle;
  String get profileEmail => AppStrings.profileEmail;
  String get profileLevel => AppStrings.homeContinueBadgeValue;
  String get profileLearningGoal => AppStrings.profileHeroGoal;
  String get profileStudyFrequency => AppStrings.profileHeroFrequency;
  String get profileFocus => AppStrings.profileHeroFocus;
  String get profileGoalProgress => AppStrings.profileGoalProgressValue;
  String get profileBadgesProgress => AppStrings.profileBadgesProgressValue;

  List<HomeQuickStat> get quickStats => const <HomeQuickStat>[
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

  List<HomeMissionCardData> get todayMissions => const <HomeMissionCardData>[
    HomeMissionCardData(
      title: AppStrings.homeMissionOneTitle,
      subtitle: AppStrings.homeMissionOneSubtitle,
      current: 0,
      target: 1,
      xpReward: 50,
    ),
    HomeMissionCardData(
      title: AppStrings.homeMissionTwoTitle,
      subtitle: AppStrings.homeMissionTwoSubtitle,
      current: 1,
      target: 3,
      xpReward: 30,
    ),
  ];

  List<HomeSceneCardData> get recommendedScenes => const <HomeSceneCardData>[
    HomeSceneCardData(
      title: AppStrings.homeSceneOneTitle,
      subtitle: AppStrings.homeSceneOneSubtitle,
      meta: AppStrings.homeSceneOneMeta,
      icon: Icons.theater_comedy_rounded,
    ),
    HomeSceneCardData(
      title: AppStrings.homeSceneTwoTitle,
      subtitle: AppStrings.homeSceneTwoSubtitle,
      meta: AppStrings.homeSceneTwoMeta,
      icon: Icons.flight_takeoff_rounded,
    ),
    HomeSceneCardData(
      title: AppStrings.homeSceneThreeTitle,
      subtitle: AppStrings.homeSceneThreeSubtitle,
      meta: AppStrings.homeSceneThreeMeta,
      icon: Icons.groups_rounded,
    ),
  ];

  void selectTab(int index) {
    if (index < 0 || index >= tabs.length) return;
    currentIndex.value = index;
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
}
