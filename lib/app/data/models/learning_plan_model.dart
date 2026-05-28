import '../../domain/entities/scene_entity.dart';
import 'scene_api_model.dart';

class LearningPlanResponseModel {
  const LearningPlanResponseModel({
    required this.plan,
    required this.steps,
    this.nextStep,
    this.completionSummary,
  });

  factory LearningPlanResponseModel.fromMap(Map<String, dynamic> map) {
    return LearningPlanResponseModel(
      plan: LearningPlanModel.fromMap(
        map['plan'] as Map<String, dynamic>? ?? <String, dynamic>{},
      ),
      steps: (map['steps'] as List<dynamic>? ?? const <dynamic>[])
          .whereType<Map<String, dynamic>>()
          .map(LearningPlanStepModel.fromMap)
          .toList(),
      nextStep: map['nextStep'] is Map<String, dynamic>
          ? LearningPlanNextStepModel.fromMap(
              map['nextStep'] as Map<String, dynamic>,
            )
          : null,
      completionSummary: map['completionSummary'] is Map<String, dynamic>
          ? RoadmapCompletionSummaryModel.fromMap(
              map['completionSummary'] as Map<String, dynamic>,
            )
          : null,
    );
  }

  final LearningPlanModel plan;
  final List<LearningPlanStepModel> steps;
  final LearningPlanNextStepModel? nextStep;
  final RoadmapCompletionSummaryModel? completionSummary;

  int get completedSteps => steps
      .where((LearningPlanStepModel step) => step.status == 'COMPLETED')
      .length;

  int get totalSteps => steps.length;

  double get progress => totalSteps == 0 ? 0 : completedSteps / totalSteps;
}

class LearningPlanModel {
  const LearningPlanModel({
    required this.id,
    required this.status,
    required this.derivedState,
    required this.title,
    required this.summary,
    required this.level,
    required this.focusSkill,
    required this.weeklyTarget,
    required this.completionCriteria,
    required this.reward,
    required this.schedule,
    this.learningGoal,
    this.studyFrequency,
    this.targetOutcome,
  });

  factory LearningPlanModel.fromMap(Map<String, dynamic> map) {
    return LearningPlanModel(
      id: map['id'] as String? ?? '',
      status: map['status'] as String? ?? 'ACTIVE',
      derivedState: map['derivedState'] as String? ?? 'IN_PROGRESS',
      title: map['title'] as String? ?? 'Your Learning Plan',
      summary: map['summary'] as String? ?? '',
      level: map['level'] as String? ?? 'A2',
      learningGoal: map['learningGoal'] as String?,
      studyFrequency: map['studyFrequency'] as String?,
      focusSkill: map['focusSkill'] as String? ?? 'NATURALNESS',
      weeklyTarget: (map['weeklyTarget'] as num?)?.toInt() ?? 3,
      targetOutcome: map['targetOutcome'] as String?,
      completionCriteria: LearningPlanCompletionCriteriaModel.fromMap(
        map['completionCriteria'] as Map<String, dynamic>? ??
            <String, dynamic>{},
      ),
      reward: LearningPlanRewardModel.fromMap(
        map['reward'] as Map<String, dynamic>? ?? <String, dynamic>{},
      ),
      schedule: LearningPlanScheduleModel.fromMap(
        map['schedule'] as Map<String, dynamic>? ?? <String, dynamic>{},
      ),
    );
  }

  final String id;
  final String status;
  final String derivedState;
  final String title;
  final String summary;
  final String level;
  final String? learningGoal;
  final String? studyFrequency;
  final String focusSkill;
  final int weeklyTarget;
  final String? targetOutcome;
  final LearningPlanCompletionCriteriaModel completionCriteria;
  final LearningPlanRewardModel reward;
  final LearningPlanScheduleModel schedule;

  bool get isCompleted => status == 'COMPLETED' || derivedState == 'COMPLETED';
}

class LearningPlanCompletionCriteriaModel {
  const LearningPlanCompletionCriteriaModel({
    required this.requiredSteps,
    required this.requiredCoreScenes,
    required this.minimumRecentAverageScore,
  });

  factory LearningPlanCompletionCriteriaModel.fromMap(
    Map<String, dynamic> map,
  ) {
    return LearningPlanCompletionCriteriaModel(
      requiredSteps: (map['requiredSteps'] as num?)?.toInt() ?? 0,
      requiredCoreScenes: (map['requiredCoreScenes'] as num?)?.toInt() ?? 0,
      minimumRecentAverageScore:
          (map['minimumRecentAverageScore'] as num?)?.toInt() ?? 70,
    );
  }

  final int requiredSteps;
  final int requiredCoreScenes;
  final int minimumRecentAverageScore;
}

class LearningPlanRewardModel {
  const LearningPlanRewardModel({
    required this.badgeTitle,
    required this.xpBonus,
    required this.unlocks,
  });

  factory LearningPlanRewardModel.fromMap(Map<String, dynamic> map) {
    return LearningPlanRewardModel(
      badgeTitle: map['badgeTitle'] as String? ?? '',
      xpBonus: (map['xpBonus'] as num?)?.toInt() ?? 0,
      unlocks: (map['unlocks'] as List<dynamic>? ?? const <dynamic>[])
          .whereType<String>()
          .toList(growable: false),
    );
  }

  final String badgeTitle;
  final int xpBonus;
  final List<String> unlocks;
}

class LearningPlanScheduleModel {
  const LearningPlanScheduleModel({
    required this.suggestedDays,
    this.nextSuggestedAt,
  });

  factory LearningPlanScheduleModel.fromMap(Map<String, dynamic> map) {
    return LearningPlanScheduleModel(
      suggestedDays:
          (map['suggestedDays'] as List<dynamic>? ?? const <dynamic>[])
              .whereType<String>()
              .toList(growable: false),
      nextSuggestedAt: DateTime.tryParse(
        map['nextSuggestedAt'] as String? ?? '',
      ),
    );
  }

  final List<String> suggestedDays;
  final DateTime? nextSuggestedAt;
}

class LearningPlanStepModel {
  const LearningPlanStepModel({
    required this.id,
    required this.type,
    required this.status,
    required this.focusSkill,
    required this.title,
    required this.sortOrder,
    required this.targetCount,
    required this.completedCount,
    this.sceneId,
    this.description,
    this.reason,
    this.scene,
  });

  factory LearningPlanStepModel.fromMap(Map<String, dynamic> map) {
    return LearningPlanStepModel(
      id: map['id'] as String? ?? '',
      type: map['type'] as String? ?? 'SCENE',
      status: map['status'] as String? ?? 'LOCKED',
      focusSkill: map['focusSkill'] as String? ?? 'NATURALNESS',
      sceneId: map['sceneId'] as String?,
      title: map['title'] as String? ?? 'Learning step',
      description: map['description'] as String?,
      reason: map['reason'] as String?,
      sortOrder: (map['sortOrder'] as num?)?.toInt() ?? 0,
      targetCount: (map['targetCount'] as num?)?.toInt() ?? 1,
      completedCount: (map['completedCount'] as num?)?.toInt() ?? 0,
      scene: map['scene'] is Map<String, dynamic>
          ? SceneApiModel.fromMap(
              map['scene'] as Map<String, dynamic>,
            ).toEntity()
          : null,
    );
  }

  final String id;
  final String type;
  final String status;
  final String focusSkill;
  final String? sceneId;
  final String title;
  final String? description;
  final String? reason;
  final int sortOrder;
  final int targetCount;
  final int completedCount;
  final SceneEntity? scene;
}

class LearningPlanNextStepModel {
  const LearningPlanNextStepModel({
    required this.id,
    required this.type,
    required this.title,
    required this.focusSkill,
    this.sceneId,
  });

  factory LearningPlanNextStepModel.fromMap(Map<String, dynamic> map) {
    return LearningPlanNextStepModel(
      id: map['id'] as String? ?? '',
      type: map['type'] as String? ?? 'SCENE',
      sceneId: map['sceneId'] as String?,
      title: map['title'] as String? ?? 'Next learning step',
      focusSkill: map['focusSkill'] as String? ?? 'NATURALNESS',
    );
  }

  final String id;
  final String type;
  final String? sceneId;
  final String title;
  final String focusSkill;
}

class RoadmapCompletionSummaryModel {
  const RoadmapCompletionSummaryModel({
    required this.planId,
    required this.title,
    required this.level,
    required this.completedScenes,
    required this.scoreDelta,
    required this.reward,
    this.completedAt,
    this.nextRoadmap,
  });

  factory RoadmapCompletionSummaryModel.fromMap(Map<String, dynamic> map) {
    return RoadmapCompletionSummaryModel(
      planId: map['planId'] as String? ?? '',
      title: map['title'] as String? ?? 'Roadmap completed',
      level: map['level'] as String? ?? 'A2',
      completedAt: DateTime.tryParse(map['completedAt'] as String? ?? ''),
      completedScenes:
          (map['completedScenes'] as List<dynamic>? ?? const <dynamic>[])
              .whereType<String>()
              .toList(growable: false),
      scoreDelta: RoadmapScoreDeltaModel.fromMap(
        map['scoreDelta'] as Map<String, dynamic>? ?? <String, dynamic>{},
      ),
      reward: RoadmapCompletionRewardModel.fromMap(
        map['reward'] as Map<String, dynamic>? ?? <String, dynamic>{},
      ),
      nextRoadmap: map['nextRoadmap'] is Map<String, dynamic>
          ? RoadmapNextRoadmapModel.fromMap(
              map['nextRoadmap'] as Map<String, dynamic>,
            )
          : null,
    );
  }

  final String planId;
  final String title;
  final String level;
  final DateTime? completedAt;
  final List<String> completedScenes;
  final RoadmapScoreDeltaModel scoreDelta;
  final RoadmapCompletionRewardModel reward;
  final RoadmapNextRoadmapModel? nextRoadmap;
}

class RoadmapScoreDeltaModel {
  const RoadmapScoreDeltaModel({
    required this.grammar,
    required this.vocabulary,
    required this.naturalness,
  });

  factory RoadmapScoreDeltaModel.fromMap(Map<String, dynamic> map) {
    return RoadmapScoreDeltaModel(
      grammar: RoadmapSkillDeltaModel.fromMap(
        map['grammar'] as Map<String, dynamic>? ?? <String, dynamic>{},
      ),
      vocabulary: RoadmapSkillDeltaModel.fromMap(
        map['vocabulary'] as Map<String, dynamic>? ?? <String, dynamic>{},
      ),
      naturalness: RoadmapSkillDeltaModel.fromMap(
        map['naturalness'] as Map<String, dynamic>? ?? <String, dynamic>{},
      ),
    );
  }

  final RoadmapSkillDeltaModel grammar;
  final RoadmapSkillDeltaModel vocabulary;
  final RoadmapSkillDeltaModel naturalness;
}

class RoadmapSkillDeltaModel {
  const RoadmapSkillDeltaModel({required this.before, required this.after});

  factory RoadmapSkillDeltaModel.fromMap(Map<String, dynamic> map) {
    return RoadmapSkillDeltaModel(
      before: (map['before'] as num?)?.toInt() ?? 0,
      after: (map['after'] as num?)?.toInt() ?? 0,
    );
  }

  final int before;
  final int after;
}

class RoadmapCompletionRewardModel {
  const RoadmapCompletionRewardModel({
    required this.badgeTitle,
    required this.xpBonus,
  });

  factory RoadmapCompletionRewardModel.fromMap(Map<String, dynamic> map) {
    return RoadmapCompletionRewardModel(
      badgeTitle: map['badgeTitle'] as String? ?? '',
      xpBonus: (map['xpBonus'] as num?)?.toInt() ?? 0,
    );
  }

  final String badgeTitle;
  final int xpBonus;
}

class RoadmapNextRoadmapModel {
  const RoadmapNextRoadmapModel({
    required this.title,
    required this.level,
    required this.focusSkill,
  });

  factory RoadmapNextRoadmapModel.fromMap(Map<String, dynamic> map) {
    return RoadmapNextRoadmapModel(
      title: map['title'] as String? ?? 'Next roadmap',
      level: map['level'] as String? ?? 'A2',
      focusSkill: map['focusSkill'] as String? ?? 'NATURALNESS',
    );
  }

  final String title;
  final String level;
  final String focusSkill;
}

class StartNextRoadmapModel {
  const StartNextRoadmapModel({
    required this.previousPlanId,
    this.completionSummary,
    this.nextPlan,
  });

  factory StartNextRoadmapModel.fromMap(Map<String, dynamic> map) {
    final Object? nextPlanMap = map['nextPlan'] ?? map['learningPlan'];
    final bool responseLooksLikePlan =
        map['plan'] is Map<String, dynamic> && map['steps'] is List<dynamic>;
    return StartNextRoadmapModel(
      previousPlanId: map['previousPlanId'] as String? ?? '',
      completionSummary: map['completionSummary'] is Map<String, dynamic>
          ? RoadmapCompletionSummaryModel.fromMap(
              map['completionSummary'] as Map<String, dynamic>,
            )
          : null,
      nextPlan: nextPlanMap is Map<String, dynamic>
          ? LearningPlanResponseModel.fromMap(nextPlanMap)
          : responseLooksLikePlan
          ? LearningPlanResponseModel.fromMap(map)
          : null,
    );
  }

  final String previousPlanId;
  final RoadmapCompletionSummaryModel? completionSummary;
  final LearningPlanResponseModel? nextPlan;
}
