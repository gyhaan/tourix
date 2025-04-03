import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:tourix_app/main.dart' as app;

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('Ticket Booking Flow Integration Test', () {
    testWidgets('should complete ticket booking flow',
        (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle();

      // Login first
      await tester.enterText(
          find.widgetWithText(TextField, 'Email'), 'test@example.com');
      await tester.pumpAndSettle();
      await tester.enterText(
          find.widgetWithText(TextField, 'Password'), 'password123');
      await tester.pumpAndSettle();
      await tester.tap(find.text('Login'));
      await tester.pumpAndSettle();

      // Wait for ticket screen to load
      await tester.pumpAndSettle();

      // Tap book ticket button
      await tester.tap(find.text('Book Ticket'));
      await tester.pumpAndSettle();
    });

    testWidgets('should cancel ticket flow', (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle();

      // Login first
      await tester.enterText(
          find.widgetWithText(TextField, 'Email'), 'test@example.com');
      await tester.pumpAndSettle();
      await tester.enterText(
          find.widgetWithText(TextField, 'Password'), 'password123');
      await tester.pumpAndSettle();
      await tester.tap(find.text('Login'));
      await tester.pumpAndSettle();

      // Wait for ticket screen to load
      await tester.pumpAndSettle();

    });
  });
}
