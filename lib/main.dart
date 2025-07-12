import 'features/home/home_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:hive_flutter/hive_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // مرحله 1: مقداردهی اولیه Hive
  await Hive.initFlutter();

  // مرحله 2: باز کردن باکس مورد نیاز
  await Hive.openBox('appBox');

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData.dark(),
      locale: const Locale('fa'), // برای فارسی
      supportedLocales: const [
        Locale('fa'),
      ],
      localizationsDelegates: GlobalMaterialLocalizations.delegates,
      builder: (context, child) {
        return Directionality(
          textDirection: TextDirection.rtl, // 🌟 راست‌چین کردن کل اپ
          child: child!,
        );
      },

      home: const HomePage(),
    );
  }
}
