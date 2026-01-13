import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../models/platform.dart';
import '../widgets/main_layout.dart';
import '../controllers/auth_controller.dart';
import '../controllers/platform_controller.dart';

class PlatformsScreen extends GetView<PlatformController> {
  const PlatformsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final authController = Get.find<AuthController>(tag: 'auth');

    // Yetki kontrolü
    if (!authController.canManagePlatforms()) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Get.offAllNamed('/dashboard');
        Get.snackbar(
          'Yetki Hatası',
          'Bu sayfaya erişim yetkiniz yok',
          snackPosition: SnackPosition.BOTTOM,
        );
      });
    }

    return MainLayout(
      title: 'Platformlar',
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton.icon(
              icon: const Icon(Icons.add),
              label: const Text('Yeni Platform Ekle'),
              onPressed: () => _showAddPlatformDialog(),
            ),
          ),
          Expanded(
            child: Obx(() {
              if (controller.isLoading.value) {
                return const Center(child: CircularProgressIndicator());
              }

              if (controller.platforms.isEmpty) {
                return const Center(child: Text('Henüz platform bulunmuyor'));
              }

              return ListView.builder(
                itemCount: controller.platforms.length,
                itemBuilder: (context, index) {
                  final platform = controller.platforms[index];
                  return Card(
                    margin: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    child: ListTile(
                      leading: const Icon(Icons.laptop),
                      title: Text(platform.name),
                      subtitle: Text(platform.description),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.edit),
                            onPressed: () => _showEditPlatformDialog(platform),
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete),
                            onPressed: () => controller.deletePlatform(platform.id),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
            }),
          ),
        ],
      ),
    );
  }

  void _showAddPlatformDialog() {
    final nameController = TextEditingController();
    final descriptionController = TextEditingController();

    Get.dialog(
      AlertDialog(
        title: const Text('Yeni Platform Ekle'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameController,
              decoration: const InputDecoration(
                labelText: 'Platform Adı',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: descriptionController,
              maxLines: 3,
              decoration: const InputDecoration(
                labelText: 'Açıklama',
                border: OutlineInputBorder(),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('İptal'),
          ),
          ElevatedButton(
            onPressed: () {
              if (nameController.text.isNotEmpty && 
                  descriptionController.text.isNotEmpty) {
                final platform = Platform(
                  id: 0,
                  name: nameController.text,
                  description: descriptionController.text,
                );
                controller.addPlatform(platform);
                Get.back();
              } else {
                Get.snackbar('Hata', 'Tüm alanları doldurun');
              }
            },
            child: const Text('Ekle'),
          ),
        ],
      ),
    );
  }

  void _showEditPlatformDialog(Platform platform) {
    final nameController = TextEditingController(text: platform.name);
    final descriptionController = TextEditingController(text: platform.description);

    Get.dialog(
      AlertDialog(
        title: const Text('Platformu Düzenle'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameController,
              decoration: const InputDecoration(
                labelText: 'Platform Adı',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: descriptionController,
              maxLines: 3,
              decoration: const InputDecoration(
                labelText: 'Açıklama',
                border: OutlineInputBorder(),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('İptal'),
          ),
          ElevatedButton(
            onPressed: () {
              if (nameController.text.isNotEmpty && 
                  descriptionController.text.isNotEmpty) {
                final updatedPlatform = Platform(
                  id: platform.id,
                  name: nameController.text,
                  description: descriptionController.text,
                );
                controller.updatePlatform(updatedPlatform);
                Get.back();
              } else {
                Get.snackbar('Hata', 'Tüm alanları doldurun');
              }
            },
            child: const Text('Güncelle'),
          ),
        ],
      ),
    );
  }
}
