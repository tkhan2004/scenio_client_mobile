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

  String get effectiveDisplayName {
    if (displayName != null && displayName!.trim().isNotEmpty) {
      return displayName!.trim();
    }

    return email.split('@').first;
  }
}
