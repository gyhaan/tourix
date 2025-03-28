class BookingInfo {
  final String userName;
  final String departureTime;
  final String fromLocation;
  final String toLocation;
  final String agencyName;
  final int seatsBooked;
  final String price;
  final String? phoneNumber;

  const BookingInfo({
    required this.userName,
    required this.departureTime,
    required this.fromLocation,
    required this.toLocation,
    required this.agencyName,
    required this.seatsBooked,
    required this.price,
    this.phoneNumber,
  });
}
