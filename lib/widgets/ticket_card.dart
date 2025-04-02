import 'package:flutter/material.dart';
import '../models/ticket_info.dart';

class TicketCard extends StatelessWidget {
  final TicketInfo ticket;

  const TicketCard({
    Key? key,
    required this.ticket,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    const Color primaryColor = Color(0xFF3630A1);

    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '${ticket.date}, ${ticket.time.substring(0, 5)}',
                  style: const TextStyle(
                    color: primaryColor,
                    fontSize: 14,
                  ),
                ),
                Text(
                  ticket.ticketCode,
                  style: const TextStyle(
                    color: primaryColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              '${ticket.origin} - ${ticket.destination}',
              style: const TextStyle(
                color: primaryColor,
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '${ticket.passengers} Passengers',
                  style: const TextStyle(
                    fontSize: 14,
                    color: primaryColor,
                  ),
                ),
                Row(
                  children: [
                    Container(
                      width: 20,
                      height: 20,
                      decoration: const BoxDecoration(
                        color: Colors.orange,
                        shape: BoxShape.circle,
                      ),
                      // This is where you'd put your own image
                    ),
                    const SizedBox(width: 5),
                    Text(
                      ticket.busType,
                      style: const TextStyle(
                        color: primaryColor,
                        fontWeight: FontWeight.w500,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
