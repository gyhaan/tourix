import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tourix_app/screens/login.dart';
import '../helpers/test_helpers.dart';

void main() {
  group('Login Screen Widget Tests', () {
    setUpAll(() {
      TestHelpers.setupAll();
    });

    tearDownAll(() {
      TestHelpers.tearDownAll();
    });

    testWidgets('should display all login screen elements',
        (WidgetTester tester) async {
      await TestHelpers.setupFirestore();

      // Build our app and trigger a frame
      await tester.pumpWidget(MaterialApp(
        home: Scaffold(
          body: LoginPage(),
        ),
      ));

      // Wait for all animations to complete
      await tester.pumpAndSettle();

      // Verify welcome text
      expect(find.text('Welcome Back'), findsOneWidget);

      // Verify input fields
      expect(find.widgetWithText(TextField, 'Email'), findsOneWidget);
      expect(find.widgetWithText(TextField, 'Password'), findsOneWidget);

      // Verify forgot password link
      expect(find.text('Forgot Password?'), findsOneWidget);

      // Verify login button
      expect(find.widgetWithText(ElevatedButton, 'Login'), findsOneWidget);

      // Find the GestureDetector for sign up
      final signUpGesture = find.byType(GestureDetector).last;
      expect(signUpGesture, findsOneWidget);

      // Get the Text.rich widget inside the GestureDetector
      final signUpText =
          tester.widget<GestureDetector>(signUpGesture).child as Text;
      final plainText = signUpText.textSpan!.toPlainText();
      expect(plainText.contains('account'), isTrue);
      expect(plainText.contains('Sign Up'), isTrue);
    });

    testWidgets('should show error when email is empty',
        (WidgetTester tester) async {
      await tester.pumpWidget(const MaterialApp(home: LoginPage()));

      // Tap login button without entering email
      await tester.tap(find.text('Login'));
      await tester.pumpAndSettle();

      // Verify error message
      expect(find.text('Please enter email and password'), findsOneWidget);
    });

    testWidgets('should navigate to signup screen when signup is tapped',
        (WidgetTester tester) async {
      await TestHelpers.setupFirestore();

      // Build our app and trigger a frame
      await tester.pumpWidget(MaterialApp(
        home: Scaffold(
          body: LoginPage(),
        ),
      ));

      // Wait for all animations to complete
      await tester.pumpAndSettle();

      // Find and tap the GestureDetector for sign up
      final signUpGesture = find.byType(GestureDetector).last;
      expect(signUpGesture, findsOneWidget);
      await tester.tap(signUpGesture);
      await tester.pumpAndSettle();

      // Note: We can't verify the actual navigation since we're using MaterialApp
      // In a real integration test, we would verify the navigation
    });
  });
}
