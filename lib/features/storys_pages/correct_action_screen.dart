import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive_flutter/hive_flutter.dart';

class CorrectActionScreen extends StatefulWidget {
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
  State<CorrectActionScreen> createState() => _CorrectActionScreenState();
}

class _CorrectActionScreenState extends State<CorrectActionScreen> {
  static const List<String> correctActions = [
    "علاقه‌مند به دیگران",
    "راستگو",
    "شجاع",
    "ملاحظه‌گر",
    "فروتنی",
    "بخشندگی",
    "خدمت",
    "آرام",
    "سپاسگزار",
    "اقدام کردن",
    "میانه‌روی",
    "صبور",
    "بردبار",
    "بخشایشگر",
    "عشق و توجه به دیگران",
    "اعمال نیک",
    "فراموش کردن خود",
    "عزت نفس",
    "ایمان",
  ];

  late Box _box;
  List<String> selectedActions = [];

  @override
  void initState() {
    super.initState();
    _box = Hive.box('appBox');
  }

  Future<void> _saveStoryWithActions(List<String> actions) async {
    final fullStoryData = {
      'story': widget.story,
      'emotion': widget.emotion,
      'deficiencies': widget.selectedDeficiencies,
      'harmedPeople': widget.harmedPeople['all'],
      'correctActions': actions,
      'createdAt': DateTime.now().toIso8601String(),
    };

    await _box.add(fullStoryData);
  }

  void _showActionSelector(BuildContext context) {
    final selected = <String>{};

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (_) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            void toggle(String action) {
              setModalState(() {
                if (selected.contains(action)) {
                  selected.remove(action);
                } else {
                  selected.add(action);
                }
              });
            }

            return Padding(
              padding: EdgeInsets.only(
                left: 16,
                right: 16,
                top: 16,
                bottom: MediaQuery.of(context).viewInsets.bottom + 16,
              ),
              child: Column(
                children: [
                  const Text(
                    'کارهای درست پیشنهادی را انتخاب کن:',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 12),
                  Expanded(
                    child: ListView(
                      children: correctActions.map((action) {
                        return CheckboxListTile(
                          title: Text(action),
                          value: selected.contains(action),
                          onChanged: (_) => toggle(action),
                        );
                      }).toList(),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      ElevatedButton(
                        onPressed: selected.isEmpty
                            ? null
                            : () {
                                final chosen = selected.toList();
                                Navigator.pop(context);
                                Future.delayed(
                                    const Duration(milliseconds: 300), () {
                                  if (mounted) {
                                    setState(() {
                                      selectedActions = chosen;
                                    });
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text(
                                            'تعداد ${chosen.length} کار درست انتخاب شد'),
                                      ),
                                    );
                                  }
                                });
                              },
                        child: const Text('تأیید'),
                      ),
                    ],
                  )
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget buildDarkCard(String title) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey.shade900,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        title,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 16,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final story = widget.story;
    final emotion = widget.emotion;
    final selectedDeficiencies = widget.selectedDeficiencies;
    final harmedPeople = widget.harmedPeople;

    return Scaffold(
      appBar: AppBar(title: const Text('کار درست چه بود؟')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('ماجرا:',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            buildDarkCard(story),
            const SizedBox(height: 16),
            const Text('نقش:',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            buildDarkCard(emotion),
            const SizedBox(height: 24),
            if (selectedDeficiencies.isNotEmpty) ...[
              const Text('نواقص:',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 12,
                children: selectedDeficiencies.map(buildDarkCard).toList(),
              ),
              const SizedBox(height: 24),
            ],
            if (harmedPeople.containsKey('all') &&
                harmedPeople['all']!.isNotEmpty) ...[
              const Text(
                'افراد آسیب‌دیده:',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 12,
                children: harmedPeople['all']!.map(buildDarkCard).toList(),
              ),
              const SizedBox(height: 24),
            ],
            if (selectedActions.isEmpty)
              Center(
                child: ElevatedButton(
                  onPressed: () => _showActionSelector(context),
                  child: const Text('انتخاب کارهای درست'),
                ),
              ),
            if (selectedActions.isNotEmpty) ...[
              const SizedBox(height: 32),
              const Text('کارهای درست انتخاب شده:',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 12),
              Wrap(
                spacing: 8,
                runSpacing: 12,
                children: selectedActions.map(buildDarkCard).toList(),
              ),
              const SizedBox(height: 24),
              ElevatedButton.icon(
                onPressed: () async {
                  await _saveStoryWithActions(selectedActions);
                  if (mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('با موفقیت ذخیره شد')),
                    );
                  }
                },
                icon: const Icon(Icons.save),
                label: const Text('ذخیره'),
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size.fromHeight(50),
                ),
              ),
              const SizedBox(height: 12),
              ElevatedButton.icon(
                onPressed: () async {
                  await _saveStoryWithActions(selectedActions);
                  final text = selectedActions.join('، ');
                  await Clipboard.setData(ClipboardData(text: text));
                  if (mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                          content: Text('ذخیره شد و در کلیپ‌بورد کپی شد')),
                    );
                  }
                },
                icon: const Icon(Icons.copy),
                label: const Text('ذخیره و کپی برای ارسال به شخص دیگر'),
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size.fromHeight(50),
                ),
              )
            ]
          ],
        ),
      ),
    );
  }
}
