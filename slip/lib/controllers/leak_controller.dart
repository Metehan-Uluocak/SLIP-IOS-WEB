import 'package:get/get.dart';
import '../models/leak.dart';
import '../services/api_service.dart';

class LeakController extends GetxController {
  final RxList<Leak> leaks = <Leak>[].obs;
  final RxBool isLoading = false.obs;
  final RxString searchQuery = ''.obs;
  final Rx<String?> filterPlatform = Rx<String?>(null);

  List<Leak> get filteredLeaks {
    var result = leaks.toList();

    if (searchQuery.value.isNotEmpty) {
      result = result
          .where(
            (leak) =>
                leak.title.toLowerCase().contains(
                  searchQuery.value.toLowerCase(),
                ) ||
                leak.platformName.toLowerCase().contains(
                  searchQuery.value.toLowerCase(),
                ) ||
                leak.summary.toLowerCase().contains(
                  searchQuery.value.toLowerCase(),
                ),
          )
          .toList();
    }

    if (filterPlatform.value != null) {
      result = result
          .where((leak) => leak.platformName == filterPlatform.value)
          .toList();
    }

    return result;
  }

  List<String> get availablePlatforms {
    return leaks.map((leak) => leak.platformName).toSet().toList()..sort();
  }

  @override
  void onInit() {
    super.onInit();
    fetchLeaks();
  }

  Future<void> fetchLeaks() async {
    try {
      isLoading.value = true;
      leaks.value = await ApiService.getLeaks();
    } catch (e) {
      Get.snackbar('Hata', 'Sızıntılar yüklenemedi: $e');
    } finally {
      isLoading.value = false;
    }
  }

  void setSearchQuery(String query) {
    searchQuery.value = query;
  }

  void setFilterPlatform(String? platform) {
    filterPlatform.value = platform;
  }
}
