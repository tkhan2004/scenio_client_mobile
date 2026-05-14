class UserBadgesModel {
  const UserBadgesModel({required this.summary, required this.badges});

  factory UserBadgesModel.fromMap(Map<String, dynamic> map) {
    return UserBadgesModel(
      summary: UserBadgesSummary.fromMap(
        map['summary'] as Map<String, dynamic>? ?? <String, dynamic>{},
      ),
      badges: (map['badges'] as List<dynamic>? ?? const <dynamic>[])
          .whereType<Map<String, dynamic>>()
          .map(UserBadgeModel.fromMap)
          .toList(),
    );
  }

  final UserBadgesSummary summary;
  final List<UserBadgeModel> badges;
}

class UserBadgesSummary {
  const UserBadgesSummary({
    required this.totalEarned,
    required this.totalAvailable,
  });

  factory UserBadgesSummary.fromMap(Map<String, dynamic> map) {
    return UserBadgesSummary(
      totalEarned: (map['totalEarned'] as num?)?.toInt() ?? 0,
      totalAvailable: (map['totalAvailable'] as num?)?.toInt() ?? 0,
    );
  }

  final int totalEarned;
  final int totalAvailable;
}

class UserBadgeModel {
  const UserBadgeModel({
    required this.id,
    required this.title,
    required this.description,
    required this.iconKey,
    required this.conditionType,
    required this.conditionValue,
    required this.xpReward,
    required this.isEarned,
    this.earnedAt,
  });

  factory UserBadgeModel.fromMap(Map<String, dynamic> map) {
    return UserBadgeModel(
      id: map['id'] as String? ?? '',
      title: map['title'] as String? ?? 'Achievement',
      description: map['description'] as String? ?? '',
      iconKey: map['iconKey'] as String? ?? '',
      conditionType: map['conditionType'] as String? ?? '',
      conditionValue: (map['conditionValue'] as num?)?.toInt() ?? 0,
      xpReward: (map['xpReward'] as num?)?.toInt() ?? 0,
      isEarned: map['isEarned'] == true,
      earnedAt: DateTime.tryParse(map['earnedAt'] as String? ?? ''),
    );
  }

  final String id;
  final String title;
  final String description;
  final String iconKey;
  final String conditionType;
  final int conditionValue;
  final int xpReward;
  final bool isEarned;
  final DateTime? earnedAt;
}
