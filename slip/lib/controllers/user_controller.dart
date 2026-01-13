import 'package:get/get.dart';
import '../models/user.dart';
import '../services/api_service.dart';

class UserController extends GetxController {
  final RxList<User> users = <User>[].obs;
  final RxBool isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    fetchUsers();
  }

  Future<void> fetchUsers() async {
    try {
      isLoading.value = true;
      users.value = await ApiService.getUsers();
    } catch (e) {
      Get.snackbar('Hata', 'Kullanıcılar yüklenemedi: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> addUser(User user) async {
    try {
      isLoading.value = true;
      final newUser = await ApiService.createUser(user);
      users.add(newUser);
      Get.snackbar('Başarılı', 'Kullanıcı başarıyla eklendi');
      await fetchUsers();
    } catch (e) {
      Get.snackbar('Hata', 'Kullanıcı eklenemedi: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> updateUser(User user) async {
    try {
      isLoading.value = true;
      await ApiService.updateUser(user);
      final index = users.indexWhere((u) => u.id == user.id);
      if (index != -1) {
        users[index] = user;
      }
      Get.snackbar('Başarılı', 'Kullanıcı başarıyla güncellendi');
      await fetchUsers();
    } catch (e) {
      Get.snackbar('Hata', 'Kullanıcı güncellenemedi: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> deleteUser(int id) async {
    try {
      isLoading.value = true;
      await ApiService.deleteUser(id);
      users.removeWhere((u) => u.id == id);
      Get.snackbar('Başarılı', 'Kullanıcı başarıyla silindi');
    } catch (e) {
      Get.snackbar('Hata', 'Kullanıcı silinemedi: $e');
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void refresh() {
    fetchUsers();
  }
}
