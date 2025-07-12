import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

class EditStoryPage extends StatefulWidget {
  final dynamic hiveKey;
  final Map<String, dynamic> initialData;

  const EditStoryPage({
    super.key,
    required this.hiveKey,
    required this.initialData,
  });

  @override
  State<EditStoryPage> createState() => _EditStoryPageState();
}

class _EditStoryPageState extends State<EditStoryPage> {
  late TextEditingController storyController;
  List<String> deficiencies = [];
  List<String> harmedPeople = [];
  List<String> correctActions = [];
  String? _selectedEmotion;

  final List<String> emotions = [
    'رنجش و دلچرکین شدن',
    'ترس',
    'احساس گناه، شرم و خجالت',
    'غم و اندوه',
    'افسردگی و ناامیدی',
  ];

  final List<String> allDeficiencies = [
    'خشم',
    'ناصادقی',
    'حسادت',
    'پرخوری / افراط در خوردن',
    'خودبزرگ‌بینی',
    'طمع',
    'آسیب رساندن',
    'نفرت',
    'بی‌صبری',
    'بی‌توجهی به دیگران',
    'تعصب / عدم تحمل',
    'تن‌پروری',
    'شهوت‌گرایی',
    'غرور',
    'تعلل / اهمال‌کاری',
    'سرزنش خود',
    'حق به جانب بودن',
    'ترحم به حال خود',
    'خودمحوری',
    'بدبینی',
    'بی‌وفایی',
  ];

  final List<String> allCorrectActions = [
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

  @override
  void initState() {
    super.initState();
    storyController = TextEditingController(text: widget.initialData['story']);
    _selectedEmotion = widget.initialData['emotion'];
    deficiencies = List<String>.from(widget.initialData['deficiencies'] ?? []);
    harmedPeople = List<String>.from(widget.initialData['harmedPeople'] ?? []);
    correctActions =
        List<String>.from(widget.initialData['correctActions'] ?? []);
  }

  Future<void> saveChanges() async {
    final box = Hive.box('appBox');

    final newData = {
      'story': storyController.text.trim(),
      'emotion': _selectedEmotion,
      'deficiencies': deficiencies,
      'harmedPeople': harmedPeople,
      'correctActions': correctActions,
      'createdAt': widget.initialData['createdAt'],
    };

    await box.put(widget.hiveKey, newData);

    if (mounted) {
      Navigator.pop(context, true);
    }
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

  void _showCorrectActionsSelector() {
    final selected = Set<String>.from(correctActions);

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (_) => FractionallySizedBox(
        heightFactor: 0.9,
        child: StatefulBuilder(
          builder: (context, setModalState) {
            void toggle(String val) {
              setModalState(() {
                if (selected.contains(val)) {
                  selected.remove(val);
                } else {
                  selected.add(val);
                }
              });
            }

            void selectAll() =>
                setModalState(() => selected.addAll(allCorrectActions));
            void unselectAll() => setModalState(() => selected.clear());

            return Padding(
              padding: EdgeInsets.only(
                left: 16,
                right: 16,
                top: 16,
                bottom: MediaQuery.of(context).viewInsets.bottom + 16,
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      const Expanded(
                        child: Text(
                          'کارهای درست موردنظر را انتخاب کنید:',
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                      ),
                      TextButton(
                          onPressed: selectAll,
                          child: const Text('انتخاب همه')),
                      TextButton(
                          onPressed: unselectAll, child: const Text('لغو همه')),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Expanded(
                    child: ListView(
                      children: allCorrectActions.map((item) {
                        return CheckboxListTile(
                          title: Text(item),
                          value: selected.contains(item),
                          onChanged: (_) => toggle(item),
                        );
                      }).toList(),
                    ),
                  ),
                  Align(
                    alignment: Alignment.bottomRight,
                    child: ElevatedButton(
                      onPressed: () {
                        setState(() {
                          correctActions = selected.toList();
                        });
                        Navigator.pop(context);
                      },
                      child: const Text('تأیید'),
                    ),
                  )
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  // سایر توابع بدون تغییر باقی می‌مانند (برای اختصار حذف شده)

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('ویرایش آیتم')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: storyController,
              maxLines: 4,
              decoration: const InputDecoration(
                labelText: 'ماجرا',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            // سایر ویجت‌ها
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: saveChanges,
                child: const Text('ذخیره تغییرات'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
