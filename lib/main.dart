import 'package:currency_converter/app/main_navigation_page.dart';
import 'package:flutter/material.dart';
// import 'package:device_preview/devic1e_preview.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: MainNavigationPage(),
      debugShowCheckedModeBanner: false,
    );
  }
}
