import 'package:flutter/material.dart';
import 'package:currency_converter/features/currency_converter/presentation/pages/currency_converter_page.dart';
// import 'package:device_preview/device_preview.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: CurrencyConverterMaterialPage(),
      debugShowCheckedModeBanner: false,
    );
  }
}
