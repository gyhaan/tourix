class TicketInfo {
  final String id;
  final String date;
  final String time;
  final String ticketCode;
  final String origin;
  final String destination;
  final int passengers;
  final String busType;

  TicketInfo({
    required this.id,
    required this.date,
    required this.time,
    required this.ticketCode,
    required this.origin,
    required this.destination,
    required this.passengers,
    required this.busType,
  });

  factory TicketInfo.fromJson(Map<String, dynamic> json) {
    return TicketInfo(
      id: json['id'] as String,
      date: json['date'] as String,
      time: json['time'] as String,
      ticketCode: json['ticketCode'] as String,
      origin: json['origin'] as String,
      destination: json['destination'] as String,
      passengers: json['passengers'] as int,
      busType: json['busType'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'date': date,
      'time': time,
      'ticketCode': ticketCode,
      'origin': origin,
      'destination': destination,
      'passengers': passengers,
      'busType': busType,
    };
  }
}
