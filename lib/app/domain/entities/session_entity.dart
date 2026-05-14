import 'message_entity.dart';

enum SessionStatus { active, completed, abandoned }

enum PracticeRealtimeState {
  idle,
  starting,
  requestingPermission,
  connecting,
  active,
  userTyping,
  userListening,
  userSpeaking,
  aiThinking,
  aiSpeaking,
  reconnecting,
  paused,
  finishing,
  completed,
  error,
}

class SessionEntity {
  const SessionEntity({
    required this.id,
    required this.sceneId,
    required this.sceneTitle,
    required this.characterName,
    required this.characterRole,
    required this.difficultyLabel,
    required this.mission,
    required this.startedAt,
    required this.status,
    required this.completedTurns,
    required this.targetTurns,
  });

  final String id;
  final String sceneId;
  final String sceneTitle;
  final String characterName;
  final String characterRole;
  final String difficultyLabel;
  final String mission;
  final DateTime startedAt;
  final SessionStatus status;
  final int completedTurns;
  final int targetTurns;

  SessionEntity copyWith({
    String? id,
    String? sceneId,
    String? sceneTitle,
    String? characterName,
    String? characterRole,
    String? difficultyLabel,
    String? mission,
    DateTime? startedAt,
    SessionStatus? status,
    int? completedTurns,
    int? targetTurns,
  }) {
    return SessionEntity(
      id: id ?? this.id,
      sceneId: sceneId ?? this.sceneId,
      sceneTitle: sceneTitle ?? this.sceneTitle,
      characterName: characterName ?? this.characterName,
      characterRole: characterRole ?? this.characterRole,
      difficultyLabel: difficultyLabel ?? this.difficultyLabel,
      mission: mission ?? this.mission,
      startedAt: startedAt ?? this.startedAt,
      status: status ?? this.status,
      completedTurns: completedTurns ?? this.completedTurns,
      targetTurns: targetTurns ?? this.targetTurns,
    );
  }
}

class SessionResultEntity {
  const SessionResultEntity({
    required this.sessionId,
    required this.sceneId,
    required this.sceneTitle,
    required this.characterName,
    required this.xpEarned,
    required this.grammarScore,
    required this.vocabularyScore,
    required this.naturalnessScore,
    required this.completedTurns,
    required this.targetTurns,
    required this.transcript,
    this.spokenCoaching,
    this.nextLearningAction,
  });

  final String sessionId;
  final String sceneId;
  final String sceneTitle;
  final String characterName;
  final int xpEarned;
  final int grammarScore;
  final int vocabularyScore;
  final int naturalnessScore;
  final int completedTurns;
  final int targetTurns;
  final List<MessageEntity> transcript;
  final SessionSpokenCoachingEntity? spokenCoaching;
  final SessionNextLearningActionEntity? nextLearningAction;
}

class SessionSpokenCoachingEntity {
  const SessionSpokenCoachingEntity({
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

  final bool available;
  final String mode;
  final String summary;
  final int expressionScore;
  final int clarityScore;
  final int confidenceScore;
  final List<String> strengths;
  final List<String> improvements;
  final List<SessionTurnHighlightEntity> turnHighlights;
  final String note;
}

class SessionTurnHighlightEntity {
  const SessionTurnHighlightEntity({
    required this.messageId,
    required this.turnIndex,
    required this.content,
    required this.status,
    required this.focus,
    required this.note,
    this.suggestion,
  });

  final String messageId;
  final int turnIndex;
  final String content;
  final String status;
  final String focus;
  final String note;
  final String? suggestion;

  bool get isPositive => status.toUpperCase() == 'GOOD';
}

class SessionNextLearningActionEntity {
  const SessionNextLearningActionEntity({
    required this.type,
    required this.focus,
    required this.title,
    required this.reason,
    required this.ctaLabel,
    required this.suggestedSceneQuery,
  });

  final String type;
  final String focus;
  final String title;
  final String reason;
  final String ctaLabel;
  final String suggestedSceneQuery;
}
