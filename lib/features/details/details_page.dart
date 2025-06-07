// display_page.dart

import 'package:flutter/material.dart';
import '../../services/api_service.dart';

class DisplayPage extends StatefulWidget {
  final String message;
  const DisplayPage({super.key, required this.message});

  @override
  State<DisplayPage> createState() => _DisplayPageState();
}

class _DisplayPageState extends State<DisplayPage> {
  String _apiResult = 'در حال بارگذاری...';
  String? _selectedEmotion;

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
    final result = await ApiService.getRole(widget.message);
    setState(() {
      _apiResult = result;
    });
  }

  Widget _buildChoiceChips() {
    return Wrap(
      spacing: 8.0,
      children: emotions.map((emotion) {
        return ChoiceChip(
          label: Text(emotion),
          selected: _selectedEmotion == emotion,
          onSelected: (selected) {
            setState(() {
              _selectedEmotion = selected ? emotion : null;
              print("احساس انتخاب‌شده: $_selectedEmotion");
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
    );
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
            Text(
              'پیام شما: ${widget.message}',
              style: const TextStyle(fontSize: 20),
            ),
            const SizedBox(height: 24),
            const Text(
              'نتیجه API:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            Text(
              _apiResult,
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 24),
            const Text(
              'انتخاب احساس:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            _buildChoiceChips(),
          ],
        ),
      ),
    );
  }
}

// تعریف ویجت سفارشی Dropdown همین‌جا
class CustomDropdown extends StatefulWidget {
  final List<String> options;
  final String? initialValue;
  final void Function(String?)? onChanged;

  const CustomDropdown({
    super.key,
    required this.options,
    this.initialValue,
    this.onChanged,
  });

  @override
  State<CustomDropdown> createState() => _CustomDropdownState();
}

class _CustomDropdownState extends State<CustomDropdown> {
  String? selectedOption;

  @override
  void initState() {
    super.initState();
    selectedOption = widget.initialValue;
  }

  @override
  Widget build(BuildContext context) {
    return DropdownButton<String>(
      hint: const Text('یک گزینه انتخاب کن'),
      value: selectedOption,
      items: widget.options.map((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
      onChanged: (newValue) {
        setState(() {
          selectedOption = newValue;
        });
        if (widget.onChanged != null) {
          widget.onChanged!(newValue);
        }
      },
    );
  }
}
