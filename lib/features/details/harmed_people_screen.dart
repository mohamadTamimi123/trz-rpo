import 'package:flutter/material.dart';
import 'correct_action_screen.dart';

class HarmedPeopleScreen extends StatefulWidget {
  final String story;
  final String emotion;
  final List<String> selectedDeficiencies;

  const HarmedPeopleScreen({
    super.key,
    required this.story,
    required this.emotion,
    required this.selectedDeficiencies,
  });

  @override
  State<HarmedPeopleScreen> createState() => _HarmedPeopleScreenState();
}

class _HarmedPeopleScreenState extends State<HarmedPeopleScreen> {
  final List<TextEditingController> _controllers = [TextEditingController()];

  void addPerson() {
    setState(() {
      _controllers.add(TextEditingController());
    });
  }

  void onSubmit() {
    final harmedPeople = _controllers
        .map((controller) => controller.text.trim())
        .where((name) => name.isNotEmpty)
        .toList();

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CorrectActionScreen(
          story: widget.story,
          emotion: widget.emotion,
          selectedDeficiencies: widget.selectedDeficiencies,
          harmedPeople: {'all': harmedPeople},
        ),
      ),
    );
  }

  @override
  void dispose() {
    for (var controller in _controllers) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('افراد آسیب‌دیده')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: [
            const Text(
              'چه افرادی در این ماجرا ممکن است آسیب دیده باشند؟',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            ..._controllers.asMap().entries.map((entry) {
              final index = entry.key;
              final controller = entry.value;
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 4),
                child: TextField(
                  textDirection: TextDirection.rtl,
                  controller: controller,
                  decoration: InputDecoration(
                    labelText: 'نام فرد آسیب‌دیده ${index + 1}',
                    border: const OutlineInputBorder(),
                  ),
                ),
              );
            }),
            const SizedBox(height: 8),
            Align(
              alignment: Alignment.centerLeft,
              child: TextButton.icon(
                onPressed: addPerson,
                icon: const Icon(Icons.person_add),
                label: const Text('افزودن فرد جدید'),
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: onSubmit,
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
                minimumSize: const Size.fromHeight(50),
              ),
              child: const Text('تأیید و ادامه'),
            ),
          ],
        ),
      ),
    );
  }
}
