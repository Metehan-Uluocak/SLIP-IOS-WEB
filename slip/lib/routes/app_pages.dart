import 'package:get/get.dart';
import '../screens/login_screen.dart';
import '../screens/dashboard_screen.dart';
import '../screens/sources_screen.dart';
import '../screens/platforms_screen.dart';
import '../screens/users_screen.dart';
import '../controllers/leak_controller.dart';
import '../controllers/source_controller.dart';
import '../controllers/platform_controller.dart';
import '../controllers/user_controller.dart';
import 'app_routes.dart';

class AppPages {
  static final pages = [
    GetPage(name: AppRoutes.login, page: () => const LoginScreen()),
    GetPage(
      name: AppRoutes.dashboard,
      page: () => const DashboardScreen(),
      binding: BindingsBuilder(() {
        Get.lazyPut(() => LeakController());
      }),
    ),
    GetPage(
      name: AppRoutes.sources,
      page: () => const SourcesScreen(),
      binding: BindingsBuilder(() {
        Get.lazyPut(() => SourceController());
      }),
    ),
    GetPage(
      name: AppRoutes.platforms,
      page: () => const PlatformsScreen(),
      binding: BindingsBuilder(() {
        Get.lazyPut(() => PlatformController());
      }),
    ),
    GetPage(
      name: AppRoutes.users,
      page: () => const UsersScreen(),
      binding: BindingsBuilder(() {
        Get.lazyPut(() => UserController());
      }),
    ),
  ];
}
