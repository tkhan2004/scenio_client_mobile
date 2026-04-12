import 'package:get/get.dart';
import '../modules/splash/splash_binding.dart';
import '../modules/splash/splash_view.dart';
import '../modules/onboarding/onboarding_binding.dart';
import '../modules/onboarding/onboarding_view.dart';
import '../modules/auth/auth_binding.dart';
import '../modules/auth/auth_view.dart';
import '../modules/home/home_binding.dart';
import '../modules/home/home_view.dart';
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
    name: Routes.auth,
    page: () => const AuthView(),
    binding: AuthBinding(),
  ),
  GetPage<dynamic>(
    name: Routes.home,
    page: () => const HomeView(),
    binding: HomeBinding(),
  ),
];
