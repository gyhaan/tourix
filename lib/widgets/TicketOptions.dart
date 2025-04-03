import 'package:flutter/material.dart';

class TicketOptions extends StatelessWidget {
  final String trip;  
  final String agency;
  
  const TicketOptions({
    super.key,
    required this.trip, 
    required this.agency, 
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 370,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        border: Border.all(
          color: const Color(0xFF3630A1),
          width: 1,
        ),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            trip,
            style: const TextStyle(
              color: Color(0xFF3630A1),
              fontSize: 16,
            ),
          ),
          Row(
            children: [
              const Icon(Icons.car_rental, color: Color(0xFF3630A1), size: 24),
              const SizedBox(width: 8),
              Text(
                agency,
                style: const TextStyle(
                  color: Color(0xFF3630A1),
                  fontSize: 16,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}