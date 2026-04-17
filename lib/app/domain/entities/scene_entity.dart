enum SceneCategory { dailyLife, travel, work, service }

enum SceneDifficulty { a1, a2, b1 }

extension SceneCategoryX on SceneCategory {
  String get label {
    switch (this) {
      case SceneCategory.dailyLife:
        return 'Daily life';
      case SceneCategory.travel:
        return 'Travel';
      case SceneCategory.work:
        return 'Work';
      case SceneCategory.service:
        return 'Service';
    }
  }
}

extension SceneDifficultyX on SceneDifficulty {
  String get label {
    switch (this) {
      case SceneDifficulty.a1:
        return 'A1';
      case SceneDifficulty.a2:
        return 'A2';
      case SceneDifficulty.b1:
        return 'B1';
    }
  }
}

class SceneEntity {
  const SceneEntity({
    required this.id,
    required this.title,
    required this.category,
    required this.difficulty,
    required this.estimatedMinutes,
    required this.characterName,
    required this.characterRole,
    required this.description,
    required this.mission,
    required this.vocabularyPreview,
    required this.starterPrompt,
    required this.aiReplyPool,
  });

  final String id;
  final String title;
  final SceneCategory category;
  final SceneDifficulty difficulty;
  final int estimatedMinutes;
  final String characterName;
  final String characterRole;
  final String description;
  final String mission;
  final List<String> vocabularyPreview;
  final String starterPrompt;
  final List<String> aiReplyPool;

  String get categoryLabel => category.label;
  String get difficultyLabel => difficulty.label;

  String get characterInitials {
    final List<String> parts = characterName
        .split(' ')
        .where((String part) => part.trim().isNotEmpty)
        .toList();
    if (parts.isEmpty) return 'AI';
    if (parts.length == 1) return parts.first.substring(0, 1).toUpperCase();
    return '${parts.first.substring(0, 1)}${parts.last.substring(0, 1)}'
        .toUpperCase();
  }
}
