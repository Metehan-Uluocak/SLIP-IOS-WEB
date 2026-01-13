import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/auth_controller.dart';
import '../routes/app_routes.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Tag ile AuthController'a eriş
    final controller = Get.find<AuthController>(tag: 'auth');
    final emailController = TextEditingController();
    final passwordController = TextEditingController();
    final formKey = GlobalKey<FormState>();

    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 500),
            child: Card(
              elevation: 8,
              child: Padding(
                padding: const EdgeInsets.all(32.0),
                child: Form(
                  key: formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.security, size: 80, color: Theme.of(context).colorScheme.primary),
                      const SizedBox(height: 24),
                      Text('SLIP', style: Theme.of(context).textTheme.headlineMedium),
                      Text(
                        'Security Leak Intelligence Platform',
                        style: Theme.of(context).textTheme.bodySmall,
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 32),
                      TextFormField(
                        controller: emailController,
                        decoration: const InputDecoration(
                          labelText: 'Email',
                          border: OutlineInputBorder(),
                          prefixIcon: Icon(Icons.email),
                        ),
                        validator: (value) => value?.isEmpty ?? true ? 'Email gerekli' : null,
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: passwordController,
                        decoration: const InputDecoration(
                          labelText: 'Şifre',
                          border: OutlineInputBorder(),
                          prefixIcon: Icon(Icons.lock),
                        ),
                        obscureText: true,
                        validator: (value) => value?.isEmpty ?? true ? 'Şifre gerekli' : null,
                      ),
                      const SizedBox(height: 24),
                      Obx(() => SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: controller.isLoading.value
                              ? null
                              : () async {
                                  if (formKey.currentState!.validate()) {
                                    final success = await controller.login(
                                      emailController.text.trim(),
                                      passwordController.text,
                                    );
                                    if (success) {

                                      Get.offAllNamed(AppRoutes.dashboard);
                                    } else {
                                      Get.snackbar(
                                        'Hata',
                                        'Email veya şifre hatalı',
                                        snackPosition: SnackPosition.BOTTOM,
                                      );
                                    }
                                  }
                                },
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 16),
                          ),
                          child: controller.isLoading.value
                              ? const SizedBox(
                                  height: 20,
                                  width: 20,
                                  child: CircularProgressIndicator(strokeWidth: 2),
                                )
                              : const Text('Giriş Yap'),
                        ),
                      )),
                      const SizedBox(height: 24),
                      const Divider(),
                      const SizedBox(height: 16),
                      Text('Demo Hesapları:', style: Theme.of(context).textTheme.titleSmall),
                      const SizedBox(height: 8),
                      _buildDemoAccount('Admin', 'admin@slip.com'),
                      _buildDemoAccount('Analist', 'analist@slip.com'),
                      _buildDemoAccount('User', 'user@slip.com'),
                      const SizedBox(height: 8),
                      Text('Şifre: 123456', style: Theme.of(context).textTheme.bodySmall),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDemoAccount(String role, String email) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Chip(label: Text(role, style: const TextStyle(fontSize: 12)), padding: EdgeInsets.zero),
          const SizedBox(width: 8),
          Expanded(child: Text(email, style: const TextStyle(fontSize: 12))),
        ],
      ),
    );
  }
}
