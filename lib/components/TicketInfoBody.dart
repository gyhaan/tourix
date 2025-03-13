import 'package:flutter/material.dart';
//import 'package:intl/intl.dart';

class TicketInfobody extends StatelessWidget {
  final String name;
  // Strings since they are being tested
  final String departureDate;
  final String departureTime;
  final String from;
  final String to;
  final String agency;
  final int seatsBooked;
  final String seatName;
  final String price;
  final String paymentMethod;

  const TicketInfobody({
    Key? key,
    required this.name,
    required this.departureDate,
    required this.departureTime,
    required this.from,
    required this.to,
    required this.agency,
    required this.seatsBooked,
    required this.seatName,
    required this.price,
    required this.paymentMethod,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.only(left: 10, top: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start, 
          children: [
            Text("Passenger: $name"),
            Text("Departure Date: $departureDate"),
            Text("Departure Time: $departureTime"),
            Text("From: $from"), 
            Text("To: $to"),
            Text("Agency: $agency"),
            Text("Seats Booked: $seatsBooked"),
            Text("Seat Name: $seatName"), 
            Text("Price: $price"),
            Text("Payment Method: $paymentMethod"),
          ],
        ),
      ),
    );
  }
}
