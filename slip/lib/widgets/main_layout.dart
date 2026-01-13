import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import '../controllers/auth_controller.dart';
import '../controllers/theme_controller.dart';
import '../routes/app_routes.dart';

class MainLayout extends StatelessWidget {
  final String title;
  final Widget body;

  const MainLayout({super.key, required this.title, required this.body});

  @override
  Widget build(BuildContext context) {
    final themeController = Get.find<ThemeController>();
    final auth = Get.find<AuthController>(tag: 'auth');

    int routeToIndex(String route) {
      switch (route) {
        case AppRoutes.dashboard:
          return 0;
        case AppRoutes.sources:
          return 1;
        case AppRoutes.platforms:
          return 2;
        case AppRoutes.users:
          return 3;
        default:
          return 0;
      }
    }

    void onNavTap(int index) {
      switch (index) {
        case 0:
          Get.offAllNamed(AppRoutes.dashboard);
          break;
        case 1:
          if (auth.canManageSources()) {
            Get.offAllNamed(AppRoutes.sources);
          }
          break;
        case 2:
          if (auth.canManagePlatforms()) {
            Get.offAllNamed(AppRoutes.platforms);
          }
          break;
        case 3:
          if (auth.canManageUsers()) {
            Get.offAllNamed(AppRoutes.users);
          }
          break;
      }
    }

    final currentIndex = routeToIndex(Get.currentRoute);

    // iOS: Tamamen farklı bir duruş – gradient arkaplan + altta Cupertino tab bar
    if (GetPlatform.isIOS) {
      return CupertinoPageScaffold(
        child: Stack(
          children: [
            // Gradient arkaplan
            Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFF1F2D3D), Color(0xFF4C78FF)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
            ),
            // İçerik
            SafeArea(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Büyük başlık ve tema tuşu
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            const Icon(
                              CupertinoIcons.eye,
                              color: Colors.white,
                              size: 28,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              title,
                              style: const TextStyle(
                                fontSize: 26,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            Obx(
                              () => CupertinoButton(
                                padding: EdgeInsets.zero,
                                onPressed: () => themeController.toggleTheme(),
                                child: Icon(
                                  themeController.isDarkMode
                                      ? CupertinoIcons.sun_max
                                      : CupertinoIcons.moon,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            CupertinoButton(
                              padding: EdgeInsets.zero,
                              onPressed: () {
                                showCupertinoDialog(
                                  context: context,
                                  builder: (ctx) => CupertinoAlertDialog(
                                    title: const Text('Çıkış Yap'),
                                    content: const Text(
                                      'Hesabınızdan çıkış yapmak istiyor musunuz?',
                                    ),
                                    actions: [
                                      CupertinoDialogAction(
                                        onPressed: () => Navigator.pop(ctx),
                                        child: const Text('İptal'),
                                      ),
                                      CupertinoDialogAction(
                                        isDestructiveAction: true,
                                        onPressed: () {
                                          Navigator.pop(ctx);
                                          auth.logout();
                                        },
                                        child: const Text('Çıkış'),
                                      ),
                                    ],
                                  ),
                                );
                              },
                              child: const Icon(
                                CupertinoIcons.square_arrow_right,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Container(
                      margin: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.08),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: body,
                    ),
                  ),
                ],
              ),
            ),
            // Altta Cupertino tab bar
            Align(
              alignment: Alignment.bottomCenter,
              child: CupertinoTabBar(
                currentIndex: currentIndex,
                onTap: onNavTap,
                items: [
                  const BottomNavigationBarItem(
                    icon: Icon(CupertinoIcons.speedometer),
                    label: 'Dashboard',
                  ),
                  if (auth.canManageSources())
                    const BottomNavigationBarItem(
                      icon: Icon(CupertinoIcons.link),
                      label: 'Kaynaklar',
                    ),
                  if (auth.canManagePlatforms())
                    const BottomNavigationBarItem(
                      icon: Icon(CupertinoIcons.device_laptop),
                      label: 'Platformlar',
                    ),
                  if (auth.canManageUsers())
                    const BottomNavigationBarItem(
                      icon: Icon(CupertinoIcons.person_2),
                      label: 'Kullanıcılar',
                    ),
                ],
              ),
            ),
          ],
        ),
      );
    }

    // Material: Drawer yerine modern bottom nav + gradient arkaplan
    return Scaffold(
      appBar: null,
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF101828), Color(0xFF5E5CE6)],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),
          SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          const Icon(
                            Icons.visibility,
                            color: Colors.white,
                            size: 28,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            title,
                            style: const TextStyle(
                              fontSize: 26,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                        Row(
                          children: [
                            Obx(
                              () => IconButton(
                                icon: Icon(
                                  themeController.isDarkMode
                                      ? Icons.light_mode
                                      : Icons.dark_mode,
                                  color: Colors.white,
                                ),
                                onPressed: () => themeController.toggleTheme(),
                                tooltip: themeController.isDarkMode
                                    ? 'Light Mode'
                                    : 'Dark Mode',
                              ),
                            ),
                            IconButton(
                              icon: const Icon(
                                Icons.logout,
                                color: Colors.white,
                              ),
                              tooltip: 'Çıkış Yap',
                              onPressed: () {
                                showDialog(
                                  context: context,
                                  builder: (ctx) => AlertDialog(
                                    title: const Text('Çıkış Yap'),
                                    content: const Text(
                                      'Hesabınızdan çıkış yapmak istiyor musunuz?',
                                    ),
                                    actions: [
                                      TextButton(
                                        onPressed: () => Navigator.pop(ctx),
                                        child: const Text('İptal'),
                                      ),
                                      ElevatedButton(
                                        onPressed: () {
                                          Navigator.pop(ctx);
                                          auth.logout();
                                        },
                                        child: const Text('Çıkış'),
                                      ),
                                    ],
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                    ],
                  ),
                ),
                Expanded(
                  child: Container(
                    margin: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.08),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: body,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: currentIndex,
        onDestinationSelected: onNavTap,
        destinations: [
          const NavigationDestination(
            icon: Icon(Icons.dashboard_outlined),
            selectedIcon: Icon(Icons.dashboard),
            label: 'Dashboard',
          ),
          if (auth.canManageSources())
            const NavigationDestination(
              icon: Icon(Icons.link_outlined),
              selectedIcon: Icon(Icons.link),
              label: 'Kaynaklar',
            ),
          if (auth.canManagePlatforms())
            const NavigationDestination(
              icon: Icon(Icons.laptop_outlined),
              selectedIcon: Icon(Icons.laptop),
              label: 'Platformlar',
            ),
          if (auth.canManageUsers())
            const NavigationDestination(
              icon: Icon(Icons.people_outline),
              selectedIcon: Icon(Icons.people),
              label: 'Kullanıcılar',
            ),
        ],
      ),
    );
  }
}
