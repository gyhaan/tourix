import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:tourix_app/screens/planned_trips.dart';
import '../widgets/TopBar.dart';
import '../widgets/BottomBar.dart';
import '../widgets/TicketInput.dart';

class Booking extends StatefulWidget {
  const Booking({super.key});

  @override
  State<Booking> createState() => _BookingState();
}

class _BookingState extends State<Booking> {
  final TextEditingController _departureController = TextEditingController();
  final TextEditingController _destinationController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _totalSeatsController = TextEditingController();

  bool _isLoading = false; // Added state for loading indicator

  Future<void> _createTrip() async {
    if (_isLoading) return; // Prevent multiple clicks

    setState(() {
      _isLoading = true; // Show loading indicator
    });

    try {
      User? user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("You need to be logged in")),
        );
        setState(() {
          _isLoading = false;
        });
        return;
      }

      String agencyID = user.uid;
      String departure = _departureController.text.trim();
      String destination = _destinationController.text.trim();
      int price = int.tryParse(_priceController.text.trim()) ?? 0;
      int totalSeats = int.tryParse(_totalSeatsController.text.trim()) ?? 0;

      if (departure.isEmpty ||
          destination.isEmpty ||
          price <= 0 ||
          totalSeats <= 0) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Please fill all fields correctly")),
        );
        setState(() {
          _isLoading = false;
        });
        return;
      }

      // Generate seat numbers (A1, A2, ..., A30)
      List<String> seats =
          List.generate(totalSeats, (index) => 'A${index + 1}');

      // Convert agencyID to a Firestore DocumentReference
      DocumentReference agencyRef =
          FirebaseFirestore.instance.collection('users').doc(agencyID);

      // Firestore document structure
      Map<String, dynamic> tripData = {
        'agencyID': agencyRef, // Store as a reference, not a string
        'departureCity': departure,
        'destinationCity': destination,
        'price': price,
        'totalSeats': totalSeats,
        'availableSeats': seats, // Store array of seats
        'createdAt': FieldValue.serverTimestamp(),
      };

      // Add to Firestore
      await FirebaseFirestore.instance.collection('trips').add(tripData);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Trip created successfully!")),
      );

      // Clear input fields
      _departureController.clear();
      _destinationController.clear();
      _priceController.clear();
      _totalSeatsController.clear();

      // Navigate to PlannedTrips
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => PlannedTrips(userId: agencyID),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: ${e.toString()}")),
      );
    } finally {
      setState(() {
        _isLoading = false; // Hide loading indicator after process
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const PreferredSize(
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
              TicketInput(
                  controller: _departureController,
                  fieldTitle: 'Departure City'),
              const SizedBox(height: 16),
              TicketInput(
                  controller: _destinationController,
                  fieldTitle: 'Destination City'),
              const SizedBox(height: 16),
              TicketInput(
                  controller: _totalSeatsController,
                  fieldTitle: 'Total Seats',
                  keyboardType: TextInputType.number),
              const SizedBox(height: 16),
              TicketInput(
                  controller: _priceController,
                  fieldTitle: 'Price',
                  keyboardType: TextInputType.number),
              const SizedBox(height: 24),
              Center(
                child: ElevatedButton(
                  onPressed:
                      _isLoading ? null : _createTrip, // Disable when loading
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF3630A1),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 32, vertical: 16),
                  ),
                  child: _isLoading
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2,
                          ),
                        )
                      : const Text(
                          'Create Trip',
                          style: TextStyle(color: Colors.white, fontSize: 16),
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
