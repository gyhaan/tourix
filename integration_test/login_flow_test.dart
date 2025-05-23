import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:tourix_app/main.dart' as app;

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('Login Flow Integration Test', () {
    testWidgets('should login with valid credentials',
        (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle();

      // Verify we're on the login screen
      expect(find.text('Welcome Back'), findsOneWidget);

      // Enter email
      await tester.enterText(
          find.widgetWithText(TextField, 'Email'), 'test@example.com');
      await tester.pumpAndSettle();

      // Enter password
      await tester.enterText(
          find.widgetWithText(TextField, 'Password'), 'password123');
      await tester.pumpAndSettle();

      // Tap login button
      await tester.tap(find.text('Login'));
      await tester.pumpAndSettle();

      // Note: In a real test, we would:
      // 1. Mock Firebase Auth
      // 2. Mock Firestore
      // 3. Verify navigation to the appropriate screen based on user role
      // 4. Verify user data is properly loaded
    });

    testWidgets('should show error with invalid credentials',
        (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle();

      // Enter invalid email
      await tester.enterText(
          find.widgetWithText(TextField, 'Email'), 'invalid@example.com');
      await tester.pumpAndSettle();

      // Enter invalid password
      await tester.enterText(
          find.widgetWithText(TextField, 'Password'), 'wrongpassword');
      await tester.pumpAndSettle();

      // Tap login button
      await tester.tap(find.text('Login'));
      await tester.pumpAndSettle();

      // Note: In a real test, we would:
      // 1. Mock Firebase Auth to throw an error
      // 2. Verify the error message is displayed
      // 3. Verify we stay on the login screen
    });
  });
}
