class UserProgressModel {
  const UserProgressModel({
    required this.summary,
    required this.weeklyXp,
    required this.skillScores,
    required this.sessionsHistory,
  });

  factory UserProgressModel.fromMap(Map<String, dynamic> map) {
    return UserProgressModel(
      summary: UserProgressSummary.fromMap(
        map['summary'] as Map<String, dynamic>? ?? <String, dynamic>{},
      ),
      weeklyXp: (map['weeklyXp'] as List<dynamic>? ?? const <dynamic>[])
          .whereType<Map<String, dynamic>>()
          .map(UserWeeklyXpPoint.fromMap)
          .toList(),
      skillScores: UserSkillScores.fromMap(
        map['skillScores'] as Map<String, dynamic>? ?? <String, dynamic>{},
      ),
      sessionsHistory:
          (map['sessionsHistory'] as List<dynamic>? ?? const <dynamic>[])
              .whereType<Map<String, dynamic>>()
              .map(UserSessionHistoryItem.fromMap)
              .toList(),
    );
  }

  final UserProgressSummary summary;
  final List<UserWeeklyXpPoint> weeklyXp;
  final UserSkillScores skillScores;
  final List<UserSessionHistoryItem> sessionsHistory;
}

class UserProgressSummary {
  const UserProgressSummary({
    required this.level,
    required this.totalXp,
    required this.streakDays,
    required this.completedSessions,
    this.lastActiveDate,
  });

  factory UserProgressSummary.fromMap(Map<String, dynamic> map) {
    return UserProgressSummary(
      level: map['level'] as String? ?? 'A2',
      totalXp: (map['totalXp'] as num?)?.toInt() ?? 0,
      streakDays: (map['streakDays'] as num?)?.toInt() ?? 0,
      completedSessions: (map['completedSessions'] as num?)?.toInt() ?? 0,
      lastActiveDate: DateTime.tryParse(map['lastActiveDate'] as String? ?? ''),
    );
  }

  final String level;
  final int totalXp;
  final int streakDays;
  final int completedSessions;
  final DateTime? lastActiveDate;
}

class UserWeeklyXpPoint {
  const UserWeeklyXpPoint({required this.date, required this.xp});

  factory UserWeeklyXpPoint.fromMap(Map<String, dynamic> map) {
    return UserWeeklyXpPoint(
      date: map['date'] as String? ?? '',
      xp: (map['xp'] as num?)?.toInt() ?? 0,
    );
  }

  final String date;
  final int xp;
}

class UserSkillScores {
  const UserSkillScores({
    required this.grammar,
    required this.vocabulary,
    required this.naturalness,
  });

  factory UserSkillScores.fromMap(Map<String, dynamic> map) {
    return UserSkillScores(
      grammar: (map['grammar'] as num?)?.toInt() ?? 0,
      vocabulary: (map['vocabulary'] as num?)?.toInt() ?? 0,
      naturalness: (map['naturalness'] as num?)?.toInt() ?? 0,
    );
  }

  final int grammar;
  final int vocabulary;
  final int naturalness;
}

class UserSessionHistoryItem {
  const UserSessionHistoryItem({
    required this.id,
    required this.sourceType,
    required this.sceneTitle,
    required this.category,
    required this.difficulty,
    required this.xpEarned,
    required this.hintCount,
    required this.grammarScore,
    required this.vocabularyScore,
    required this.naturalnessScore,
    this.startedAt,
    this.endedAt,
  });

  factory UserSessionHistoryItem.fromMap(Map<String, dynamic> map) {
    final Map<String, dynamic> scores =
        map['scores'] as Map<String, dynamic>? ?? <String, dynamic>{};

    return UserSessionHistoryItem(
      id: map['id'] as String? ?? '',
      sourceType: map['sourceType'] as String? ?? 'CURATED_SCENE',
      sceneTitle: map['sceneTitle'] as String? ?? 'Practice session',
      category: map['category'] as String? ?? 'DAILY',
      difficulty: map['difficulty'] as String? ?? 'A2',
      startedAt: DateTime.tryParse(map['startedAt'] as String? ?? ''),
      endedAt: DateTime.tryParse(map['endedAt'] as String? ?? ''),
      xpEarned: (map['xpEarned'] as num?)?.toInt() ?? 0,
      hintCount: (map['hintCount'] as num?)?.toInt() ?? 0,
      grammarScore: (scores['grammar'] as num?)?.toInt() ?? 0,
      vocabularyScore: (scores['vocabulary'] as num?)?.toInt() ?? 0,
      naturalnessScore: (scores['naturalness'] as num?)?.toInt() ?? 0,
    );
  }

  final String id;
  final String sourceType;
  final String sceneTitle;
  final String category;
  final String difficulty;
  final DateTime? startedAt;
  final DateTime? endedAt;
  final int xpEarned;
  final int hintCount;
  final int grammarScore;
  final int vocabularyScore;
  final int naturalnessScore;

  int get averageScore {
    final List<int> values = <int>[
      grammarScore,
      vocabularyScore,
      naturalnessScore,
    ].where((int value) => value > 0).toList();

    if (values.isEmpty) return 0;
    final int total = values.reduce((int sum, int value) => sum + value);
    return (total / values.length).round();
  }
}
