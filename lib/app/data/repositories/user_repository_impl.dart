import '../../data/models/user_badges_model.dart';
import '../../data/models/user_profile_model.dart';
import '../../data/models/user_progress_model.dart';
import '../../domain/entities/user_entity.dart';
import '../../domain/repositories/user_repository.dart';
import '../providers/user_provider.dart';

class UserRepositoryImpl implements UserRepository {
  UserRepositoryImpl({required UserProvider provider}) : _provider = provider;

  final UserProvider _provider;

  @override
  Future<UserEntity> getMe() async {
    return UserProfileModel.fromMap(await _provider.getMe()).user;
  }

  @override
  Future<UserEntity> updateMe({String? displayName, String? avatarUrl}) async {
    return UserProfileModel.fromMap(
      await _provider.updateMe(displayName: displayName, avatarUrl: avatarUrl),
    ).user;
  }

  @override
  Future<void> completeOnboarding({
    String? level,
    String? learningGoal,
    String? studyFrequency,
    String? selfAssessment,
  }) {
    return _provider.completeOnboarding(
      level: level,
      learningGoal: learningGoal,
      studyFrequency: studyFrequency,
      selfAssessment: selfAssessment,
    );
  }

  @override
  Future<UserProgressModel> getProgress() async {
    return UserProgressModel.fromMap(await _provider.getProgress());
  }

  @override
  Future<UserBadgesModel> getBadges() async {
    return UserBadgesModel.fromMap(await _provider.getBadges());
  }
}
