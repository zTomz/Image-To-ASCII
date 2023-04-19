import 'package:flutter/material.dart';
import 'package:imgtoascii/colors.dart';
import 'package:imgtoascii/pages/home_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Image To ASCII',
      theme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        scaffoldBackgroundColor: kBackground,
        colorScheme: const ColorScheme.dark(
          brightness: Brightness.dark,
        ),
      ),
      home: const HomePage(),
    );
  }
}
