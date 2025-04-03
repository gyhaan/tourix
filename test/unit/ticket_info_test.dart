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

    
  });
}
