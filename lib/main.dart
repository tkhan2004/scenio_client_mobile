import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'app/core/theme/app_theme.dart';
import 'app/routes/app_pages.dart';
import 'app/routes/app_routes.dart';

void main() {
  runApp(const ScenioApp());
}

class ScenioApp extends StatelessWidget {
  const ScenioApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Scenio',
      theme: buildAppTheme(),
      initialRoute: Routes.home,
      getPages: appPages,
      debugShowCheckedModeBanner: false,
    );
  }
}
