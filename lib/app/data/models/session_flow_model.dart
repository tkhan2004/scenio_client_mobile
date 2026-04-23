import '../../domain/entities/message_entity.dart';
import '../../domain/entities/session_entity.dart';
import '../../domain/entities/scene_entity.dart';

class SessionStartModel {
  const SessionStartModel({
    required this.sessionId,
    required this.openingMessage,
    required this.modality,
    required this.selectedVoiceName,
    required this.voiceSelectionSource,
  });

  factory SessionStartModel.fromMap(Map<String, dynamic> map) {
    final Map<String, dynamic> voiceMap =
        map['selectedVoice'] as Map<String, dynamic>? ?? <String, dynamic>{};
    final Map<String, dynamic> selectionMap =
        map['voiceSelection'] as Map<String, dynamic>? ?? <String, dynamic>{};

    return SessionStartModel(
      sessionId: map['sessionId'] as String? ?? '',
      openingMessage: map['openingMessage'] as String? ?? '',
      modality: map['modality'] as String? ?? 'TEXT',
      selectedVoiceName: voiceMap['displayName'] as String?,
      voiceSelectionSource: selectionMap['source'] as String?,
    );
  }

  final String sessionId;
  final String openingMessage;
  final String modality;
  final String? selectedVoiceName;
  final String? voiceSelectionSource;

  SessionEntity toSessionEntity(SceneEntity scene) {
    return SessionEntity(
      id: sessionId,
      sceneId: scene.id,
      sceneTitle: scene.title,
      characterName: scene.characterName,
      characterRole: scene.characterRole,
      difficultyLabel: scene.difficultyLabel,
      mission: scene.mission,
      startedAt: DateTime.now(),
      status: SessionStatus.active,
      completedTurns: 0,
      targetTurns: 3,
    );
  }

  MessageEntity toOpeningMessage() {
    return MessageEntity(
      id: '$sessionId-opening',
      sessionId: sessionId,
      author: MessageAuthor.ai,
      text: openingMessage,
      createdAt: DateTime.now(),
    );
  }
}

class SessionResultModel {
  const SessionResultModel({
    required this.sessionId,
    required this.sceneId,
    required this.sceneTitle,
    required this.characterName,
    required this.xpEarned,
    required this.grammarScore,
    required this.vocabularyScore,
    required this.naturalnessScore,
    required this.transcript,
  });

  factory SessionResultModel.fromMap(
    Map<String, dynamic> map, {
    required String fallbackSceneId,
    required int fallbackTargetTurns,
  }) {
    final Map<String, dynamic> sessionMap =
        map['session'] as Map<String, dynamic>? ?? <String, dynamic>{};
    final Map<String, dynamic> sourceSummaryMap =
        sessionMap['sourceSummary'] as Map<String, dynamic>? ??
        <String, dynamic>{};
    final Map<String, dynamic> scoresMap =
        map['scores'] as Map<String, dynamic>? ?? <String, dynamic>{};
    final List<MessageEntity> transcript =
        (map['messages'] as List<dynamic>? ?? const <dynamic>[])
            .whereType<Map<String, dynamic>>()
            .map<MessageEntity>((Map<String, dynamic> item) {
              return MessageEntity(
                id: item['id'] as String? ?? '',
                sessionId: sessionMap['id'] as String? ?? '',
                author: _mapMessageAuthor(item['role'] as String? ?? 'AI'),
                text: item['content'] as String? ?? '',
                createdAt:
                    DateTime.tryParse(item['createdAt'] as String? ?? '') ??
                    DateTime.now(),
              );
            })
            .toList();

    return SessionResultModel(
      sessionId: sessionMap['id'] as String? ?? '',
      sceneId:
          (sessionMap['scene'] as Map<String, dynamic>? ??
                  <String, dynamic>{})['id']
              as String? ??
          fallbackSceneId,
      sceneTitle: sourceSummaryMap['title'] as String? ?? 'Practice Session',
      characterName: sourceSummaryMap['characterName'] as String? ?? 'AI',
      xpEarned: (sessionMap['xpEarned'] as num?)?.toInt() ?? 0,
      grammarScore: (scoresMap['grammar'] as num?)?.toInt() ?? 0,
      vocabularyScore: (scoresMap['vocabulary'] as num?)?.toInt() ?? 0,
      naturalnessScore: (scoresMap['naturalness'] as num?)?.toInt() ?? 0,
      transcript: transcript,
    );
  }

  final String sessionId;
  final String sceneId;
  final String sceneTitle;
  final String characterName;
  final int xpEarned;
  final int grammarScore;
  final int vocabularyScore;
  final int naturalnessScore;
  final List<MessageEntity> transcript;

  SessionResultEntity toEntity({
    required int completedTurns,
    required int targetTurns,
  }) {
    return SessionResultEntity(
      sessionId: sessionId,
      sceneId: sceneId,
      sceneTitle: sceneTitle,
      characterName: characterName,
      xpEarned: xpEarned,
      grammarScore: grammarScore,
      vocabularyScore: vocabularyScore,
      naturalnessScore: naturalnessScore,
      completedTurns: completedTurns,
      targetTurns: targetTurns,
      transcript: transcript,
    );
  }
}

MessageAuthor _mapMessageAuthor(String raw) {
  switch (raw.toUpperCase()) {
    case 'USER':
      return MessageAuthor.user;
    case 'SYSTEM':
      return MessageAuthor.system;
    case 'AI':
    default:
      return MessageAuthor.ai;
  }
}
