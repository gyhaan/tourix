import 'package:flutter_test/flutter_test.dart';
import 'package:tourix_app/models/planned_trips_info.dart';

void main() {
  group('PlannedTripsInfo Model Tests', () {
    test('should create PlannedTripsInfo instance with correct values', () {
      final plannedTrip = PlannedTripsInfo(
        seats: 2,
        price: 100,
        origin: 'London',
        destination: 'Paris',
        busType: 'Luxury',
      );

      expect(plannedTrip.seats, 2);
      expect(plannedTrip.price, 100);
      expect(plannedTrip.origin, 'London');
      expect(plannedTrip.destination, 'Paris');
      expect(plannedTrip.busType, 'Luxury');
    });
  });
}
