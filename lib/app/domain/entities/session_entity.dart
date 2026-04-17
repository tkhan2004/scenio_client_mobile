import 'message_entity.dart';

enum SessionStatus { active, completed, abandoned }

enum PracticeRealtimeState {
  idle,
  starting,
  active,
  userTyping,
  userListening,
  aiThinking,
  aiSpeaking,
  paused,
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
}
