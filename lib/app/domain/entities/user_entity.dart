class UserEntity {
  const UserEntity({
    required this.id,
    required this.email,
    required this.displayName,
    required this.avatarUrl,
    required this.level,
    required this.totalXp,
    required this.streakDays,
    required this.needsLevelTest,
    required this.needsOnboarding,
    this.learningGoal,
    this.studyFrequency,
    this.selfAssessment,
  });

  final String id;
  final String email;
  final String? displayName;
  final String? avatarUrl;
  final String level;
  final int totalXp;
  final int streakDays;
  final bool needsLevelTest;
  final bool needsOnboarding;
  final String? learningGoal;
  final String? studyFrequency;
  final String? selfAssessment;

  String get effectiveDisplayName {
    if (displayName != null && displayName!.trim().isNotEmpty) {
      return displayName!.trim();
    }

    return email.split('@').first;
  }
}
