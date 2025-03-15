import 'package:flutter/material.dart';
import 'package:tourix_app/components/TopBar.dart';
import '../components/BottomBar.dart';
import '../components/TicketInput.dart';

class Booking extends StatefulWidget {
  const Booking({super.key});

  @override
  State<Booking> createState() => _BookingState();
}

class _BookingState extends State<Booking> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(kToolbarHeight),
        child: TopBar(),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Trip Details',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF3630A1),
                ),
              ),
              const SizedBox(height: 20),

              // Each field is now stacked vertically
              const TicketInput(fieldTitle: 'Departure City'),
              const SizedBox(height: 16),
              const TicketInput(fieldTitle: 'Destination City'),
              const SizedBox(height: 16),
              const TicketInput(fieldTitle: 'Total Seats'),
              const SizedBox(height: 16),
              const TicketInput(fieldTitle: 'Price'),
              const SizedBox(height: 16),
              const TicketInput(fieldTitle: 'Total Time'),
              const SizedBox(height: 24), // Added spacing before button

              Center( // Center the button
                child: ElevatedButton(
                  onPressed: () {
                    // Add your button logic here
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF3630A1),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 32,
                      vertical: 16,
                    ),
                  ),
                  child: const Text(
                    'Create Trip',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: const BottomBar(),
    );
  }
}
