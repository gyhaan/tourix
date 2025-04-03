import 'package:flutter_test/flutter_test.dart';
import 'package:tourix_app/models/bookInfo.dart';

void main() {
  group('BookingInfo Model Tests', () {
    test('should create BookingInfo instance with all required values', () {
      final bookingInfo = BookingInfo(
        userName: 'John Doe',
        departureTime: '10:00',
        fromLocation: 'London',
        toLocation: 'Paris',
        agencyName: 'Luxury Bus',
        seatsBooked: 2,
        price: '100',
      );

      expect(bookingInfo.userName, 'John Doe');
      expect(bookingInfo.departureTime, '10:00');
      expect(bookingInfo.fromLocation, 'London');
      expect(bookingInfo.toLocation, 'Paris');
      expect(bookingInfo.agencyName, 'Luxury Bus');
      expect(bookingInfo.seatsBooked, 2);
      expect(bookingInfo.price, '100');
      expect(bookingInfo.phoneNumber, null);
    });

    
  });
}
