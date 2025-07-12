import 'package:flutter/material.dart';

class StoryInputWidget extends StatelessWidget {
  final TextEditingController controller;
  final VoidCallback onSend;

  const StoryInputWidget({
    super.key,
    required this.controller,
    required this.onSend,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Text(
            'شرح ماجرا :',
            style: TextStyle(fontSize: 18),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: controller,
            maxLines: 5,
            decoration: const InputDecoration(
              hintText: 'بنویس...',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: onSend,
            child: const Text('ارسال'),
          ),
        ],
      ),
    );
  }
}
