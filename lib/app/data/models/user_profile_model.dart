import '../../domain/entities/user_entity.dart';

class UserProfileModel {
  const UserProfileModel({required this.user});

  factory UserProfileModel.fromMap(Map<String, dynamic> map) {
    final Map<String, dynamic> userMap =
        map['user'] as Map<String, dynamic>? ?? <String, dynamic>{};

    return UserProfileModel(user: userFromMap(userMap));
  }

  final UserEntity user;
}

UserEntity userFromMap(Map<String, dynamic> map) {
  return UserEntity(
    id: map['id'] as String? ?? '',
    email: map['email'] as String? ?? '',
    displayName: map['displayName'] as String?,
    avatarUrl: map['avatarUrl'] as String?,
    level: map['level'] as String? ?? 'A2',
    totalXp: (map['totalXp'] as num?)?.toInt() ?? 0,
    streakDays: (map['streakDays'] as num?)?.toInt() ?? 0,
    needsLevelTest: map['needsLevelTest'] == true,
    needsOnboarding: map['needsOnboarding'] == true,
    learningGoal: map['learningGoal'] as String?,
    studyFrequency: map['studyFrequency'] as String?,
    selfAssessment: map['selfAssessment'] as String?,
  );
}
