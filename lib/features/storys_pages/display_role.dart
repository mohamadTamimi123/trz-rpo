import 'package:flutter/material.dart';
import 'harmed_people_screen.dart'; // مسیر صفحه بعدی

class DisplayRole extends StatefulWidget {
  final String message;
  final String emotion;

  const DisplayRole({
    super.key,
    required this.message,
    required this.emotion,
  });

  @override
  State<DisplayRole> createState() => _DisplayRoleState();
}

class _DisplayRoleState extends State<DisplayRole> {
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
    'بی‌وفایی'
  ];

  List<List<dynamic>> _somewhatRelevantList = [];

  @override
  void initState() {
    super.initState();
    _manualDeficiencySelection();
  }

  void _manualDeficiencySelection() {
    setState(() {
      _somewhatRelevantList = allDeficiencies.map((e) => [e, '']).toList();
    });
  }

  void _showDeficiencySelector() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (_) => FractionallySizedBox(
        heightFactor: 0.9,
        child: _buildMultiSelectSheet(),
      ),
    );
  }

  Widget _buildMultiSelectSheet() {
    final selected = <String>{};

    return StatefulBuilder(
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
                'نواقص موردنظر را انتخاب کنید:',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              Expanded(
                child: ListView(
                  children: _somewhatRelevantList.map((item) {
                    return CheckboxListTile(
                      title: Text(item[0]),
                      value: selected.contains(item[0]),
                      onChanged: (_) => toggle(item[0]),
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
                            Navigator.pop(context);
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => HarmedPeopleScreen(
                                  story: widget.message,
                                  emotion: widget.emotion,
                                  selectedDeficiencies: selected.toList(),
                                ),
                              ),
                            );
                          },
                    child: const Text('تأیید و ادامه'),
                  ),
                ],
              )
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('تحلیل دستی نواقص')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('ماجرا:',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.grey.shade900,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(widget.message,
                  style: const TextStyle(fontSize: 16, color: Colors.white)),
            ),
            const SizedBox(height: 16),
            const Text('نقش:',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.grey.shade900,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(widget.emotion,
                  style: const TextStyle(fontSize: 16, color: Colors.white)),
            ),
            const SizedBox(height: 24),
            Center(
              child: ElevatedButton(
                onPressed: _showDeficiencySelector,
                child: const Text('انتخاب نقص‌ها و ادامه'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
