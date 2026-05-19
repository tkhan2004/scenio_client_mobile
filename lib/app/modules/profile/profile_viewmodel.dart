import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../core/constants/app_strings.dart';
import '../../core/network/api_response.dart';
import '../../core/utils/scenio_alerts.dart';
import '../../data/models/profile_model.dart';
import '../../data/models/session_flow_model.dart';
import '../../data/models/user_badges_model.dart';
import '../../data/models/user_progress_model.dart';
import '../../domain/entities/message_entity.dart';
import '../../domain/entities/session_entity.dart';
import '../../domain/entities/user_entity.dart';
import '../../domain/repositories/auth_repository.dart';
import '../../domain/repositories/learning_repository.dart';
import '../../domain/repositories/user_repository.dart';
import '../../routes/app_routes.dart';

class ProfileViewModel extends GetxController {
  ProfileViewModel({
    required AuthRepository authRepository,
    required LearningRepository learningRepository,
    required UserRepository userRepository,
  }) : _authRepository = authRepository,
       _learningRepository = learningRepository,
       _userRepository = userRepository;

  final AuthRepository _authRepository;
  final LearningRepository _learningRepository;
  final UserRepository _userRepository;

  final RxBool isLoadingProfile = false.obs;
  final RxBool isOpeningSessionResult = false.obs;
  final Rxn<UserEntity> profileUser = Rxn<UserEntity>();
  final Rxn<UserProgressModel> progress = Rxn<UserProgressModel>();
  final Rxn<UserBadgesModel> badges = Rxn<UserBadgesModel>();

  String get greeting => AppStrings.homeGreeting;
  String get displayName =>
      profileUser.value?.effectiveDisplayName ?? AppStrings.homeDisplayName;
  String get avatarInitial {
    final String raw = displayName.trim().isNotEmpty
        ? displayName.trim()
        : profileEmail.trim();
    if (raw.isEmpty) return 'S';
    return raw.substring(0, 1).toUpperCase();
  }

  String get profileEmail =>
      profileUser.value?.email ?? AppStrings.profileEmail;
  String get profileLevel =>
      progress.value?.summary.level ?? profileUser.value?.level ?? 'A2';
  String get profileLearningGoal =>
      _labelForLearningGoal(profileUser.value?.learningGoal);
  String get profileStudyFrequency =>
      _labelForStudyFrequency(profileUser.value?.studyFrequency);
  String get profileFocus => _labelForFocus(profileUser.value?.selfAssessment);
  String get profileGoalProgress {
    final UserProgressSummary? summary = progress.value?.summary;
    if (summary == null) return AppStrings.profileGoalProgressValue;
    return _localized(
      '${summary.completedSessions} phiên đã hoàn tất',
      '${summary.completedSessions} sessions completed',
    );
  }

  String get profileBadgesProgress {
    final UserBadgesSummary? summary = badges.value?.summary;
    if (summary == null) return AppStrings.profileBadgesProgressValue;
    return '${summary.totalEarned} / ${summary.totalAvailable}';
  }

  String get profileBadgesEarnedLabel {
    final UserBadgesSummary? summary = badges.value?.summary;
    if (summary == null) return AppStrings.profileBadgesEarnedLabel;
    return _localized(
      'Đã nhận ${summary.totalEarned}',
      '${summary.totalEarned} earned',
    );
  }

  List<ProfileOverviewStat> get profileOverviewStats {
    final UserProgressSummary? summary = progress.value?.summary;
    final UserBadgesSummary? badgeSummary = badges.value?.summary;
    final int totalXp = summary?.totalXp ?? profileUser.value?.totalXp ?? 0;
    final int streakDays =
        summary?.streakDays ?? profileUser.value?.streakDays ?? 0;
    final int completedSessions = summary?.completedSessions ?? 0;

    return <ProfileOverviewStat>[
      ProfileOverviewStat(
        label: AppStrings.profileStatXpLabel,
        value: '$totalXp',
        subtitle: AppStrings.profileStatXpSubtitle,
        icon: Icons.stars_rounded,
        tint: const Color(0xFFEF9F27),
      ),
      ProfileOverviewStat(
        label: AppStrings.profileStatStreakLabel,
        value: '$streakDays',
        subtitle: AppStrings.profileStatStreakSubtitle,
        icon: Icons.local_fire_department_rounded,
        tint: const Color(0xFF1D9E75),
      ),
      ProfileOverviewStat(
        label: AppStrings.profileStatSessionsLabel,
        value: '$completedSessions',
        subtitle: AppStrings.profileStatSessionsSubtitle,
        icon: Icons.chat_bubble_rounded,
        tint: const Color(0xFF66A7DA),
      ),
      ProfileOverviewStat(
        label: AppStrings.profileBadgesSection,
        value: '${badgeSummary?.totalEarned ?? 0}',
        subtitle: profileBadgesProgress,
        icon: Icons.emoji_events_rounded,
        tint: const Color(0xFF457FAF),
      ),
    ];
  }

  List<ProfileWeeklyXpPoint> get profileWeeklyXp {
    final List<UserWeeklyXpPoint> apiPoints =
        progress.value?.weeklyXp ?? const <UserWeeklyXpPoint>[];

    if (apiPoints.isEmpty) {
      return const <ProfileWeeklyXpPoint>[
        ProfileWeeklyXpPoint(dayLabel: 'M', xp: 0),
        ProfileWeeklyXpPoint(dayLabel: 'T', xp: 0),
        ProfileWeeklyXpPoint(dayLabel: 'W', xp: 0),
        ProfileWeeklyXpPoint(dayLabel: 'T', xp: 0),
        ProfileWeeklyXpPoint(dayLabel: 'F', xp: 0),
        ProfileWeeklyXpPoint(dayLabel: 'S', xp: 0),
        ProfileWeeklyXpPoint(dayLabel: 'S', xp: 0),
      ];
    }

    return apiPoints
        .map(
          (UserWeeklyXpPoint point) => ProfileWeeklyXpPoint(
            dayLabel: _dayLabelFromDate(point.date),
            xp: point.xp,
          ),
        )
        .toList();
  }

  List<ProfileSkillScore> get profileSkillScores {
    final UserSkillScores scores =
        progress.value?.skillScores ??
        const UserSkillScores(grammar: 0, vocabulary: 0, naturalness: 0);

    return <ProfileSkillScore>[
      ProfileSkillScore(
        label: AppStrings.profileSkillGrammar,
        score: scores.grammar,
        color: const Color(0xFF457FAF),
      ),
      ProfileSkillScore(
        label: AppStrings.profileSkillVocabulary,
        score: scores.vocabulary,
        color: const Color(0xFF66A7DA),
      ),
      ProfileSkillScore(
        label: AppStrings.profileSkillNaturalness,
        score: scores.naturalness,
        color: const Color(0xFF1D9E75),
      ),
    ];
  }

  List<ProfileBadgeData> get profileBadges {
    return (badges.value?.badges ?? const <UserBadgeModel>[])
        .map(
          (UserBadgeModel badge) => ProfileBadgeData(
            title: badge.title,
            description: badge.description,
            icon: _iconForBadge(badge.iconKey, badge.conditionType),
            xpReward: badge.xpReward,
            isEarned: badge.isEarned,
          ),
        )
        .toList();
  }

  List<ProfileHistoryItem> get profileHistory {
    return (progress.value?.sessionsHistory ?? const <UserSessionHistoryItem>[])
        .map(
          (UserSessionHistoryItem item) => ProfileHistoryItem(
            sessionId: item.id,
            title: item.sceneTitle,
            meta:
                '${_labelForCategory(item.category)} • ${item.difficulty} • ${item.sourceType == 'CUSTOM_PRACTICE' ? 'Custom' : 'Scene'}',
            dateLabel: _formatSessionDate(item.endedAt ?? item.startedAt),
            xpEarned: item.xpEarned,
            averageScore: item.averageScore,
            icon: _iconForCategory(item.category),
          ),
        )
        .toList();
  }

  List<ProfileActionItem> get profileActions => <ProfileActionItem>[
    ProfileActionItem(
      title: AppStrings.profileActionDailyGoal,
      subtitle: AppStrings.profileActionDailyGoalSubtitle,
      icon: Icons.track_changes_rounded,
    ),
    ProfileActionItem(
      id: 'language',
      title: 'profileActionLanguage'.tr,
      subtitle: 'profileActionLanguageSubtitle'.tr,
      icon: Icons.language_rounded,
    ),
    ProfileActionItem(
      id: 'notifications',
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

  @override
  void onInit() {
    super.onInit();
    unawaited(refreshProfile());
  }

  Future<void> refreshProfile() async {
    if (isLoadingProfile.value) return;

    isLoadingProfile.value = true;
    try {
      final List<dynamic> results =
          await Future.wait<dynamic>(<Future<dynamic>>[
            _userRepository.getMe(),
            _userRepository.getProgress(),
            _userRepository.getBadges(),
          ]);

      profileUser.value = results[0] as UserEntity;
      progress.value = results[1] as UserProgressModel;
      badges.value = results[2] as UserBadgesModel;
    } on ApiException catch (error) {
      ScenioAlert.show(
        title: AppStrings.appName,
        message: error.message,
        isError: true,
      );
    } catch (_) {
      ScenioAlert.show(
        title: AppStrings.appName,
        message: _localized(
          'Chưa thể tải dữ liệu hồ sơ từ backend.',
          'Could not load profile data from the backend.',
        ),
        isError: true,
      );
    } finally {
      isLoadingProfile.value = false;
    }
  }

  Future<void> logout() async {
    try {
      await _authRepository.logout();
    } catch (_) {
      // Local session is cleared in the repository finally block, so keep UX moving.
    }
    Get.offAllNamed(Routes.auth);
    ScenioAlert.show(
      title: AppStrings.appName,
      message: AppStrings.profileLogoutSuccessMessage,
      icon: Icons.logout_rounded,
      isSuccess: true,
    );
  }

  Future<void> completeOnboarding() {
    return _userRepository.completeOnboarding();
  }

  Future<void> openHistorySession(ProfileHistoryItem item) async {
    if (isOpeningSessionResult.value || item.sessionId.isEmpty) return;

    isOpeningSessionResult.value = true;
    try {
      final SessionResultModel model = await _learningRepository
          .fetchSessionResult(item.sessionId);
      final int completedTurns = model.transcript
          .where(
            (MessageEntity message) => message.author == MessageAuthor.user,
          )
          .length;
      final SessionResultEntity result = model.toEntity(
        completedTurns: completedTurns,
        targetTurns: completedTurns > 0 ? completedTurns : 3,
      );

      await Get.toNamed(Routes.sessionResult, arguments: result);
    } on ApiException catch (error) {
      ScenioAlert.show(
        title: AppStrings.appName,
        message: error.message,
        isError: true,
      );
    } catch (_) {
      ScenioAlert.show(
        title: AppStrings.appName,
        message: _localized(
          'Chưa thể mở lại kết quả phiên học này.',
          'Could not open this session result.',
        ),
        isError: true,
      );
    } finally {
      isOpeningSessionResult.value = false;
    }
  }

  String _labelForLearningGoal(String? raw) {
    switch (raw?.toUpperCase()) {
      case 'WORK':
        return _localized('Công việc', 'Work');
      case 'TRAVEL':
        return _localized('Du lịch', 'Travel');
      case 'DAILY':
      case 'DAILY_LIFE':
        return _localized('Đời sống', 'Daily life');
      case 'MIXED':
        return _localized('Kết hợp', 'Mixed');
      default:
        return AppStrings.profileHeroGoal;
    }
  }

  String _labelForStudyFrequency(String? raw) {
    switch (raw?.toUpperCase()) {
      case 'LIGHT':
        return _localized('Nhẹ nhàng', 'Light');
      case 'REGULAR':
        return _localized('Đều đặn', 'Regular');
      case 'INTENSIVE':
        return _localized('Tập trung', 'Intensive');
      default:
        return AppStrings.profileHeroFrequency;
    }
  }

  String _labelForFocus(String? raw) {
    switch (raw?.toUpperCase()) {
      case 'GRAMMAR':
        return AppStrings.profileSkillGrammar;
      case 'VOCABULARY':
        return AppStrings.profileSkillVocabulary;
      case 'NATURALNESS':
        return AppStrings.profileSkillNaturalness;
      case 'CONFIDENCE':
        return _localized('Tự tin', 'Confidence');
      default:
        return AppStrings.profileHeroFocus;
    }
  }

  String _labelForCategory(String raw) {
    switch (raw.toUpperCase()) {
      case 'TRAVEL':
        return _localized('Du lịch', 'Travel');
      case 'WORK':
        return _localized('Công việc', 'Work');
      case 'SOCIAL':
        return _localized('Xã hội', 'Social');
      case 'SERVICE':
        return _localized('Dịch vụ', 'Service');
      case 'CUSTOM':
        return 'Custom';
      case 'DAILY':
      default:
        return _localized('Đời sống', 'Daily');
    }
  }

  IconData _iconForCategory(String raw) {
    switch (raw.toUpperCase()) {
      case 'TRAVEL':
        return Icons.flight_takeoff_rounded;
      case 'WORK':
        return Icons.work_rounded;
      case 'SOCIAL':
        return Icons.groups_rounded;
      case 'SERVICE':
        return Icons.support_agent_rounded;
      case 'CUSTOM':
        return Icons.auto_awesome_rounded;
      case 'DAILY':
      default:
        return Icons.chat_bubble_rounded;
    }
  }

  IconData _iconForBadge(String iconKey, String conditionType) {
    final String key = iconKey.toLowerCase();
    final String condition = conditionType.toUpperCase();
    if (key.contains('streak') || condition.contains('STREAK')) {
      return Icons.local_fire_department_rounded;
    }
    if (key.contains('vocab') || condition.contains('VOCAB')) {
      return Icons.bookmark_rounded;
    }
    if (key.contains('score') || condition.contains('SCORE')) {
      return Icons.workspace_premium_rounded;
    }
    if (key.contains('first') || condition.contains('FIRST')) {
      return Icons.flag_rounded;
    }
    return Icons.emoji_events_rounded;
  }

  String _dayLabelFromDate(String rawDate) {
    final DateTime? parsed = DateTime.tryParse(rawDate);
    if (parsed == null) return rawDate.isEmpty ? '-' : rawDate.substring(0, 1);

    const List<String> labels = <String>['M', 'T', 'W', 'T', 'F', 'S', 'S'];
    return labels[parsed.weekday - 1];
  }

  String _formatSessionDate(DateTime? date) {
    if (date == null) return _localized('Chưa có ngày', 'No date');
    final String day = date.day.toString().padLeft(2, '0');
    final String month = date.month.toString().padLeft(2, '0');
    final String hour = date.hour.toString().padLeft(2, '0');
    final String minute = date.minute.toString().padLeft(2, '0');
    return '$day/$month • $hour:$minute';
  }

  String _localized(String vi, String en) {
    return Get.locale?.languageCode == 'vi' ? vi : en;
  }
}
