abstract class ApiEndpoints {
  static const String authLogin = '/auth/login';
  static const String authRegister = '/auth/register';
  static const String authGoogle = '/auth/google';
  static const String authRefresh = '/auth/refresh';
  static const String authLogout = '/auth/logout';
  static const String authVerifyToken = '/auth/verify-token';

  static const String homeDashboard = '/home/dashboard';
  static const String learningPlanCurrent = '/learning-plan/current';
  static const String learningPlanRefresh = '/learning-plan/refresh';
  static const String scenes = '/scenes';

  static const String usersMe = '/users/me';
  static const String usersOnboarding = '/users/me/onboarding';
  static const String usersProgress = '/users/progress';
  static const String usersBadges = '/users/badges';
  static const String vocabulary = '/vocabulary';
  static const String vocabularyDecks = '/vocabulary/decks';
  static const String notifications = '/notifications';
  static const String notificationsReadAll = '/notifications/read-all';

  static String sceneDetail(String sceneId) => '/scenes/$sceneId';
  static String learningPlanStepComplete(String stepId) =>
      '/learning-plan/steps/$stepId/complete';
  static String learningPlanCompletionSummary(String planId) =>
      '/learning-plan/$planId/completion-summary';
  static String learningPlanStartNext(String planId) =>
      '/learning-plan/$planId/start-next';
  static String vocabularyDeckDetail(String sessionId) =>
      '/vocabulary/decks/$sessionId';
  static String vocabularyReview(String vocabularyId) =>
      '/vocabulary/$vocabularyId/review';
  static String notificationRead(String notificationId) =>
      '/notifications/$notificationId/read';

  static const String startSession = '/sessions/start';
  static const String startCustomSession = '/sessions/start-custom';
  static String sessionMessage(String sessionId) =>
      '/sessions/$sessionId/message';
  static String sessionComplete(String sessionId) =>
      '/sessions/$sessionId/complete';
  static String sessionResult(String sessionId) =>
      '/sessions/$sessionId/result';
  static String sessionAbandon(String sessionId) =>
      '/sessions/$sessionId/abandon';
  static String sessionHint(String sessionId) => '/sessions/$sessionId/hint';
  static String sessionRealtimeToken(String sessionId) =>
      '/sessions/$sessionId/realtime-token';
}
