import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';
import '../edit_story/EditStoryPage.dart';

class HistoryView extends StatefulWidget {
  const HistoryView({super.key});

  @override
  State<HistoryView> createState() => _HistoryViewState();
}

class _HistoryViewState extends State<HistoryView> {
  List<Map<String, dynamic>> stories = [];
  List<dynamic> keys = [];

  @override
  void initState() {
    super.initState();
    loadStories();
  }

  void loadStories() {
    final box = Hive.box('appBox');

    final loaded = <Map<String, dynamic>>[];
    final loadedKeys = <dynamic>[];

    for (int i = 0; i < box.length; i++) {
      final value = box.getAt(i);
      if (value is Map &&
          value.containsKey('story') &&
          value.containsKey('emotion')) {
        loaded.add(Map<String, dynamic>.from(value));
        loadedKeys.add(box.keyAt(i));
      }
    }

    setState(() {
      stories = loaded.reversed.toList();
      keys = loadedKeys.reversed
          .toList(); // کلیدها را هم معکوس کن تا مطابق با ترتیب داستان‌ها باشد
    });
  }

  String formatDate(String isoDate) {
    try {
      final date = DateTime.parse(isoDate);
      return DateFormat('yyyy/MM/dd – HH:mm').format(date);
    } catch (_) {
      return 'تاریخ نامعتبر';
    }
  }

  Future<void> deleteStory(int index) async {
    final box = Hive.box('appBox');
    final key = keys[index];

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('حذف'),
        content: const Text('آیا مطمئنی می‌خواهی این مورد را حذف کنی؟'),
        actions: [
          TextButton(
            child: const Text('لغو'),
            onPressed: () => Navigator.pop(context, false),
          ),
          TextButton(
            child: const Text('حذف'),
            onPressed: () => Navigator.pop(context, true),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      await box.delete(key);
      loadStories();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('با موفقیت حذف شد')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (stories.isEmpty) {
      return const Center(child: Text('تاکنون چیزی ثبت نشده است.'));
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: stories.length,
      itemBuilder: (context, index) {
        final story = stories[index];
        final createdAt = story['createdAt'] ?? '';

        return Card(
          margin: const EdgeInsets.symmetric(vertical: 8),
          color: Colors.grey.shade900,
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("📝 ماجرا:",
                    style: TextStyle(
                        color: Colors.tealAccent.shade100,
                        fontWeight: FontWeight.bold)),
                const SizedBox(height: 4),
                Text(
                  story['story'] ?? '',
                  style: const TextStyle(color: Colors.white),
                ),
                const SizedBox(height: 12),
                if (story['emotion'] != null) ...[
                  Text("🎭 نقش:",
                      style: TextStyle(
                          color: Colors.tealAccent.shade100,
                          fontWeight: FontWeight.bold)),
                  const SizedBox(height: 4),
                  Text(
                    story['emotion'],
                    style: const TextStyle(color: Colors.white),
                  ),
                  const SizedBox(height: 12),
                ],
                if (story['correctActions'] != null &&
                    story['correctActions'] is List &&
                    (story['correctActions'] as List).isNotEmpty) ...[
                  Text("✅ کارهای درست:",
                      style: TextStyle(
                          color: Colors.tealAccent.shade100,
                          fontWeight: FontWeight.bold)),
                  const SizedBox(height: 4),
                  Wrap(
                    spacing: 6,
                    children: (story['correctActions'] as List)
                        .map((e) => Chip(
                              label: Text(e),
                              backgroundColor: Colors.teal.shade700,
                              labelStyle: const TextStyle(color: Colors.white),
                            ))
                        .toList(),
                  ),
                  const SizedBox(height: 12),
                ],
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      formatDate(createdAt),
                      style:
                          TextStyle(color: Colors.grey.shade400, fontSize: 12),
                    ),
                    Row(
                      children: [
                        IconButton(
                          onPressed: () async {
                            final result = await Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => EditStoryPage(
                                  hiveKey: keys[index],
                                  initialData: story,
                                ),
                              ),
                            );
                            if (result == true) loadStories();
                          },
                          icon: const Icon(Icons.edit, color: Colors.orange),
                          tooltip: 'ویرایش',
                        ),
                        IconButton(
                          onPressed: () => deleteStory(index),
                          icon:
                              const Icon(Icons.delete, color: Colors.redAccent),
                          tooltip: 'حذف',
                        ),
                      ],
                    ),
                  ],
                )
              ],
            ),
          ),
        );
      },
    );
  }
}
