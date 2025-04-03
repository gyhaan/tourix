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

      
    });

    
  });
}
