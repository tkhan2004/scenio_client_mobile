import '../../domain/entities/user_entity.dart';

class AuthSessionModel {
  const AuthSessionModel({
    required this.user,
    required this.accessToken,
    required this.refreshToken,
    required this.needsLevelTest,
    required this.needsOnboarding,
  });

  factory AuthSessionModel.fromMap(Map<String, dynamic> map) {
    final Map<String, dynamic> userMap =
        map['user'] as Map<String, dynamic>? ?? <String, dynamic>{};

    return AuthSessionModel(
      user: UserEntity(
        id: userMap['id'] as String? ?? '',
        email: userMap['email'] as String? ?? '',
        displayName: userMap['displayName'] as String?,
        avatarUrl: userMap['avatarUrl'] as String?,
        level: userMap['level'] as String? ?? 'A2',
        totalXp: (userMap['totalXp'] as num?)?.toInt() ?? 0,
        streakDays: (userMap['streakDays'] as num?)?.toInt() ?? 0,
        needsLevelTest: map['needsLevelTest'] == true,
        needsOnboarding: map['needsOnboarding'] == true,
        learningGoal: userMap['learningGoal'] as String?,
        studyFrequency: userMap['studyFrequency'] as String?,
        selfAssessment: userMap['selfAssessment'] as String?,
      ),
      accessToken: map['accessToken'] as String? ?? '',
      refreshToken: map['refreshToken'] as String? ?? '',
      needsLevelTest: map['needsLevelTest'] == true,
      needsOnboarding: map['needsOnboarding'] == true,
    );
  }

  final UserEntity user;
  final String accessToken;
  final String refreshToken;
  final bool needsLevelTest;
  final bool needsOnboarding;
}
