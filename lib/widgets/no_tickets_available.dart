import 'package:flutter/material.dart';
import 'package:tourix_app/screens/Search.dart';

class NoTicketsAvailable extends StatelessWidget {
  const NoTicketsAvailable({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Online Image
          const Image(
            image: AssetImage('assets/images/no_tickets.jpg'),
            height: 100, // Optional: Adjust size as needed
          ),
          const SizedBox(height: 16),
          // Message
          const Text(
            'Oops, looks like you have no upcoming tickets',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.black,
              fontSize: 20,
              fontFamily: 'Inter',
              fontWeight: FontWeight.w400,
            ),
          ),
          const SizedBox(height: 24),
          // Book Ticket Button
          // ElevatedButton(
          //   onPressed: () {
          //     Navigator.push(
          //       context,
          //       MaterialPageRoute(builder: (context) => const Search()),
          //     );
          //   },
          //   style: ElevatedButton.styleFrom(
          //     backgroundColor: const Color(0xFF3630A1),
          //     padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
          //     shape: RoundedRectangleBorder(
          //       borderRadius: BorderRadius.circular(8),
          //     ),
          //   ),
          //   child: const Text(
          //     'Book Ticket',
          //     style: TextStyle(
          //       color: Colors.white,
          //       fontSize: 16,
          //       fontWeight: FontWeight.w400,
          //     ),
          //   ),
          // ),
        ],
      ),
    );
  }
}
