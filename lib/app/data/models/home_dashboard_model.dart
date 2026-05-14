import '../../domain/entities/user_entity.dart';
import '../../domain/entities/scene_entity.dart';
import 'scene_api_model.dart';

class HomeDashboardModel {
  const HomeDashboardModel({
    required this.user,
    required this.missions,
    required this.recommendedScenes,
    this.inProgressSession,
  });

  factory HomeDashboardModel.fromMap(Map<String, dynamic> map) {
    final Map<String, dynamic> userMap =
        map['user'] as Map<String, dynamic>? ?? <String, dynamic>{};

    return HomeDashboardModel(
      user: UserEntity(
        id: userMap['id'] as String? ?? '',
        email: userMap['email'] as String? ?? '',
        displayName: userMap['displayName'] as String?,
        avatarUrl: userMap['avatarUrl'] as String?,
        level: userMap['level'] as String? ?? 'A2',
        totalXp: (userMap['totalXp'] as num?)?.toInt() ?? 0,
        streakDays: (userMap['streakDays'] as num?)?.toInt() ?? 0,
        needsLevelTest: false,
        needsOnboarding: false,
        learningGoal: userMap['learningGoal'] as String?,
        studyFrequency: userMap['studyFrequency'] as String?,
        selfAssessment: userMap['selfAssessment'] as String?,
      ),
      missions: (map['missions'] as List<dynamic>? ?? const <dynamic>[])
          .whereType<Map<String, dynamic>>()
          .map(HomeMissionModel.fromMap)
          .toList(),
      inProgressSession: map['inProgressSession'] is Map<String, dynamic>
          ? InProgressSessionModel.fromMap(
              map['inProgressSession'] as Map<String, dynamic>,
            )
          : null,
      recommendedScenes:
          (map['recommendedScenes'] as List<dynamic>? ?? const <dynamic>[])
              .whereType<Map<String, dynamic>>()
              .map((Map<String, dynamic> item) {
                return SceneApiModel.fromMap(item).toEntity();
              })
              .toList(),
    );
  }

  final UserEntity user;
  final List<HomeMissionModel> missions;
  final InProgressSessionModel? inProgressSession;
  final List<SceneEntity> recommendedScenes;
}

class HomeMissionModel {
  const HomeMissionModel({
    required this.id,
    required this.title,
    required this.description,
    required this.current,
    required this.target,
    required this.xp,
    required this.isCompleted,
  });

  factory HomeMissionModel.fromMap(Map<String, dynamic> map) {
    return HomeMissionModel(
      id: map['id'] as String? ?? '',
      title: map['title'] as String? ?? 'Daily mission',
      description: map['description'] as String? ?? '',
      current: (map['current'] as num?)?.toInt() ?? 0,
      target: (map['target'] as num?)?.toInt() ?? 1,
      xp: (map['xp'] as num?)?.toInt() ?? 0,
      isCompleted: map['isCompleted'] == true,
    );
  }

  final String id;
  final String title;
  final String description;
  final int current;
  final int target;
  final int xp;
  final bool isCompleted;
}

class InProgressSessionModel {
  const InProgressSessionModel({
    required this.id,
    required this.sourceType,
    required this.sceneTitle,
    required this.characterName,
    required this.startedAt,
  });

  factory InProgressSessionModel.fromMap(Map<String, dynamic> map) {
    return InProgressSessionModel(
      id: map['id'] as String? ?? '',
      sourceType: map['sourceType'] as String? ?? 'CURATED_SCENE',
      sceneTitle: map['sceneTitle'] as String? ?? 'Practice Session',
      characterName: map['characterName'] as String? ?? 'AI',
      startedAt:
          DateTime.tryParse(map['startedAt'] as String? ?? '') ??
          DateTime.now(),
    );
  }

  final String id;
  final String sourceType;
  final String sceneTitle;
  final String characterName;
  final DateTime startedAt;
}
