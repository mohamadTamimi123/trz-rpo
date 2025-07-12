import 'package:flutter/material.dart';
import '../storys_pages/details_page.dart';
import './story_input.dart';
import './history_view.dart';
import './about_view.dart';
import './stats_view.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController _controller = TextEditingController();
  int _selectedIndex = 0;

  void _handleSend() {
    String message = _controller.text.trim();
    if (message.isNotEmpty) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => DisplayPage(message: message),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('لطفاً متن را وارد کنید')),
      );
    }
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> _pages = [
      StoryInputWidget(
        controller: _controller,
        onSend: _handleSend,
      ),
      const HistoryView(),
      const StatsView(), // صفحه آمار جدید
      const AboutView(),
    ];

    return Scaffold(
      appBar: AppBar(title: const Text('برنامه من')),
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        selectedItemColor: Colors.tealAccent,
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.edit_note),
            label: 'ماجرا',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.history),
            label: 'تاریخچه',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.history),
            label: 'امار',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.info),
            label: 'درباره ما',
          ),
        ],
      ),
    );
  }
}
