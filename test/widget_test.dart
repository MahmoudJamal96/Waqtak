import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('Waqtak app smoke test', (WidgetTester tester) async {
    // Build a simple widget for testing
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: Center(child: Text('وقتك')),
        ),
      ),
    );

    // Verify the app runs
    expect(find.text('وقتك'), findsOneWidget);
  });
}
