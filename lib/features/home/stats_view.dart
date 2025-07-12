import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

class StatsView extends StatefulWidget {
  const StatsView({super.key});

  @override
  State<StatsView> createState() => _StatsViewState();
}

class _StatsViewState extends State<StatsView> {
  int totalStories = 0;
  int totalCorrectActions = 0;

  @override
  void initState() {
    super.initState();
    loadStats();
  }

  void loadStats() {
    final box = Hive.box('appBox');
    final allData = box.values.whereType<Map>().toList();

    int storiesCount = allData.length;
    int correctActionsCount = 0;

    for (final item in allData) {
      if (item.containsKey('correctActions') &&
          item['correctActions'] is List) {
        correctActionsCount += (item['correctActions'] as List).length;
      }
    }

    setState(() {
      totalStories = storiesCount;
      totalCorrectActions = correctActionsCount;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('آمار کلی',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
          const SizedBox(height: 24),
          Text('تعداد کل ماجراها ثبت شده: $totalStories',
              style: const TextStyle(fontSize: 18)),
          const SizedBox(height: 16),
          Text('تعداد کل کارهای درست انتخاب شده: $totalCorrectActions',
              style: const TextStyle(fontSize: 18)),
          // می‌تونی آمارهای بیشتری اضافه کنی
        ],
      ),
    );
  }
}
