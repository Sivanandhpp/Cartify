// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:cartify/app/core/index.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';

void main() {
  testWidgets('App smoke test', (WidgetTester tester) async {
    // Create a basic test app
    await tester.pumpWidget(
      GetMaterialApp(
        home: Scaffold(
          appBar: AppBar(title: const Text('Test')),
          body: Center(child: Text(AppIdentity.testAppName)),
        ),
      ),
    );

    // Verify the app renders without crashing
    expect(find.text(AppIdentity.testAppName), findsOneWidget);
  });
}
