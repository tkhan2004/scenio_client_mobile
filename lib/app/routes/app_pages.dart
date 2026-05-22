import 'package:get/get.dart';
import '../modules/splash/splash_binding.dart';
import '../modules/splash/splash_view.dart';
import '../modules/onboarding/onboarding_binding.dart';
import '../modules/onboarding/onboarding_view.dart';
import '../modules/account_onboarding/account_onboarding_binding.dart';
import '../modules/account_onboarding/account_onboarding_view.dart';
import '../modules/auth/auth_binding.dart';
import '../modules/auth/auth_view.dart';
import '../modules/chat/chat_binding.dart';
import '../modules/chat/chat_view.dart';
import '../modules/custom_practice/custom_practice_binding.dart';
import '../modules/custom_practice/custom_practice_view.dart';
import '../modules/home/home_binding.dart';
import '../modules/home/home_view.dart';
import '../modules/learning_plan/learning_plan_binding.dart';
import '../modules/learning_plan/learning_plan_view.dart';
import '../modules/notifications/notifications_binding.dart';
import '../modules/notifications/notifications_view.dart';
import '../modules/roadmap_completion/roadmap_completion_binding.dart';
import '../modules/roadmap_completion/roadmap_completion_view.dart';
import '../modules/scene_detail/scene_detail_binding.dart';
import '../modules/scene_detail/scene_detail_view.dart';
import '../modules/session_result/session_result_binding.dart';
import '../modules/session_result/session_result_view.dart';
import 'app_routes.dart';

final List<GetPage<dynamic>> appPages = <GetPage<dynamic>>[
  GetPage<dynamic>(
    name: Routes.splash,
    page: () => const SplashView(),
    binding: SplashBinding(),
  ),
  GetPage<dynamic>(
    name: Routes.onboarding,
    page: () => const OnboardingView(),
    binding: OnboardingBinding(),
  ),
  GetPage<dynamic>(
    name: Routes.accountOnboarding,
    page: () => const AccountOnboardingView(),
    binding: AccountOnboardingBinding(),
  ),
  GetPage<dynamic>(
    name: Routes.auth,
    page: () => const AuthView(),
    binding: AuthBinding(),
  ),
  GetPage<dynamic>(
    name: Routes.home,
    page: () => const HomeView(),
    binding: HomeBinding(),
  ),
  GetPage<dynamic>(
    name: Routes.customPractice,
    page: () => const CustomPracticeView(),
    binding: CustomPracticeBinding(),
  ),
  GetPage<dynamic>(
    name: Routes.learningPlan,
    page: () => const LearningPlanView(),
    binding: LearningPlanBinding(),
  ),
  GetPage<dynamic>(
    name: Routes.roadmapCompletion,
    page: () => const RoadmapCompletionView(),
    binding: RoadmapCompletionBinding(),
  ),
  GetPage<dynamic>(
    name: Routes.sceneDetail,
    page: () => const SceneDetailView(),
    binding: SceneDetailBinding(),
  ),
  GetPage<dynamic>(
    name: Routes.practiceSession,
    page: () => const ChatView(),
    binding: ChatBinding(),
  ),
  GetPage<dynamic>(
    name: Routes.sessionResult,
    page: () => const SessionResultView(),
    binding: SessionResultBinding(),
  ),
  GetPage<dynamic>(
    name: Routes.notifications,
    page: () => const NotificationsView(),
    binding: NotificationsBinding(),
  ),
];
