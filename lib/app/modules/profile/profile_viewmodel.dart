import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../core/constants/app_strings.dart';
import '../../data/models/profile_model.dart';

class ProfileViewModel extends GetxController {
  String get greeting => AppStrings.homeGreeting;
  String get displayName => AppStrings.homeDisplayName;
  String get profileEmail => AppStrings.profileEmail;
  String get profileLevel => AppStrings.homeContinueBadgeValue;
  String get profileLearningGoal => AppStrings.profileHeroGoal;
  String get profileStudyFrequency => AppStrings.profileHeroFrequency;
  String get profileFocus => AppStrings.profileHeroFocus;
  String get profileGoalProgress => AppStrings.profileGoalProgressValue;
  String get profileBadgesProgress => AppStrings.profileBadgesProgressValue;

  List<ProfileOverviewStat> get profileOverviewStats =>
      const <ProfileOverviewStat>[
        ProfileOverviewStat(
          label: AppStrings.profileStatXpLabel,
          value: '320',
          subtitle: AppStrings.profileStatXpSubtitle,
          icon: Icons.stars_rounded,
          tint: Color(0xFFEF9F27),
        ),
        ProfileOverviewStat(
          label: AppStrings.profileStatStreakLabel,
          value: '7',
          subtitle: AppStrings.profileStatStreakSubtitle,
          icon: Icons.local_fire_department_rounded,
          tint: Color(0xFF1D9E75),
        ),
        ProfileOverviewStat(
          label: AppStrings.profileStatSessionsLabel,
          value: '12',
          subtitle: AppStrings.profileStatSessionsSubtitle,
          icon: Icons.chat_bubble_rounded,
          tint: Color(0xFF66A7DA),
        ),
        ProfileOverviewStat(
          label: AppStrings.profileStatSavedLabel,
          value: '24',
          subtitle: AppStrings.profileStatSavedSubtitle,
          icon: Icons.bookmark_rounded,
          tint: Color(0xFF457FAF),
        ),
      ];

  List<ProfileWeeklyXpPoint> get profileWeeklyXp =>
      const <ProfileWeeklyXpPoint>[
        ProfileWeeklyXpPoint(dayLabel: 'M', xp: 12),
        ProfileWeeklyXpPoint(dayLabel: 'T', xp: 32),
        ProfileWeeklyXpPoint(dayLabel: 'W', xp: 48),
        ProfileWeeklyXpPoint(dayLabel: 'T', xp: 26),
        ProfileWeeklyXpPoint(dayLabel: 'F', xp: 56),
        ProfileWeeklyXpPoint(dayLabel: 'S', xp: 18),
        ProfileWeeklyXpPoint(dayLabel: 'S', xp: 44),
      ];

  List<ProfileSkillScore> get profileSkillScores => const <ProfileSkillScore>[
        ProfileSkillScore(
          label: AppStrings.profileSkillGrammar,
          score: 85,
          color: Color(0xFF457FAF),
        ),
        ProfileSkillScore(
          label: AppStrings.profileSkillVocabulary,
          score: 78,
          color: Color(0xFF66A7DA),
        ),
        ProfileSkillScore(
          label: AppStrings.profileSkillNaturalness,
          score: 82,
          color: Color(0xFF1D9E75),
        ),
      ];

  List<ProfileBadgeData> get profileBadges => const <ProfileBadgeData>[
        ProfileBadgeData(
          title: AppStrings.profileBadgeFirstSceneTitle,
          description: AppStrings.profileBadgeFirstSceneDescription,
          icon: Icons.emoji_events_rounded,
          xpReward: 30,
          isEarned: true,
        ),
        ProfileBadgeData(
          title: AppStrings.profileBadgeSevenDayTitle,
          description: AppStrings.profileBadgeSevenDayDescription,
          icon: Icons.local_fire_department_rounded,
          xpReward: 50,
          isEarned: true,
        ),
        ProfileBadgeData(
          title: AppStrings.profileBadgeCollectorTitle,
          description: AppStrings.profileBadgeCollectorDescription,
          icon: Icons.auto_awesome_rounded,
          xpReward: 40,
          isEarned: false,
        ),
      ];

  List<ProfileHistoryItem> get profileHistory => const <ProfileHistoryItem>[
        ProfileHistoryItem(
          title: AppStrings.profileHistoryAirportTitle,
          meta: AppStrings.profileHistoryAirportMeta,
          dateLabel: 'Apr 09 • 10:30 AM',
          xpEarned: 60,
          averageScore: 82,
          icon: Icons.flight_takeoff_rounded,
        ),
        ProfileHistoryItem(
          title: AppStrings.profileHistoryCafeTitle,
          meta: AppStrings.profileHistoryCafeMeta,
          dateLabel: 'Apr 08 • 08:20 PM',
          xpEarned: 40,
          averageScore: 79,
          icon: Icons.local_cafe_rounded,
        ),
        ProfileHistoryItem(
          title: AppStrings.profileHistoryMeetingTitle,
          meta: AppStrings.profileHistoryMeetingMeta,
          dateLabel: 'Apr 06 • 07:45 AM',
          xpEarned: 55,
          averageScore: 84,
          icon: Icons.groups_rounded,
        ),
      ];

  List<ProfileActionItem> get profileActions => const <ProfileActionItem>[
        ProfileActionItem(
          title: AppStrings.profileActionSavedWords,
          subtitle: AppStrings.profileActionSavedWordsSubtitle,
          icon: Icons.menu_book_rounded,
        ),
        ProfileActionItem(
          title: AppStrings.profileActionDailyGoal,
          subtitle: AppStrings.profileActionDailyGoalSubtitle,
          icon: Icons.track_changes_rounded,
        ),
        ProfileActionItem(
          title: AppStrings.profileActionNotifications,
          subtitle: AppStrings.profileActionNotificationsSubtitle,
          icon: Icons.notifications_active_outlined,
        ),
        ProfileActionItem(
          title: AppStrings.profileActionLogout,
          subtitle: AppStrings.profileActionLogoutSubtitle,
          icon: Icons.logout_rounded,
          isDestructive: true,
        ),
      ];
}
