import 'package:flutter_test/flutter_test.dart';
import 'package:tourix_app/models/ticket_info.dart';

void main() {
  group('TicketInfo Model Tests', () {
    test('should create TicketInfo instance with correct values', () {
      final ticketInfo = TicketInfo(
        id: 'TIX123',
        date: '2024-04-01',
        time: '10:00',
        ticketCode: 'TIX123',
        origin: 'London',
        destination: 'Paris',
        passengers: 2,
        busType: 'Luxury',
      );

      expect(ticketInfo.id, 'TIX123');
      expect(ticketInfo.date, '2024-04-01');
      expect(ticketInfo.time, '10:00');
      expect(ticketInfo.ticketCode, 'TIX123');
      expect(ticketInfo.origin, 'London');
      expect(ticketInfo.destination, 'Paris');
      expect(ticketInfo.passengers, 2);
      expect(ticketInfo.busType, 'Luxury');
    });

    test('should convert TicketInfo to and from JSON', () {
      final ticketInfo = TicketInfo(
        id: 'TIX123',
        date: '2024-04-01',
        time: '10:00',
        ticketCode: 'TIX123',
        origin: 'London',
        destination: 'Paris',
        passengers: 2,
        busType: 'Luxury',
      );

      final json = ticketInfo.toJson();
      final fromJson = TicketInfo.fromJson(json);

      expect(fromJson.id, ticketInfo.id);
      expect(fromJson.date, ticketInfo.date);
      expect(fromJson.time, ticketInfo.time);
      expect(fromJson.ticketCode, ticketInfo.ticketCode);
      expect(fromJson.origin, ticketInfo.origin);
      expect(fromJson.destination, ticketInfo.destination);
      expect(fromJson.passengers, ticketInfo.passengers);
      expect(fromJson.busType, ticketInfo.busType);
    });
  });
}
