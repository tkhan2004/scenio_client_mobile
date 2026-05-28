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
      isHint: false,
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
    this.spokenCoaching,
    this.nextLearningAction,
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
    final Map<String, dynamic>? spokenCoachingMap =
        map['spokenCoaching'] as Map<String, dynamic>?;
    final Map<String, dynamic>? nextLearningActionMap =
        map['nextLearningAction'] as Map<String, dynamic>?;
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
                isHint: item['isHint'] as bool? ?? false,
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
      spokenCoaching: spokenCoachingMap == null
          ? null
          : SessionSpokenCoachingModel.fromMap(spokenCoachingMap),
      nextLearningAction: nextLearningActionMap == null
          ? null
          : SessionNextLearningActionModel.fromMap(nextLearningActionMap),
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
  final SessionSpokenCoachingModel? spokenCoaching;
  final SessionNextLearningActionModel? nextLearningAction;

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
      spokenCoaching: spokenCoaching?.toEntity(),
      nextLearningAction: nextLearningAction?.toEntity(),
    );
  }
}

class SessionSpokenCoachingModel {
  const SessionSpokenCoachingModel({
    required this.available,
    required this.mode,
    required this.summary,
    required this.expressionScore,
    required this.clarityScore,
    required this.confidenceScore,
    required this.strengths,
    required this.improvements,
    required this.turnHighlights,
    required this.note,
  });

  factory SessionSpokenCoachingModel.fromMap(Map<String, dynamic> map) {
    final Map<String, dynamic> scoresMap =
        map['scores'] as Map<String, dynamic>? ?? <String, dynamic>{};

    return SessionSpokenCoachingModel(
      available: map['available'] as bool? ?? false,
      mode: map['mode'] as String? ?? 'TRANSCRIPT_BASED',
      summary: map['summary'] as String? ?? '',
      expressionScore: (scoresMap['expression'] as num?)?.toInt() ?? 0,
      clarityScore: (scoresMap['clarity'] as num?)?.toInt() ?? 0,
      confidenceScore: (scoresMap['confidence'] as num?)?.toInt() ?? 0,
      strengths: (map['strengths'] as List<dynamic>? ?? const <dynamic>[])
          .whereType<String>()
          .toList(growable: false),
      improvements: (map['improvements'] as List<dynamic>? ?? const <dynamic>[])
          .whereType<String>()
          .toList(growable: false),
      turnHighlights:
          (map['turnHighlights'] as List<dynamic>? ?? const <dynamic>[])
              .whereType<Map<String, dynamic>>()
              .map<SessionTurnHighlightModel>(SessionTurnHighlightModel.fromMap)
              .toList(growable: false),
      note: map['note'] as String? ?? '',
    );
  }

  final bool available;
  final String mode;
  final String summary;
  final int expressionScore;
  final int clarityScore;
  final int confidenceScore;
  final List<String> strengths;
  final List<String> improvements;
  final List<SessionTurnHighlightModel> turnHighlights;
  final String note;

  SessionSpokenCoachingEntity toEntity() {
    return SessionSpokenCoachingEntity(
      available: available,
      mode: mode,
      summary: summary,
      expressionScore: expressionScore,
      clarityScore: clarityScore,
      confidenceScore: confidenceScore,
      strengths: strengths,
      improvements: improvements,
      turnHighlights: turnHighlights
          .map((SessionTurnHighlightModel item) => item.toEntity())
          .toList(growable: false),
      note: note,
    );
  }
}

class SessionTurnHighlightModel {
  const SessionTurnHighlightModel({
    required this.messageId,
    required this.turnIndex,
    required this.content,
    required this.status,
    required this.focus,
    required this.note,
    this.suggestion,
  });

  factory SessionTurnHighlightModel.fromMap(Map<String, dynamic> map) {
    return SessionTurnHighlightModel(
      messageId: map['messageId'] as String? ?? '',
      turnIndex: (map['turnIndex'] as num?)?.toInt() ?? 0,
      content: map['content'] as String? ?? '',
      status: map['status'] as String? ?? 'NEEDS_WORK',
      focus: map['focus'] as String? ?? 'NATURALNESS',
      note: map['note'] as String? ?? '',
      suggestion: map['suggestion'] as String?,
    );
  }

  final String messageId;
  final int turnIndex;
  final String content;
  final String status;
  final String focus;
  final String note;
  final String? suggestion;

  SessionTurnHighlightEntity toEntity() {
    return SessionTurnHighlightEntity(
      messageId: messageId,
      turnIndex: turnIndex,
      content: content,
      status: status,
      focus: focus,
      note: note,
      suggestion: suggestion,
    );
  }
}

class SessionNextLearningActionModel {
  const SessionNextLearningActionModel({
    required this.type,
    required this.focus,
    required this.title,
    required this.reason,
    required this.ctaLabel,
    required this.suggestedSceneQuery,
  });

  factory SessionNextLearningActionModel.fromMap(Map<String, dynamic> map) {
    return SessionNextLearningActionModel(
      type: map['type'] as String? ?? '',
      focus: map['focus'] as String? ?? '',
      title: map['title'] as String? ?? '',
      reason: map['reason'] as String? ?? '',
      ctaLabel: map['ctaLabel'] as String? ?? '',
      suggestedSceneQuery: map['suggestedSceneQuery'] as String? ?? '',
    );
  }

  final String type;
  final String focus;
  final String title;
  final String reason;
  final String ctaLabel;
  final String suggestedSceneQuery;

  SessionNextLearningActionEntity toEntity() {
    return SessionNextLearningActionEntity(
      type: type,
      focus: focus,
      title: title,
      reason: reason,
      ctaLabel: ctaLabel,
      suggestedSceneQuery: suggestedSceneQuery,
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
