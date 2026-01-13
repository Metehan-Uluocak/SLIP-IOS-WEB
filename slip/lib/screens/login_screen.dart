import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'dart:ui';
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

    // iOS özel düzen: tamamen farklı duruş (full-screen gradient + glass panel)
    if (GetPlatform.isIOS) {
      return CupertinoPageScaffold(
        child: Stack(
          children: [
            // Gradient background
            Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFF0B1020), Color(0xFF4C78FF)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
            ),
            SafeArea(
              child: Center(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(24.0),
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 520),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(24),
                      child: BackdropFilter(
                        filter: ImageFilter.blur(sigmaX: 14, sigmaY: 14),
                        child: Container(
                          padding: const EdgeInsets.all(28),
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.10),
                            borderRadius: BorderRadius.circular(24),
                            border: Border.all(
                              color: Colors.white.withValues(alpha: 0.25),
                            ),
                          ),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(
                                CupertinoIcons.eye,
                                size: 72,
                                color: Colors.white,
                              ),
                              const SizedBox(height: 12),
                              const Text(
                                'SLIP',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 28,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 8),
                              const Text(
                                'Security Leak Intelligence Platform',
                                textAlign: TextAlign.center,
                                style: TextStyle(color: Colors.white70),
                              ),
                              const SizedBox(height: 24),
                              CupertinoTextField(
                                controller: emailController,
                                placeholder: 'Email',
                                keyboardType: TextInputType.emailAddress,
                                prefix: const Padding(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 8.0,
                                  ),
                                  child: Icon(
                                    CupertinoIcons.mail,
                                    color: Colors.white70,
                                  ),
                                ),
                                style: const TextStyle(color: Colors.white),
                                decoration: BoxDecoration(
                                  color: Colors.white.withValues(alpha: 0.08),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              const SizedBox(height: 16),
                              CupertinoTextField(
                                controller: passwordController,
                                placeholder: 'Şifre',
                                obscureText: true,
                                prefix: const Padding(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 8.0,
                                  ),
                                  child: Icon(
                                    CupertinoIcons.lock,
                                    color: Colors.white70,
                                  ),
                                ),
                                style: const TextStyle(color: Colors.white),
                                decoration: BoxDecoration(
                                  color: Colors.white.withValues(alpha: 0.08),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              const SizedBox(height: 20),
                              Obx(
                                () => SizedBox(
                                  width: double.infinity,
                                  child: CupertinoButton.filled(
                                    onPressed: controller.isLoading.value
                                        ? null
                                        : () async {
                                            final email = emailController.text
                                                .trim();
                                            final pass =
                                                passwordController.text;
                                            if (email.isEmpty || pass.isEmpty) {
                                              _showIosError(
                                                context,
                                                'Email ve şifre gerekli',
                                              );
                                              return;
                                            }
                                            final success = await controller
                                                .login(email, pass);
                                            if (!context.mounted) return;
                                            if (success) {
                                              Get.offAllNamed(
                                                AppRoutes.dashboard,
                                              );
                                            } else {
                                              _showIosError(
                                                context,
                                                'Email veya şifre hatalı',
                                              );
                                            }
                                          },
                                    child: controller.isLoading.value
                                        ? const CupertinoActivityIndicator()
                                        : const Text('Giriş Yap'),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 16),
                              const Divider(color: Colors.white24),
                              const SizedBox(height: 12),
                              const Text(
                                'Demo Hesapları:',
                                style: TextStyle(color: Colors.white70),
                              ),
                              const SizedBox(height: 8),
                              _buildDemoAccount('Admin', 'admin@slip.com'),
                              _buildDemoAccount('Analist', 'analist@slip.com'),
                              _buildDemoAccount('User', 'user@slip.com'),
                              const SizedBox(height: 8),
                              const Text(
                                'Şifre: 123456',
                                style: TextStyle(color: Colors.white54),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    }

    // Diğer platformlar için mevcut Material düzeni
    // Material: tamamen farklı duruş (full-screen gradient + glass panel)
    return Scaffold(
      appBar: null,
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF0B1020), Color(0xFF5E5CE6)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
          ),
          Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24.0),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 520),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(24),
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 14, sigmaY: 14),
                    child: Container(
                      padding: const EdgeInsets.all(28),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.10),
                        borderRadius: BorderRadius.circular(24),
                        border: Border.all(
                          color: Colors.white.withValues(alpha: 0.25),
                        ),
                      ),
                      child: Form(
                        key: formKey,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(
                              Icons.visibility,
                              size: 72,
                              color: Colors.white,
                            ),
                            const SizedBox(height: 12),
                            const Text(
                              'SLIP',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 28,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 8),
                            const Text(
                              'Security Leak Intelligence Platform',
                              textAlign: TextAlign.center,
                              style: TextStyle(color: Colors.white70),
                            ),
                            const SizedBox(height: 24),
                            TextFormField(
                              controller: emailController,
                              style: const TextStyle(color: Colors.white),
                              decoration: const InputDecoration(
                                labelText: 'Email',
                                prefixIcon: Icon(
                                  Icons.email,
                                  color: Colors.white70,
                                ),
                              ),
                              validator: (value) => value?.isEmpty ?? true
                                  ? 'Email gerekli'
                                  : null,
                            ),
                            const SizedBox(height: 16),
                            TextFormField(
                              controller: passwordController,
                              style: const TextStyle(color: Colors.white),
                              decoration: const InputDecoration(
                                labelText: 'Şifre',
                                prefixIcon: Icon(
                                  Icons.lock,
                                  color: Colors.white70,
                                ),
                              ),
                              obscureText: true,
                              validator: (value) => value?.isEmpty ?? true
                                  ? 'Şifre gerekli'
                                  : null,
                            ),
                            const SizedBox(height: 20),
                            Obx(
                              () => SizedBox(
                                width: double.infinity,
                                child: ElevatedButton(
                                  onPressed: controller.isLoading.value
                                      ? null
                                      : () async {
                                          if (formKey.currentState!
                                              .validate()) {
                                            final success = await controller
                                                .login(
                                                  emailController.text.trim(),
                                                  passwordController.text,
                                                );
                                            if (success) {
                                              Get.offAllNamed(
                                                AppRoutes.dashboard,
                                              );
                                            } else {
                                              Get.snackbar(
                                                'Hata',
                                                'Email veya şifre hatalı',
                                                snackPosition:
                                                    SnackPosition.BOTTOM,
                                              );
                                            }
                                          }
                                        },
                                  child: controller.isLoading.value
                                      ? const SizedBox(
                                          height: 20,
                                          width: 20,
                                          child: CircularProgressIndicator(
                                            strokeWidth: 2,
                                          ),
                                        )
                                      : const Text('Giriş Yap'),
                                ),
                              ),
                            ),
                            const SizedBox(height: 16),
                            const Divider(color: Colors.white24),
                            const SizedBox(height: 12),
                            const Text(
                              'Demo Hesapları:',
                              style: TextStyle(color: Colors.white70),
                            ),
                            const SizedBox(height: 8),
                            _buildDemoAccount('Admin', 'admin@slip.com'),
                            _buildDemoAccount('Analist', 'analist@slip.com'),
                            _buildDemoAccount('User', 'user@slip.com'),
                            const SizedBox(height: 8),
                            const Text(
                              'Şifre: 123456',
                              style: TextStyle(color: Colors.white54),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDemoAccount(String role, String email) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Chip(
            label: Text(role, style: const TextStyle(fontSize: 12)),
            padding: EdgeInsets.zero,
          ),
          const SizedBox(width: 8),
          Expanded(child: Text(email, style: const TextStyle(fontSize: 12))),
        ],
      ),
    );
  }

  void _showIosError(BuildContext context, String message) {
    showCupertinoDialog(
      context: context,
      builder: (ctx) => CupertinoAlertDialog(
        title: const Text('Hata'),
        content: Text(message),
        actions: [
          CupertinoDialogAction(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Tamam'),
          ),
        ],
      ),
    );
  }
}
