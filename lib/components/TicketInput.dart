import 'package:flutter/material.dart';

class TicketInput extends StatelessWidget {
  final String fieldTitle;  
  
  const TicketInput({
    super.key, 
    required this.fieldTitle
  });

  @override
  Widget build(BuildContext context) {
    return Row(  
      children: [
        Text(
          '$fieldTitle:  ',
          style: const TextStyle(  
            fontSize: 16,
            color: Color(0xFF3630A1),
          ),
        ),
        Expanded(
          child: TextField(
            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderSide: const BorderSide(
                  color: Colors.black,
                  width: 1,
                ),
                borderRadius: BorderRadius.circular(4),
              ),
              enabledBorder: OutlineInputBorder(
                borderSide: const BorderSide(
                  color: Colors.black,
                  width: 1,
                ),
                borderRadius: BorderRadius.circular(4),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: const BorderSide(
                  color: Colors.black,
                  width: 2,
                ),
                borderRadius: BorderRadius.circular(4),
              ),
              contentPadding: const EdgeInsets.symmetric(
                vertical: 12,
                horizontal: 16,
              ),
            ),
            cursorColor: const Color(0xFF3630A1),
            style: const TextStyle(
              color: Color(0xFF3630A1),
            ),
          ),
        ),
      ],
    );
  }
}