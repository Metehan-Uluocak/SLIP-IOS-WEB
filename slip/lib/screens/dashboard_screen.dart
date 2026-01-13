import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';
import '../widgets/main_layout.dart';
import '../controllers/leak_controller.dart';

class DashboardScreen extends GetView<LeakController> {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MainLayout(
      title: 'Keşfet',
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
            child: Row(
              children: [
                Expanded(
                  child: Builder(
                    builder: (_) {
                      if (GetPlatform.isIOS) {
                        return CupertinoTextField(
                          placeholder: 'Ara (platform, başlık, özet)...',
                          prefix: const Padding(
                            padding: EdgeInsets.symmetric(horizontal: 8.0),
                            child: Icon(CupertinoIcons.search),
                          ),
                          onChanged: controller.setSearchQuery,
                        );
                      }
                      return SearchBar(
                        hintText: 'Ara (platform, başlık, özet)...',
                        leading: const Icon(Icons.search),
                        onChanged: controller.setSearchQuery,
                      );
                    },
                  ),
                ),
                const SizedBox(width: 12),
                Obx(
                  () => DropdownButton<String>(
                    hint: const Text('Platform'),
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
                    onChanged: controller.setFilterPlatform,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.refresh),
                  tooltip: 'Yenile',
                  onPressed: () => controller.fetchLeaks(),
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
                      elevation: 0,
                      color: Theme.of(
                        context,
                      ).colorScheme.surface.withValues(alpha: 0.6),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: ExpansionTile(
                        leading: CircleAvatar(
                          backgroundColor: Theme.of(
                            context,
                          ).colorScheme.primaryContainer,
                          child: Icon(
                            Icons.remove_red_eye,
                            color: Theme.of(
                              context,
                            ).colorScheme.onPrimaryContainer,
                          ),
                        ),
                        title: Text(
                          leak.title,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 4),
                            Row(
                              children: [
                                Icon(
                                  Icons.laptop,
                                  size: 14,
                                  color: Colors.white70,
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  leak.platformName,
                                  style: TextStyle(
                                    color: Theme.of(
                                      context,
                                    ).colorScheme.primary,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 2),
                            Row(
                              children: [
                                Icon(
                                  Icons.calendar_today,
                                  size: 14,
                                  color: Colors.white70,
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  _formatDate(leak.publishDate),
                                  style: Theme.of(context).textTheme.bodySmall,
                                ),
                                const SizedBox(width: 16),
                                Icon(
                                  Icons.source,
                                  size: 14,
                                  color: Colors.white70,
                                ),
                                const SizedBox(width: 4),
                                Expanded(
                                  child: Text(
                                    leak.sourceName,
                                    style: Theme.of(
                                      context,
                                    ).textTheme.bodySmall,
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
                                  'Özet',
                                  style: Theme.of(context).textTheme.titleSmall
                                      ?.copyWith(fontWeight: FontWeight.bold),
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
                                      onPressed: () =>
                                          _launchURL(leak.sourceUrl),
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
          Obx(() {
            final totalLeaks = controller.leaks.length;
            final filteredCount = controller.filteredLeaks.length;
            final platformCount = controller.availablePlatforms.length;

            return Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.06),
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(16),
                  topRight: Radius.circular(16),
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

  Widget _buildStatItem(
    BuildContext context,
    IconData icon,
    String label,
    String value,
  ) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 24, color: Theme.of(context).colorScheme.primary),
        const SizedBox(height: 4),
        Text(
          value,
          style: Theme.of(
            context,
          ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
        ),
        Text(label, style: Theme.of(context).textTheme.bodySmall),
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
