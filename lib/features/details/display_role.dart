import 'dart:convert';
import 'package:flutter/material.dart';
import '../../services/api_service.dart';
import 'harmed_people_screen.dart'; // مسیر فایل صفحه بعدی (مطمئن شو درست باشه)

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
  bool _isLoading = true;
  List<List<dynamic>> _mostRelevantList = [];
  List<List<dynamic>> _somewhatRelevantList = [];
  List<String> _unrelatedList = [];

  @override
  void initState() {
    super.initState();
    getData();
  }

  Future<void> getData() async {
    setState(() {
      _isLoading = true;
    });

    int retryCount = 0;
    const int maxRetries = 3;

    while (retryCount < maxRetries) {
      try {
        final result =
            await ApiService.getSelfWill(widget.message, widget.emotion);

        final decoded = jsonDecode(result);
        final mostRelevant = decoded['مرتبط‌ترین‌ها'] ?? [];
        final somewhatRelevant = decoded['کم‌ارتباط‌ها'] ?? [];
        final unrelated = decoded['بی‌ارتباط‌ها'] ?? [];

        setState(() {
          _mostRelevantList = List<List<dynamic>>.from(
              mostRelevant.map((e) => List<String>.from(e)));
          _somewhatRelevantList = List<List<dynamic>>.from(
              somewhatRelevant.map((e) => List<String>.from(e)));
          _unrelatedList = List<String>.from(unrelated);
          _isLoading = false;
        });

        // موفقیت‌آمیز بود، از حلقه خارج شو
        return;
      } catch (e) {
        retryCount++;

        // اگر آخرین تلاش بود، ارور را نمایش بده
        if (retryCount == maxRetries) {
          setState(() {
            _isLoading = false;
          });
          _showErrorDialog('خطا در دریافت اطلاعات: ${e.toString()}');
          return;
        }

        // کمی صبر کن قبل از تلاش مجدد (اختیاری)
        await Future.delayed(const Duration(seconds: 1));
      }
    }
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('خطا در دریافت پاسخ'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              getData();
            },
            child: const Text('تلاش مجدد'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _manualDeficiencySelection();
            },
            child: const Text('انتخاب دستی نقص‌ها'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text('بستن'),
          ),
        ],
      ),
    );
  }

  void _manualDeficiencySelection() {
    // اگر لازم بود می‌تونی اینجا لیست‌ها رو خالی یا با مقادیر پیش‌فرض مقداردهی کنی
    setState(() {
      _mostRelevantList = [];
      _somewhatRelevantList = [];
      _unrelatedList = ['نقص شماره ۱', 'نقص شماره ۲', 'نقص شماره ۳'];
    });

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

        Widget buildSection(String title, List<Widget> children) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 12),
              Text(
                title,
                style:
                    const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 6),
              ...children
            ],
          );
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
                'موارد دلخواه خود را برای ادامه تحلیل انتخاب کنید:',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              Expanded(
                child: ListView(
                  children: [
                    if (_mostRelevantList.isNotEmpty)
                      buildSection(
                        '🔴 مرتبط‌ترین‌ها',
                        _mostRelevantList.map((item) {
                          return CheckboxListTile(
                            title: Text(item[0]),
                            subtitle: Text(item[1]),
                            value: selected.contains(item[0]),
                            onChanged: (_) => toggle(item[0]),
                          );
                        }).toList(),
                      ),
                    if (_somewhatRelevantList.isNotEmpty)
                      buildSection(
                        '🟠 کم‌ارتباط‌ها',
                        _somewhatRelevantList.map((item) {
                          return CheckboxListTile(
                            title: Text(item[0]),
                            subtitle: Text(item[1]),
                            value: selected.contains(item[0]),
                            onChanged: (_) => toggle(item[0]),
                          );
                        }).toList(),
                      ),
                    if (_unrelatedList.isNotEmpty)
                      buildSection(
                        '⚪ بی‌ارتباط‌ها',
                        _unrelatedList.map((item) {
                          return CheckboxListTile(
                            title: Text(item),
                            value: selected.contains(item),
                            onChanged: (_) => toggle(item),
                          );
                        }).toList(),
                      ),
                  ],
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  ElevatedButton(
                    onPressed: selected.isEmpty
                        ? null
                        : () {
                            Navigator.pop(context); // بستن BottomSheet
                            // ناوبری به صفحه HarmedPeopleScreen و ارسال لیست انتخاب شده
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

  Widget buildDeficiencyList(String title, List<List<dynamic>> list) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        ...list.map((item) => Card(
              color: Colors.grey.shade100,
              margin: const EdgeInsets.symmetric(vertical: 4),
              child: ListTile(
                title: Text(item[0],
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.black)),
                subtitle: Text(item[1],
                    style: const TextStyle(color: Color(0xff363636))),
              ),
            ))
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('نمایش پیام و تحلیل')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('ماجرای :',
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
            const SizedBox(height: 24),
            const Text('نقش:',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
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
            _isLoading
                ? const Column(
                    children: [
                      Center(child: CircularProgressIndicator()),
                      SizedBox(height: 8),
                      Text('این فرایند ممکن است تا ۳۰ ثانیه طول بکشد'),
                    ],
                  )
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (_mostRelevantList.isNotEmpty)
                        buildDeficiencyList(
                            '🔴 مرتبط‌ترین نواقص:', _mostRelevantList),
                      const SizedBox(height: 16),
                      if (_somewhatRelevantList.isNotEmpty)
                        buildDeficiencyList(
                            '🟠 کم‌ارتباط‌ها:', _somewhatRelevantList),
                    ],
                  ),
            const SizedBox(height: 16),
            Row(
              children: [
                ElevatedButton(
                  onPressed: getData,
                  child: const Text('بررسی مجدد'),
                ),
                const SizedBox(width: 12),
                ElevatedButton(
                  onPressed: _mostRelevantList.isEmpty &&
                          _somewhatRelevantList.isEmpty &&
                          _unrelatedList.isEmpty
                      ? null
                      : _showDeficiencySelector,
                  child: const Text('انتخاب نقص و ادامه'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
