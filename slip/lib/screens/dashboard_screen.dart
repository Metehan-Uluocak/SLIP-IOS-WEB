import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';
import '../widgets/main_layout.dart';
import '../controllers/leak_controller.dart';

class DashboardScreen extends GetView<LeakController> {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MainLayout(
      title: 'Dashboard',
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    decoration: const InputDecoration(
                      labelText: 'Ara...',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.search),
                      hintText: 'Platform, başlık veya özet ara',
                    ),
                    onChanged: (value) => controller.setSearchQuery(value),
                  ),
                ),
                const SizedBox(width: 16),
                Obx(() => DropdownButton<String>(
                  hint: const Text('Platform Filtrele'),
                  value: controller.filterPlatform.value,
                  items: [
                    const DropdownMenuItem(value: null, child: Text('Tümü')),
                    ...controller.availablePlatforms.map(
                      (platform) => DropdownMenuItem(
                        value: platform,
                        child: Text(platform),
                      ),
                    ),
                  ],
                  onChanged: (value) => controller.setFilterPlatform(value),
                )),
                const SizedBox(width: 8),
                IconButton(
                  icon: const Icon(Icons.refresh),
                  tooltip: 'Yenile',
                  onPressed: () => controller.refresh(),
                ),
              ],
            ),
          ),
          Expanded(
            child: Obx(() {
              if (controller.isLoading.value) {
                return const Center(child: CircularProgressIndicator());
              }

              final filteredLeaks = controller.filteredLeaks;

              if (filteredLeaks.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.info_outline,
                        size: 64,
                        color: Colors.grey.shade400,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        controller.searchQuery.value.isNotEmpty || 
                        controller.filterPlatform.value != null
                            ? 'Arama kriterlerine uygun sızıntı bulunamadı'
                            : 'Henüz sızıntı bulunmuyor',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                    ],
                  ),
                );
              }

              return RefreshIndicator(
                onRefresh: () => controller.fetchLeaks(),
                child: ListView.builder(
                  itemCount: filteredLeaks.length,
                  itemBuilder: (context, index) {
                    final leak = filteredLeaks[index];
                    return Card(
                      margin: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      elevation: 2,
                      child: ExpansionTile(
                        leading: CircleAvatar(
                          backgroundColor: Theme.of(context).colorScheme.errorContainer,
                          child: Icon(
                            Icons.warning_amber,
                            color: Theme.of(context).colorScheme.error,
                          ),
                        ),
                        title: Text(
                          leak.title,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 4),
                            Row(
                              children: [
                                Icon(Icons.laptop, size: 14, color: Colors.grey.shade600),
                                const SizedBox(width: 4),
                                Text(
                                  leak.platformName,
                                  style: TextStyle(
                                    color: Theme.of(context).colorScheme.primary,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 2),
                            Row(
                              children: [
                                Icon(Icons.calendar_today, size: 14, color: Colors.grey.shade600),
                                const SizedBox(width: 4),
                                Text(
                                  _formatDate(leak.publishDate),
                                  style: Theme.of(context).textTheme.bodySmall,
                                ),
                                const SizedBox(width: 16),
                                Icon(Icons.source, size: 14, color: Colors.grey.shade600),
                                const SizedBox(width: 4),
                                Expanded(
                                  child: Text(
                                    leak.sourceName,
                                    style: Theme.of(context).textTheme.bodySmall,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Özet:',
                                  style: Theme.of(context).textTheme.titleSmall,
                                ),
                                const SizedBox(height: 8),
                                Text(leak.summary),
                                const SizedBox(height: 16),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    TextButton.icon(
                                      icon: const Icon(Icons.open_in_new),
                                      label: const Text('Kaynağı Görüntüle'),
                                      onPressed: () => _launchURL(leak.sourceUrl),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              );
            }),
          ),
          // İstatistik kartı
          Obx(() {
            final totalLeaks = controller.leaks.length;
            final filteredCount = controller.filteredLeaks.length;
            final platformCount = controller.availablePlatforms.length;

            return Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surfaceContainerHighest,
                border: Border(
                  top: BorderSide(
                    color: Theme.of(context).colorScheme.outline,
                    width: 1,
                  ),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildStatItem(
                    context,
                    Icons.warning_amber,
                    'Toplam Sızıntı',
                    totalLeaks.toString(),
                  ),
                  _buildStatItem(
                    context,
                    Icons.filter_list,
                    'Filtrelenmiş',
                    filteredCount.toString(),
                  ),
                  _buildStatItem(
                    context,
                    Icons.laptop,
                    'Platform',
                    platformCount.toString(),
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildStatItem(BuildContext context, IconData icon, String label, String value) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 24, color: Theme.of(context).colorScheme.primary),
        const SizedBox(height: 4),
        Text(
          value,
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          label,
          style: Theme.of(context).textTheme.bodySmall,
        ),
      ],
    );
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays == 0) {
      return 'Bugün';
    } else if (difference.inDays == 1) {
      return 'Dün';
    } else if (difference.inDays < 7) {
      return '${difference.inDays} gün önce';
    } else {
      return '${date.day}/${date.month}/${date.year}';
    }
  }

  Future<void> _launchURL(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      Get.snackbar(
        'Hata',
        'URL açılamadı: $url',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }
}
