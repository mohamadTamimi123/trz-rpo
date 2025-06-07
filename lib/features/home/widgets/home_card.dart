import 'package:flutter/material.dart';

class HomeCard extends StatelessWidget {
  const HomeCard({super.key});

  @override
  Widget build(BuildContext context) {
    return const Card(
      margin: EdgeInsets.symmetric(horizontal: 20),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Center(
          // ← این خط رو اضافه کن
          child: Text(
            'خوش اومدی!',
            style: TextStyle(fontSize: 18),
          ),
        ),
      ),
    );
  }
}
