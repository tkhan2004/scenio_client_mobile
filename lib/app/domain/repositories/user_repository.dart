import '../../data/models/user_badges_model.dart';
import '../../data/models/user_progress_model.dart';
import '../entities/user_entity.dart';

abstract class UserRepository {
  Future<UserEntity> getMe();

  Future<UserEntity> updateMe({String? displayName, String? avatarUrl});

  Future<void> completeOnboarding({
    String? level,
    String? learningGoal,
    String? studyFrequency,
    String? selfAssessment,
  });

  Future<UserProgressModel> getProgress();

  Future<UserBadgesModel> getBadges();
}
