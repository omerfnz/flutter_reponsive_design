// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:reponsive_design/main.dart';

void main() {
  testWidgets('Responsive template app smoke test', (
    WidgetTester tester,
  ) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const ResponsiveTemplateApp());

    // Verify that our app title is displayed (should find 2 instances - AppBar and body).
    expect(find.text('Flutter Responsive Template'), findsNWidgets(2));

    // Verify that the placeholder message is displayed.
    expect(
      find.text('Project structure and core interfaces ready!'),
      findsOneWidget,
    );

    // Verify that the next step message is displayed.
    expect(
      find.text('Next: Implement data models and services'),
      findsOneWidget,
    );
    
    // Verify that the phone icon is displayed.
    expect(find.byIcon(Icons.phone_android), findsOneWidget);
  });
}
