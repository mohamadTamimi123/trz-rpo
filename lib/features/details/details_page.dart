import 'dart:convert';
import 'package:flutter/material.dart';
import '../../services/api_service.dart';
import 'display_role.dart';

class DisplayPage extends StatefulWidget {
  final String message;
  const DisplayPage({super.key, required this.message});

  @override
  State<DisplayPage> createState() => _DisplayPageState();
}

class _DisplayPageState extends State<DisplayPage> {
  String _apiResult = '';
  String? _selectedEmotion;
  bool _isLoading = true;
  bool _manualSelectionEnabled = false;

  final List<String> emotions = [
    'رنجش و دلچرکین شدن',
    'ترس',
    'احساس گناه، شرم و خجالت',
    'غم و اندوه',
    'افسردگی و ناامیدی',
  ];

  @override
  void initState() {
    super.initState();
    getData();
  }

  Future<void> getData() async {
    setState(() {
      _isLoading = true;
      _manualSelectionEnabled = false;
    });

    try {
      final result = await ApiService.getRole(widget.message);
      final data = jsonDecode(result); // دیکود رشته JSON
      final emotion = data['emotion']; // استخراج مقدار

      setState(() {
        _apiResult = emotion ?? 'پاسخ نامعتبر است';
        _selectedEmotion = emotions.contains(emotion) ? emotion : null;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        print(e);
        _apiResult = '';
        _isLoading = false;
      });
      _showErrorDialog();
    }
  }

  void _showErrorDialog() {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('خطا در دریافت پاسخ'),
        content: const Text('در دریافت پاسخ از سرور مشکلی پیش آمده است.'),
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
              setState(() {
                _manualSelectionEnabled = true;
              });
            },
            child: const Text('انتخاب دستی'),
          ),
        ],
      ),
    );
  }

  Widget _buildChoiceChips() {
    if (_isLoading || (!_manualSelectionEnabled && _apiResult.isEmpty)) {
      return const SizedBox.shrink();
    }

    return Column(
      children: [
        const Text(
          'نقش و احساس قالب:',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 8.0,
          children: emotions.map((emotion) {
            return ChoiceChip(
              label: Text(emotion),
              selected: _selectedEmotion == emotion,
              onSelected: (selected) {
                setState(() {
                  _selectedEmotion = selected ? emotion : null;
                });
              },
              selectedColor: Colors.blue.shade200,
              backgroundColor: Colors.grey.shade200,
              labelStyle: TextStyle(
                color: _selectedEmotion == emotion
                    ? Colors.black
                    : Colors.grey.shade800,
              ),
            );
          }).toList(),
        )
      ],
    );
  }

  void _handleSend() {
    if (_selectedEmotion != null && _selectedEmotion!.isNotEmpty) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => DisplayRole(
            message: widget.message,
            emotion: _selectedEmotion!,
          ),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('لطفاً یک احساس را انتخاب کنید')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('نمایش پیام و API')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'ماجرای شما:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Container(
              width: double.infinity, // عرض کامل
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.grey.shade900,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                widget.message,
                style: const TextStyle(fontSize: 16, color: Colors.white),
              ),
            ),
            const SizedBox(height: 24),
            _isLoading
                ? Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Center(child: CircularProgressIndicator()),
                      SizedBox(height: 8),
                      Center(
                          child:
                              Text('این فرایند ممکن است تا ۳۰ ثانیه طول بکشد')),
                    ],
                  )
                : _buildChoiceChips(),
            const SizedBox(height: 16),
            Row(
              children: [
                ElevatedButton(
                  onPressed: getData,
                  child: const Text('بررسی مجدد'),
                ),
                const SizedBox(width: 12),
                ElevatedButton(
                  onPressed: _handleSend,
                  child: const Text('مرحله بعد و تحلیل نقص'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
