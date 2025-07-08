import 'package:flutter/material.dart';

class CorrectActionScreen extends StatelessWidget {
  final String story;
  final String emotion;
  final Map<String, List<String>> harmedPeople;
  final List<String> selectedDeficiencies;

  const CorrectActionScreen({
    super.key,
    required this.story,
    required this.emotion,
    required this.selectedDeficiencies,
    required this.harmedPeople,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('کار درست چه بود؟')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('ماجرا: $story'),
            const SizedBox(height: 8),
            Text('احساس: $emotion'),
            const SizedBox(height: 16),
            Text('افراد آسیب‌دیده:',
                style: const TextStyle(fontWeight: FontWeight.bold)),
            ...harmedPeople.entries.map((entry) {
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 4),
                child: Text('${entry.key}: ${entry.value.join(', ')}'),
              );
            }),
            const SizedBox(height: 24),
            const Text(
                'در این قسمت می‌توان راه درست را از دید کاربر دریافت یا پیشنهاد کرد.'),
          ],
        ),
      ),
    );
  }
}
