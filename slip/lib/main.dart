import 'package:flutter/material.dart'; // Widget toolkit for building UI
import 'package:get/get.dart';          // State management and routing
import 'routes/app_pages.dart';        // Application route definitions
import 'routes/app_routes.dart';       // Application route constants
import 'controllers/auth_controller.dart';  // Authentication controller
import 'controllers/theme_controller.dart'; // Theme controller

void main() {
  Get.put(AuthController(), permanent: true, tag: 'auth'); // Initialize AuthController
  Get.put(ThemeController(), permanent: true); // Initialize ThemeController
  
  runApp(const MyApp()); // Entry point of the UI application
}

class MyApp extends StatelessWidget {  // Root widget of the application
  const MyApp({super.key});  

  @override
  Widget build(BuildContext context) {
    final themeController = Get.find<ThemeController>();
    
    return Obx(() => GetMaterialApp(
      debugShowCheckedModeBanner: false,  // Disable debug banner
      title: 'Security Leak Intelligence Platform',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.blue,
          brightness: Brightness.light,
        ),
        useMaterial3: true,
      ),
      darkTheme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.blue,
          brightness: Brightness.dark,
        ),
        useMaterial3: true,
      ),
      themeMode: themeController.themeMode,  // Manage theme mode
      initialRoute: AppRoutes.login,  // Initial route of the application
      getPages: AppPages.pages,  // Application routes
      // Memory management ayarları
      smartManagement: SmartManagement.keepFactory,
    ));
  }
}
