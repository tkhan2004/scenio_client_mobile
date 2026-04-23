abstract class UserRepository {
  Future<void> completeOnboarding({
    String? learningGoal,
    String? studyFrequency,
    String? selfAssessment,
  });
}
