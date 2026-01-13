import 'package:get/get.dart';
import '../models/user.dart';
import '../services/api_service.dart';

class AuthController extends GetxController {
  static AuthController get instance => Get.find();
  
  final Rx<User?> _currentUser = Rx<User?>(null);
  final RxBool isLoading = false.obs;

  User? get currentUser => _currentUser.value;
  bool get isLoggedIn => _currentUser.value != null;

  @override
  void onInit() {
    super.onInit();
    ever(_currentUser, (_) {
    });
  }

  //AUTHORIZATION HELPERS

  bool hasRole(UserRole role) {
    return _currentUser.value?.role == role;
  }

  bool canManageSources() {
    return _currentUser.value?.role == UserRole.admin ||
        _currentUser.value?.role == UserRole.analist;
  }

  bool canManageUsers() {
    return _currentUser.value?.role == UserRole.admin;
  }

  bool canManagePlatforms() {
    return _currentUser.value?.role == UserRole.admin ||
        _currentUser.value?.role == UserRole.analist;
  }

  bool canViewLeaks() {
    return _currentUser.value != null;
  }

  Future<bool> login(String email, String password) async {
    try {
      isLoading.value = true;
      final user = await ApiService.login(email, password);
      _currentUser.value = user;
      return true;
    } catch (e) {
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  void logout() {
    _currentUser.value = null;
    Get.offAllNamed('/login');
  }

}


