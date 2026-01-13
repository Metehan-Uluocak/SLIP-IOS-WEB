import 'package:get/get.dart';
import '../models/source.dart';
import '../services/api_service.dart';

class SourceController extends GetxController {
  final RxList<Source> sources = <Source>[].obs;
  final RxBool isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    fetchSources();
  }

  Future<void> fetchSources() async {
    try {
      isLoading.value = true;
      sources.value = await ApiService.getSources();
    } catch (e) {
      Get.snackbar('Hata', 'Kaynaklar yüklenemedi: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> addSource(Source source) async {
    try {
      isLoading.value = true;
      final newSource = await ApiService.createSource(source);
      sources.add(newSource);
      Get.snackbar('Başarılı', 'Kaynak başarıyla eklendi');
      await fetchSources();
    } catch (e) {
      Get.snackbar('Hata', 'Kaynak eklenemedi: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> updateSource(Source source) async {
    try {
      isLoading.value = true;
      await ApiService.updateSource(source);
      final index = sources.indexWhere((s) => s.id == source.id);
      if (index != -1) {
        sources[index] = source;
      }
      Get.snackbar('Başarılı', 'Kaynak başarıyla güncellendi');
      await fetchSources();
    } catch (e) {
      Get.snackbar('Hata', 'Kaynak güncellenemedi: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> deleteSource(int id) async {
    try {
      isLoading.value = true;
      await ApiService.deleteSource(id);
      sources.removeWhere((s) => s.id == id);
      Get.snackbar('Başarılı', 'Kaynak başarıyla silindi');
    } catch (e) {
      Get.snackbar('Hata', 'Kaynak silinemedi: $e');
    } finally {
      isLoading.value = false;
    }
  }

  void refresh() {
    fetchSources();
  }
}
