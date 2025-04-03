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

    
  });
}
