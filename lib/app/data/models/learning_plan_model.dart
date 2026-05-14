import '../../domain/entities/scene_entity.dart';
import 'scene_api_model.dart';

class LearningPlanResponseModel {
  const LearningPlanResponseModel({
    required this.plan,
    required this.steps,
    this.nextStep,
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
    );
  }

  final LearningPlanModel plan;
  final List<LearningPlanStepModel> steps;
  final LearningPlanNextStepModel? nextStep;

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
    required this.title,
    required this.summary,
    required this.level,
    required this.focusSkill,
    required this.weeklyTarget,
    this.learningGoal,
    this.studyFrequency,
  });

  factory LearningPlanModel.fromMap(Map<String, dynamic> map) {
    return LearningPlanModel(
      id: map['id'] as String? ?? '',
      status: map['status'] as String? ?? 'ACTIVE',
      title: map['title'] as String? ?? 'Your Learning Plan',
      summary: map['summary'] as String? ?? '',
      level: map['level'] as String? ?? 'A2',
      learningGoal: map['learningGoal'] as String?,
      studyFrequency: map['studyFrequency'] as String?,
      focusSkill: map['focusSkill'] as String? ?? 'NATURALNESS',
      weeklyTarget: (map['weeklyTarget'] as num?)?.toInt() ?? 3,
    );
  }

  final String id;
  final String status;
  final String title;
  final String summary;
  final String level;
  final String? learningGoal;
  final String? studyFrequency;
  final String focusSkill;
  final int weeklyTarget;
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
