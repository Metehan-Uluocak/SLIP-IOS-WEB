import 'package:get/get.dart';
import '../models/platform.dart';
import '../services/api_service.dart';

class PlatformController extends GetxController {
  final RxList<Platform> platforms = <Platform>[].obs;
  final RxBool isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    fetchPlatforms();
  }

  Future<void> fetchPlatforms() async {
    try {
      isLoading.value = true;
      platforms.value = await ApiService.getPlatforms();
    } catch (e) {
      Get.snackbar('Hata', 'Platformlar yüklenemedi: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> addPlatform(Platform platform) async {
    try {
      isLoading.value = true;
      final newPlatform = await ApiService.createPlatform(platform);
      platforms.add(newPlatform);
      Get.snackbar('Başarılı', 'Platform başarıyla eklendi');
      await fetchPlatforms();
    } catch (e) {
      Get.snackbar('Hata', 'Platform eklenemedi: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> updatePlatform(Platform platform) async {
    try {
      isLoading.value = true;
      await ApiService.updatePlatform(platform);
      final index = platforms.indexWhere((p) => p.id == platform.id);
      if (index != -1) {
        platforms[index] = platform;
      }
      Get.snackbar('Başarılı', 'Platform başarıyla güncellendi');
      await fetchPlatforms();
    } catch (e) {
      Get.snackbar('Hata', 'Platform güncellenemedi: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> deletePlatform(int id) async {
    try {
      isLoading.value = true;
      await ApiService.deletePlatform(id);
      platforms.removeWhere((p) => p.id == id);
      Get.snackbar('Başarılı', 'Platform başarıyla silindi');
    } catch (e) {
      Get.snackbar('Hata', 'Platform silinemedi: $e');
    } finally {
      isLoading.value = false;
    }
  }

  void refresh() {
    fetchPlatforms();
  }
}
