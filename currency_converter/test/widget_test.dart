import 'package:currency_converter/currency_converter_material_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:currency_converter/main.dart'; // Replace `your_project` with your actual project name.

void main() {
  testWidgets('Score increments when box is tapped',
      (WidgetTester tester) async {
    // Build the game app
    await tester.pumpWidget(CurrencyConverterMaterialPage());

    // Initial score should be 0
    expect(find.text('Score: 0'), findsOneWidget);

    // Tap the blue box and verify the score increments
    await tester.tap(find.byType(Container).first); // Taps the blue box
    await tester.pump();

    expect(find.text('Score: 1'), findsOneWidget);
  });
}
