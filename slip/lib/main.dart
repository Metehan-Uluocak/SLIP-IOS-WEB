import 'package:flutter/material.dart'; // Widget toolkit for building UI
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart'; // State management and routing
import 'routes/app_pages.dart'; // Application route definitions
import 'routes/app_routes.dart'; // Application route constants
import 'controllers/auth_controller.dart'; // Authentication controller
import 'controllers/theme_controller.dart'; // Theme controller

void main() {
  Get.put(
    AuthController(),
    permanent: true,
    tag: 'auth',
  ); // Initialize AuthController
  Get.put(ThemeController(), permanent: true); // Initialize ThemeController

  runApp(const MyApp()); // Entry point of the UI application
}

class MyApp extends StatelessWidget {
  // Root widget of the application
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Test veya hot-reload sırasında controller'lar register edilmemiş olabilir
    if (!Get.isRegistered<AuthController>(tag: 'auth')) {
      Get.put(AuthController(), permanent: true, tag: 'auth');
    }
    if (!Get.isRegistered<ThemeController>()) {
      Get.put(ThemeController(), permanent: true);
    }
    final themeController = Get.find<ThemeController>();

    return Obx(
      () => GetMaterialApp(
        debugShowCheckedModeBanner: false, // Disable debug banner
        title: 'Security Leak Intelligence Platform',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(
            seedColor: Colors.indigo,
            brightness: Brightness.light,
          ),
          useMaterial3: true,
          appBarTheme: const AppBarTheme(centerTitle: true),
          inputDecorationTheme: const InputDecorationTheme(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(12)),
            ),
          ),
          // Kart görünümünü varsayılana bırakıyoruz (sürüm uyumluluğu için)
          chipTheme: const ChipThemeData(shape: StadiumBorder()),
          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(12)),
              ),
              padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
            ),
          ),
          cupertinoOverrideTheme: const CupertinoThemeData(
            primaryColor: CupertinoColors.systemIndigo,
          ),
        ),
        darkTheme: ThemeData(
          colorScheme: ColorScheme.fromSeed(
            seedColor: Colors.indigo,
            brightness: Brightness.dark,
          ),
          useMaterial3: true,
          appBarTheme: const AppBarTheme(centerTitle: true),
          inputDecorationTheme: const InputDecorationTheme(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(12)),
            ),
          ),
          // Kart görünümünü varsayılana bırakıyoruz (sürüm uyumluluğu için)
          chipTheme: const ChipThemeData(shape: StadiumBorder()),
          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(12)),
              ),
              padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
            ),
          ),
          cupertinoOverrideTheme: const CupertinoThemeData(
            primaryColor: CupertinoColors.systemIndigo,
          ),
        ),
        themeMode: themeController.themeMode, // Manage theme mode
        initialRoute: AppRoutes.login, // Initial route of the application
        getPages: AppPages.pages, // Application routes
        // iOS'ta Cupertino geçişleri kullan
        defaultTransition: GetPlatform.isIOS
            ? Transition.cupertino
            : Transition.fade,
        transitionDuration: const Duration(milliseconds: 300),
        // Memory management ayarları
        smartManagement: SmartManagement.keepFactory,
      ),
    );
  }
}
