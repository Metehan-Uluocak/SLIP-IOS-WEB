import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/auth_controller.dart';
import '../controllers/theme_controller.dart';
import '../routes/app_routes.dart';

class MainLayout extends StatelessWidget {
  final String title;
  final Widget body;

  const MainLayout({
    super.key,
    required this.title,
    required this.body,
  });

  @override
  Widget build(BuildContext context) {
    // Tag ile AuthController'a eriş
    //final controller = Get.find<AuthController>(tag: 'auth');
    final themeController = Get.find<ThemeController>();
    
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        actions: [
          Obx(() => IconButton(
            icon: Icon(
              themeController.isDarkMode ? Icons.light_mode : Icons.dark_mode,
            ),
            tooltip: themeController.isDarkMode ? 'Light Mode' : 'Dark Mode',
            onPressed: () => themeController.toggleTheme(),
          )),
          const SizedBox(width: 8),
        ],
      ),
      drawer: GetBuilder<AuthController>(
        tag: 'auth',
        builder: (controller) {
          final currentUser = controller.currentUser;
          
          return Drawer(
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                DrawerHeader(
                  decoration: BoxDecoration(color: Theme.of(context).colorScheme.primary),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          const Icon(Icons.security, size: 48, color: Colors.white),
                          const SizedBox(width: 8),
                          const Text(
                            'SLIP',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 48,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      if (currentUser != null) ...[
                        SizedBox(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                currentUser.name,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                currentUser.email,
                                style: const TextStyle(
                                  color: Colors.white70,
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ] else ...[
                        const Text(
                          'Hata: Kullanıcı bilgisi bulunamadı',
                          style: TextStyle(
                            color: Colors.red,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
                ListTile(
                  leading: const Icon(Icons.dashboard),
                  title: const Text('Dashboard'),
                  onTap: () {
                    Navigator.pop(context);
                    Get.offAllNamed(AppRoutes.dashboard);
                  },
                ),
                if (controller.canManageSources())
                  ListTile(
                    leading: const Icon(Icons.source),
                    title: const Text('Kaynaklar'),
                    onTap: () {
                      Navigator.pop(context);
                      Get.offAllNamed(AppRoutes.sources);
                    },
                  ),
                if (controller.canManagePlatforms())
                  ListTile(
                    leading: const Icon(Icons.laptop),
                    title: const Text('Platformlar'),
                    onTap: () {
                      Navigator.pop(context);
                      Get.offAllNamed(AppRoutes.platforms);
                    },
                  ),
                if (controller.canManageUsers())
                  ListTile(
                    leading: const Icon(Icons.people),
                    title: const Text('Kullanıcılar'),
                    onTap: () {
                      Navigator.pop(context);
                      Get.offAllNamed(AppRoutes.users);
                    },
                  ),
                const Divider(),
                if (currentUser != null)
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Yetkileriniz:',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                        ),
                        const SizedBox(height: 8),
                        _buildPermissionChip('Sızıntıları Görüntüleme', controller.canViewLeaks()),
                        _buildPermissionChip('Kaynak Yönetimi', controller.canManageSources()),
                        _buildPermissionChip('Platform Yönetimi', controller.canManagePlatforms()),
                        _buildPermissionChip('Kullanıcı Yönetimi', controller.canManageUsers()),
                      ],
                    ),
                  ),
                const Divider(),
                ListTile(
                  leading: const Icon(Icons.logout),
                  title: const Text('Çıkış Yap'),
                  onTap: () {
                    Navigator.pop(context);
                    controller.logout();
                  },
                ),
              ],
            ),
          );
        },
      ),
      body: body,
    );
  }

  Widget _buildPermissionChip(String label, bool hasPermission) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Row(
        children: [
          Icon(
            hasPermission ? Icons.check_circle : Icons.cancel,
            size: 16,
            color: hasPermission ? Colors.green : Colors.red,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              label,
              style: const TextStyle(fontSize: 12),
            ),
          ),
        ],
      ),
    );
  }
}
