import '../../domain/repositories/user_repository.dart';
import '../providers/user_provider.dart';

class UserRepositoryImpl implements UserRepository {
  UserRepositoryImpl({required UserProvider provider}) : _provider = provider;

  final UserProvider _provider;

  @override
  Future<void> completeOnboarding({
    String? learningGoal,
    String? studyFrequency,
    String? selfAssessment,
  }) {
    return _provider.completeOnboarding(
      learningGoal: learningGoal,
      studyFrequency: studyFrequency,
      selfAssessment: selfAssessment,
    );
  }
}
