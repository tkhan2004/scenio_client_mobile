import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'app/app_binding.dart';
import 'app/core/config/app_env.dart';
import 'app/core/storage/storage_service.dart';
import 'app/core/theme/app_theme.dart';
import 'app/core/translations/app_translations.dart';
import 'app/routes/app_pages.dart';
import 'app/routes/app_routes.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await AppEnv.load();
  await StorageService.init();
  runApp(const ScenioApp());
}

class ScenioApp extends StatelessWidget {
  const ScenioApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Scenio',
      theme: buildAppTheme(),
      translations: AppTranslations(),
      locale: const Locale('vi', 'VN'),
      fallbackLocale: const Locale('en', 'US'),
      initialRoute: Routes.splash,
      initialBinding: AppBinding(),
      getPages: appPages,
      debugShowCheckedModeBanner: false,
    );
  }
}
