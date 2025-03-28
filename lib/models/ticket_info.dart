class TicketInfo {
  final String date;
  final String time;
  final String ticketCode;
  final String origin;
  final String destination;
  final int passengers;
  final String busType;

  TicketInfo({
    required this.date,
    required this.time,
    required this.ticketCode,
    required this.origin,
    required this.destination,
    required this.passengers,
    required this.busType,
  });
}
