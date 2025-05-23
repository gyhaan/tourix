import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tourix_app/screens/ticket_seat.dart';
import '../helpers/firebase_mock_helper.dart';
import '../helpers/firestore_mocks.dart';

void main() {
  group('Ticket Seat Selection Screen Widget Tests', () {
    setUpAll(() {
      setupFirebaseMocks();
      FirestoreMocks.setupMocks();
    });

    tearDownAll(() async {
      // Clean up any resources if needed
    });

    testWidgets('displays all elements correctly', (WidgetTester tester) async {
      // Build our app and trigger a frame.
      await tester.pumpWidget(
        MaterialApp(
          scaffoldMessengerKey: GlobalKey<ScaffoldMessengerState>(),
          home: Scaffold(
            body: SeatSelectionPage(
              bookingDocID: 'test-booking-id',
              travellerData: [
                {'name': 'Test User', 'age': '25'},
              ],
              firestore: FirestoreMocks.mockFirestore,
            ),
          ),
        ),
      );

      // Wait for the loading indicator to disappear
      await tester.pump();
      await tester.pump(const Duration(seconds: 1));

      // Verify that the title is displayed
      expect(find.text('Select Bus Seats'), findsOneWidget);

      // Verify that the seat selection dropdown is displayed
      expect(find.byType(DropdownButtonFormField<String>), findsOneWidget);

      // Verify that the add button is displayed
      expect(find.text('+'), findsOneWidget);

      // Verify that the confirm seats button is displayed
      expect(find.text('Confirm Seats'), findsOneWidget);
    });

    testWidgets('shows error when adding seat without selection',
        (WidgetTester tester) async {
      // Build our app and trigger a frame.
      await tester.pumpWidget(
        MaterialApp(
          scaffoldMessengerKey: GlobalKey<ScaffoldMessengerState>(),
          home: Scaffold(
            body: SeatSelectionPage(
              bookingDocID: 'test-booking-id',
              travellerData: [
                {'name': 'Test User', 'age': '25'},
              ],
              firestore: FirestoreMocks.mockFirestore,
            ),
          ),
        ),
      );

      // Wait for the loading indicator to disappear
      await tester.pump();
      await tester.pump(const Duration(seconds: 1));

      // Tap the add button without selecting a seat
      await tester.tap(find.text('+'));
      await tester.pump();

      // Verify that the error message is shown
      expect(find.text('Please select a valid seat number'), findsOneWidget);
    });

    testWidgets('can select and add a seat', (WidgetTester tester) async {
      // Build our app and trigger a frame.
      await tester.pumpWidget(
        MaterialApp(
          scaffoldMessengerKey: GlobalKey<ScaffoldMessengerState>(),
          home: Scaffold(
            body: SeatSelectionPage(
              bookingDocID: 'test-booking-id',
              travellerData: [
                {'name': 'Test User', 'age': '25'},
              ],
              firestore: FirestoreMocks.mockFirestore,
            ),
          ),
        ),
      );

      // Wait for the loading indicator to disappear
      await tester.pump();
      await tester.pump(const Duration(seconds: 1));

      // Find and tap the dropdown
      final dropdown = find.byType(DropdownButtonFormField<String>);
      await tester.tap(dropdown);
      await tester.pump();

      // Select the first available seat
      await tester.tap(find.text('A1').last);
      await tester.pump();

      // Tap the add button
      await tester.tap(find.text('+'));
      await tester.pump();

      // Verify that the seat was added
      expect(find.text('A1'), findsOneWidget);
    });
  });
}
