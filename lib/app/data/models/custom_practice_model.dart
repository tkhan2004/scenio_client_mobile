import '../../domain/entities/message_entity.dart';
import '../../domain/entities/scene_entity.dart';
import '../../domain/entities/session_entity.dart';
import 'scene_api_model.dart';

class CustomPracticeDraft {
  const CustomPracticeDraft({
    required this.practiceGoal,
    required this.successOutcome,
    required this.topicSummary,
    required this.contextType,
    required this.location,
    required this.conversationChannel,
    required this.userRole,
    required this.userIntent,
    required this.aiRole,
    required this.aiDisplayName,
    required this.aiBehaviorStyle,
    required this.aiPrimaryGoal,
    required this.aiGenderPresentation,
    required this.aiVoiceTone,
    required this.aiAccentPreference,
    required this.difficulty,
    required this.conversationLength,
    required this.targetMinutes,
    required this.customInstructions,
    this.specialConditions = const <String>[],
  });

  final String practiceGoal;
  final String successOutcome;
  final String topicSummary;
  final String contextType;
  final String location;
  final String conversationChannel;
  final String userRole;
  final String userIntent;
  final String aiRole;
  final String aiDisplayName;
  final String aiBehaviorStyle;
  final String aiPrimaryGoal;
  final String aiGenderPresentation;
  final String aiVoiceTone;
  final String aiAccentPreference;
  final String difficulty;
  final String conversationLength;
  final int targetMinutes;
  final String customInstructions;
  final List<String> specialConditions;

  Map<String, dynamic> toRequestMap() {
    return _withoutNullValues(<String, dynamic>{
      'practiceGoal': practiceGoal.trim(),
      'successOutcome': successOutcome.trim().isEmpty
          ? null
          : successOutcome.trim(),
      'topicSummary': topicSummary.trim(),
      'context': <String, dynamic>{
        'contextType': contextType,
        'location': location.trim().isEmpty ? null : location.trim(),
        'conversationChannel': conversationChannel,
        'specialConditions': specialConditions
            .where((String item) => item.trim().isNotEmpty)
            .map((String item) => item.trim())
            .toList(),
      },
      'userProfile': <String, dynamic>{
        'userRole': userRole.trim(),
        'userIntent': userIntent.trim().isEmpty ? null : userIntent.trim(),
        'userEnglishLevel': difficulty,
      },
      'aiPersona': <String, dynamic>{
        'aiRole': aiRole.trim(),
        'aiDisplayName': aiDisplayName.trim(),
        'aiPrimaryGoal': aiPrimaryGoal.trim().isEmpty
            ? null
            : aiPrimaryGoal.trim(),
        'aiBehaviorStyle': aiBehaviorStyle.trim().isEmpty
            ? null
            : aiBehaviorStyle.trim(),
        'aiGenderPresentation': aiGenderPresentation,
        'aiVoiceTone': aiVoiceTone,
        'aiAccentPreference': aiAccentPreference.trim().isEmpty
            ? null
            : aiAccentPreference.trim(),
      },
      'learningConfig': <String, dynamic>{
        'difficulty': difficulty,
        'conversationLength': conversationLength,
        'targetMinutes': targetMinutes,
        'correctionStyle': 'END_ONLY',
        'hintFrequency': 'LOW',
        'responseComplexity': 'BALANCED',
        'focusSkills': const <String>[],
        'mustUseVocabulary': const <String>[],
        'avoidTopics': const <String>[],
        'customInstructions': customInstructions.trim().isEmpty
            ? null
            : customInstructions.trim(),
      },
      'modality': 'TEXT',
    });
  }
}

Map<String, dynamic> _withoutNullValues(Map<String, dynamic> map) {
  final Map<String, dynamic> sanitized = <String, dynamic>{};

  map.forEach((String key, dynamic value) {
    if (value == null) {
      return;
    }

    if (value is Map<String, dynamic>) {
      sanitized[key] = _withoutNullValues(value);
      return;
    }

    if (value is List<dynamic>) {
      sanitized[key] = value
          .map<dynamic>((dynamic item) {
            if (item is Map<String, dynamic>) {
              return _withoutNullValues(item);
            }
            return item;
          })
          .where((dynamic item) => item != null)
          .toList();
      return;
    }

    sanitized[key] = value;
  });

  return sanitized;
}

class CustomPracticeStartModel {
  const CustomPracticeStartModel({
    required this.sessionId,
    required this.openingMessage,
    required this.targetTurns,
    required this.displayTitle,
    required this.displaySubtitle,
    required this.missionText,
    required this.difficulty,
    required this.conversationLength,
    required this.aiDisplayName,
    required this.aiRole,
    required this.contextType,
    required this.topicSummary,
    required this.estimatedMinutes,
  });

  factory CustomPracticeStartModel.fromMap(Map<String, dynamic> map) {
    final Map<String, dynamic> customMap =
        map['customPractice'] as Map<String, dynamic>? ?? <String, dynamic>{};
    final Map<String, dynamic> aiPersonaMap =
        customMap['aiPersona'] as Map<String, dynamic>? ?? <String, dynamic>{};

    return CustomPracticeStartModel(
      sessionId: map['sessionId'] as String? ?? '',
      openingMessage: map['openingMessage'] as String? ?? '',
      targetTurns: (map['targetTurns'] as num?)?.toInt() ?? 5,
      displayTitle: customMap['displayTitle'] as String? ?? 'Custom Practice',
      displaySubtitle:
          customMap['displaySubtitle'] as String? ??
          'A focused session built from your goal.',
      missionText: customMap['missionText'] as String? ?? '',
      difficulty: customMap['difficulty'] as String? ?? 'A2',
      conversationLength:
          customMap['conversationLength'] as String? ?? 'MEDIUM',
      aiDisplayName: aiPersonaMap['displayName'] as String? ?? 'AI',
      aiRole: aiPersonaMap['role'] as String? ?? 'Conversation partner',
      contextType: customMap['contextType'] as String? ?? 'OTHER',
      topicSummary: customMap['topicSummary'] as String? ?? '',
      estimatedMinutes: (customMap['estimatedMinutes'] as num?)?.toInt() ?? 8,
    );
  }

  final String sessionId;
  final String openingMessage;
  final int targetTurns;
  final String displayTitle;
  final String displaySubtitle;
  final String missionText;
  final String difficulty;
  final String conversationLength;
  final String aiDisplayName;
  final String aiRole;
  final String contextType;
  final String topicSummary;
  final int estimatedMinutes;

  SceneEntity toSyntheticScene() {
    return SceneEntity(
      id: 'custom-$sessionId',
      title: displayTitle,
      category: _mapContextTypeToSceneCategory(contextType),
      difficulty: mapSceneDifficulty(difficulty),
      estimatedMinutes: estimatedMinutes,
      characterName: aiDisplayName,
      characterRole: aiRole,
      description: topicSummary.isEmpty ? displaySubtitle : topicSummary,
      mission: missionText.isEmpty ? displaySubtitle : missionText,
      vocabularyPreview: const <String>[],
      starterPrompt: openingMessage,
      aiReplyPool: buildFallbackAiReplyPool(
        characterName: aiDisplayName,
        characterRole: aiRole,
      ),
    );
  }

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
      targetTurns: targetTurns,
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

SceneCategory _mapContextTypeToSceneCategory(String raw) {
  switch (raw.toUpperCase()) {
    case 'INTERVIEW':
    case 'WORK':
      return SceneCategory.work;
    case 'TRAVEL':
      return SceneCategory.travel;
    case 'CUSTOMER_SERVICE':
    case 'MEDICAL':
      return SceneCategory.service;
    case 'SOCIAL':
      return SceneCategory.social;
    case 'PHONE_CALL':
    case 'OTHER':
    default:
      return SceneCategory.dailyLife;
  }
}
