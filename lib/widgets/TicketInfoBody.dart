import 'package:flutter/material.dart';

class TicketInfobody extends StatelessWidget {
  final String name;
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
    super.key,
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
  });

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 140, // Fixed width for labels
            child: Text(
              label,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: Color(0xFF3630A1),
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                fontSize: 16,
                height: 1.5,
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildInfoRow("Passenger:", name),
          _buildInfoRow("Departure Date:", departureDate),
          _buildInfoRow("Departure Time:", departureTime),
          _buildInfoRow("From:", from),
          _buildInfoRow("To:", to),
          _buildInfoRow("Agency:", agency),
          _buildInfoRow("Seats Booked:", seatsBooked.toString()),
          _buildInfoRow("Seat Name:", seatName),
          _buildInfoRow("Price:", price),
          _buildInfoRow("Payment Method:", paymentMethod),
        ],
      ),
    );
  }
}