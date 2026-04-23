import '../../domain/entities/scene_entity.dart';

class SceneApiModel {
  const SceneApiModel({
    required this.id,
    required this.title,
    required this.category,
    required this.description,
    required this.difficulty,
    required this.estimatedMinutes,
    required this.characterName,
    required this.characterRole,
    this.missionText,
    this.vocabulary = const <Map<String, dynamic>>[],
    this.starterPrompt,
  });

  factory SceneApiModel.fromMap(
    Map<String, dynamic> map, {
    String? starterPrompt,
  }) {
    return SceneApiModel(
      id: map['id'] as String? ?? '',
      title: map['title'] as String? ?? 'Untitled Scene',
      category: map['category'] as String? ?? 'DAILY',
      description: map['description'] as String? ?? '',
      difficulty: map['difficulty'] as String? ?? 'A2',
      estimatedMinutes: (map['estimatedMinutes'] as num?)?.toInt() ?? 6,
      characterName: map['characterName'] as String? ?? 'AI',
      characterRole: map['characterRole'] as String? ?? 'Conversation partner',
      missionText: map['missionText'] as String?,
      vocabulary: (map['vocabulary'] as List<dynamic>? ?? const <dynamic>[])
          .whereType<Map<String, dynamic>>()
          .toList(),
      starterPrompt: starterPrompt,
    );
  }

  final String id;
  final String title;
  final String category;
  final String description;
  final String difficulty;
  final int estimatedMinutes;
  final String characterName;
  final String characterRole;
  final String? missionText;
  final List<Map<String, dynamic>> vocabulary;
  final String? starterPrompt;

  SceneEntity toEntity() {
    return SceneEntity(
      id: id,
      title: title,
      category: mapSceneCategory(category),
      difficulty: mapSceneDifficulty(difficulty),
      estimatedMinutes: estimatedMinutes,
      characterName: characterName,
      characterRole: characterRole,
      description: description,
      mission: missionText ?? description,
      vocabularyPreview: vocabulary
          .map((Map<String, dynamic> item) => item['word'] as String? ?? '')
          .where((String word) => word.trim().isNotEmpty)
          .take(4)
          .toList(),
      starterPrompt: starterPrompt ?? '',
      aiReplyPool: buildFallbackAiReplyPool(
        characterName: characterName,
        characterRole: characterRole,
      ),
    );
  }
}

SceneCategory mapSceneCategory(String raw) {
  switch (raw.toUpperCase()) {
    case 'TRAVEL':
      return SceneCategory.travel;
    case 'WORK':
      return SceneCategory.work;
    case 'SOCIAL':
      return SceneCategory.social;
    case 'SERVICE':
      return SceneCategory.service;
    case 'DAILY':
    default:
      return SceneCategory.dailyLife;
  }
}

SceneDifficulty mapSceneDifficulty(String raw) {
  switch (raw.toUpperCase()) {
    case 'A1':
      return SceneDifficulty.a1;
    case 'B1':
      return SceneDifficulty.b1;
    case 'B2':
      return SceneDifficulty.b2;
    case 'A2':
    default:
      return SceneDifficulty.a2;
  }
}

List<String> buildFallbackAiReplyPool({
  required String characterName,
  required String characterRole,
}) {
  return <String>[
    'Thanks. Could you tell me a little more?',
    'That makes sense. What would you say next in this situation?',
    'Great. Let’s wrap this up naturally.',
  ];
}
