import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../models/source.dart';
import '../widgets/main_layout.dart';
import '../controllers/auth_controller.dart';
import '../controllers/source_controller.dart';

class SourcesScreen extends GetView<SourceController> {
  const SourcesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final authController = Get.find<AuthController>(tag: 'auth');

    // Yetki kontrolü
    if (!authController.canManageSources()) {
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
      title: 'Kaynaklar',
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton.icon(
              icon: const Icon(Icons.add),
              label: const Text('Yeni Kaynak Ekle'),
              onPressed: () => _showAddSourceDialog(),
            ),
          ),
          Expanded(
            child: Obx(() {
              if (controller.isLoading.value) {
                return const Center(child: CircularProgressIndicator());
              }

              if (controller.sources.isEmpty) {
                return const Center(child: Text('Henüz kaynak bulunmuyor'));
              }

              return ListView.builder(
                itemCount: controller.sources.length,
                itemBuilder: (context, index) {
                  final source = controller.sources[index];
                  return Card(
                    margin: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    child: ListTile(
                      leading: const Icon(Icons.source),
                      title: Text(source.name),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [Text(source.url), Text(source.description)],
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.edit),
                            onPressed: () => _showEditSourceDialog(source),
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete),
                            onPressed: () => controller.deleteSource(source.id),
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

  void _showAddSourceDialog() {
    final nameController = TextEditingController();
    final urlController = TextEditingController();
    final descriptionController = TextEditingController();

    Get.dialog(
      AlertDialog(
        title: const Text('Yeni Kaynak Ekle'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: const InputDecoration(
                  labelText: 'Kaynak Adı',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: urlController,
                decoration: const InputDecoration(
                  labelText: 'URL',
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
        ),
        actions: [
          TextButton(onPressed: () => Get.back(), child: const Text('İptal')),
          ElevatedButton(
            onPressed: () {
              if (nameController.text.isNotEmpty &&
                  urlController.text.isNotEmpty &&
                  descriptionController.text.isNotEmpty) {
                final source = Source(
                  id: 0,
                  name: nameController.text,
                  url: urlController.text,
                  description: descriptionController.text,
                );
                controller.addSource(source);
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

  void _showEditSourceDialog(Source source) {
    final nameController = TextEditingController(text: source.name);
    final urlController = TextEditingController(text: source.url);
    final descriptionController = TextEditingController(
      text: source.description,
    );

    Get.dialog(
      AlertDialog(
        title: const Text('Kaynağı Düzenle'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: const InputDecoration(
                  labelText: 'Kaynak Adı',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: urlController,
                decoration: const InputDecoration(
                  labelText: 'URL',
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
        ),
        actions: [
          TextButton(onPressed: () => Get.back(), child: const Text('İptal')),
          ElevatedButton(
            onPressed: () {
              if (nameController.text.isNotEmpty &&
                  urlController.text.isNotEmpty &&
                  descriptionController.text.isNotEmpty) {
                final updatedSource = Source(
                  id: source.id,
                  name: nameController.text,
                  url: urlController.text,
                  description: descriptionController.text,
                );
                controller.updateSource(updatedSource);
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
