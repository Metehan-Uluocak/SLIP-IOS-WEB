import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../models/user.dart';
import '../widgets/main_layout.dart';
import '../controllers/auth_controller.dart';
import '../controllers/user_controller.dart';

class UsersScreen extends GetView<UserController> {
  const UsersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final authController = Get.find<AuthController>(tag: 'auth');

    // Sadece admin yetkisi kontrolü
    if (!authController.canManageUsers()) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Get.offAllNamed('/dashboard');
        Get.snackbar(
          'Yetki Hatası',
          'Bu sayfaya sadece admin kullanıcıları erişebilir',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red.shade100,
        );
      });
    }

    return MainLayout(
      title: 'Kullanıcı Yönetimi',
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton.icon(
              icon: const Icon(Icons.person_add),
              label: const Text('Yeni Kullanıcı Ekle'),
              onPressed: () => _showAddUserDialog(),
            ),
          ),
          Expanded(
            child: Obx(() {
              if (controller.isLoading.value) {
                return const Center(child: CircularProgressIndicator());
              }

              if (controller.users.isEmpty) {
                return const Center(child: Text('Henüz kullanıcı bulunmuyor'));
              }

              return ListView.builder(
                itemCount: controller.users.length,
                itemBuilder: (context, index) {
                  final user = controller.users[index];
                  return Card(
                    margin: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    child: ListTile(
                      leading: CircleAvatar(
                        child: Icon(_getRoleIcon(user.role)),
                      ),
                      title: Text(user.name),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(user.email),
                          Text(
                            _getRoleText(user.role),
                            style: TextStyle(
                              color: _getRoleColor(user.role),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.edit),
                            onPressed: () => _showEditUserDialog(user),
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete),
                            color: Colors.red,
                            onPressed: () => _confirmDelete(user),
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

  IconData _getRoleIcon(UserRole role) {
    switch (role) {
      case UserRole.admin:
        return Icons.admin_panel_settings;
      case UserRole.analist:
        return Icons.analytics;
      case UserRole.user:
        return Icons.person;
    }
  }

  String _getRoleText(UserRole role) {
    switch (role) {
      case UserRole.admin:
        return 'Admin';
      case UserRole.analist:
        return 'Analist';
      case UserRole.user:
        return 'Kullanıcı';
    }
  }

  Color _getRoleColor(UserRole role) {
    switch (role) {
      case UserRole.admin:
        return Colors.red;
      case UserRole.analist:
        return Colors.blue;
      case UserRole.user:
        return Colors.green;
    }
  }

  void _showAddUserDialog() {
    final nameController = TextEditingController();
    final emailController = TextEditingController();
    final roleController = Rx<UserRole>(UserRole.user);

    Get.dialog(
      AlertDialog(
        title: const Text('Yeni Kullanıcı Ekle'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: const InputDecoration(
                  labelText: 'İsim',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.person),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: emailController,
                decoration: const InputDecoration(
                  labelText: 'E-posta',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.email),
                ),
                keyboardType: TextInputType.emailAddress,
              ),
              const SizedBox(height: 16),
              Obx(() => DropdownButtonFormField<UserRole>(
                value: roleController.value,
                decoration: const InputDecoration(
                  labelText: 'Rol',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.security),
                ),
                items: UserRole.values.map((role) {
                  return DropdownMenuItem(
                    value: role,
                    child: Text(_getRoleText(role)),
                  );
                }).toList(),
                onChanged: (value) {
                  if (value != null) roleController.value = value;
                },
              )),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('İptal'),
          ),
          ElevatedButton(
            onPressed: () {
              if (nameController.text.isNotEmpty && 
                  emailController.text.isNotEmpty) {
                final user = User(
                  id: 0,
                  name: nameController.text,
                  email: emailController.text,
                  role: roleController.value,
                );
                controller.addUser(user);
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

  void _showEditUserDialog(User user) {
    final nameController = TextEditingController(text: user.name);
    final emailController = TextEditingController(text: user.email);
    final roleController = Rx<UserRole>(user.role);

    Get.dialog(
      AlertDialog(
        title: const Text('Kullanıcıyı Düzenle'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: const InputDecoration(
                  labelText: 'İsim',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.person),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: emailController,
                decoration: const InputDecoration(
                  labelText: 'E-posta',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.email),
                ),
                keyboardType: TextInputType.emailAddress,
              ),
              const SizedBox(height: 16),
              Obx(() => DropdownButtonFormField<UserRole>(
                value: roleController.value,
                decoration: const InputDecoration(
                  labelText: 'Rol',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.security),
                ),
                items: UserRole.values.map((role) {
                  return DropdownMenuItem(
                    value: role,
                    child: Text(_getRoleText(role)),
                  );
                }).toList(),
                onChanged: (value) {
                  if (value != null) roleController.value = value;
                },
              )),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('İptal'),
          ),
          ElevatedButton(
            onPressed: () {
              if (nameController.text.isNotEmpty && 
                  emailController.text.isNotEmpty) {
                final updatedUser = User(
                  id: user.id,
                  name: nameController.text,
                  email: emailController.text,
                  role: roleController.value,
                );
                controller.updateUser(updatedUser);
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

  void _confirmDelete(User user) {
    Get.dialog(
      AlertDialog(
        title: const Text('Kullanıcıyı Sil'),
        content: Text('${user.name} adlı kullanıcıyı silmek istediğinize emin misiniz?'),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('İptal'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
            ),
            onPressed: () {
              controller.deleteUser(user.id);
              Get.back();
            },
            child: const Text('Sil'),
          ),
        ],
      ),
    );
  }
}
