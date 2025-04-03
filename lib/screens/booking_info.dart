import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tourix_app/screens/ticket_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';

class BookingInfoScreen extends StatefulWidget {
  final String bookingId;

  const BookingInfoScreen({super.key, required this.bookingId});

  @override
  _BookingInfoScreenState createState() => _BookingInfoScreenState();
}

class _BookingInfoScreenState extends State<BookingInfoScreen> {
  bool _isLoading = true;
  Map<String, dynamic>? bookingData;
  Map<String, dynamic>? tripData;
  Map<String, dynamic>? agencyData;
  String? travellerName;
  final TextEditingController _phoneController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _fetchBookingInfo();
  }

  Future<void> _fetchBookingInfo() async {
    try {
      // Fetch booking document
      DocumentSnapshot bookingSnapshot = await FirebaseFirestore.instance
          .collection('bookings')
          .doc(widget.bookingId)
          .get();
      if (!bookingSnapshot.exists) {
        setState(() => _isLoading = false);
        return;
      }
      bookingData = bookingSnapshot.data() as Map<String, dynamic>;

      // Fetch trip document using tripID reference
      DocumentSnapshot tripSnapshot = await bookingData?['tripID'].get();
      if (tripSnapshot.exists) {
        tripData = tripSnapshot.data() as Map<String, dynamic>;

        // Fetch agency document using agencyID reference from trip
        DocumentSnapshot agencySnapshot = await tripData?['agencyID'].get();
        if (agencySnapshot.exists) {
          agencyData = agencySnapshot.data() as Map<String, dynamic>;
        }
      }

      // Fetch traveller's full name using travellerID reference
      DocumentSnapshot travellerSnapshot =
          await bookingData?['travellerID'].get();
      if (travellerSnapshot.exists) {
        travellerName = travellerSnapshot['name'];
      }

      setState(() => _isLoading = false);
    } catch (error) {
      setState(() => _isLoading = false);
      print("Error fetching data: $error");
    }
  }

  // Function to validate phone number
  bool _isValidPhoneNumber(String phoneNumber) {
    final RegExp regex = RegExp(r'^(078|072|073)\d{7}$');
    return regex.hasMatch(phoneNumber);
  }

  // Function to update the booking
  Future<void> _updateBooking(String phoneNumber) async {
    if (!_isValidPhoneNumber(phoneNumber)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please enter a valid phone number")),
      );
      return;
    }

    try {
      // Update paymentMethod and active status in the booking
      await FirebaseFirestore.instance
          .collection('bookings')
          .doc(widget.bookingId)
          .update({
        'paymentMethod': phoneNumber, // Store the phone number in paymentMethod
        'active': true, // Set the active field to true
      });

      // Optionally, display a confirmation message
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Booking updated successfully")),
      );

      // Get the current user's ID
      final userId = FirebaseAuth.instance.currentUser?.uid;

      // If user is logged in, pass the user ID to TicketScreen
      if (userId != null) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => const TicketScreen(),
          ),
        );
      } else {
        // Handle case when there is no logged-in user
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("No user is logged in")),
        );
      }
    } catch (e) {
      print("Error updating booking: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Failed to update booking")),
      );
    }
  }

  Widget _buildInfoRow(String label, String value) {
    return Row(
      children: [
        Text(
          label,
          style: const TextStyle(
            fontWeight: FontWeight.w500,
            fontSize: 18,
          ),
        ),
        const SizedBox(width: 8),
        Text(
          value,
          style: const TextStyle(
            fontWeight: FontWeight.w400,
            fontSize: 18,
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF3630A1),
        iconTheme: const IconThemeData(color: Colors.white),
        title:
            const Text('Booking Info', style: TextStyle(color: Colors.white)),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SafeArea(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    const Text('Booking Details',
                        style: TextStyle(
                            fontSize: 24, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 24),

                    // Booking Info Card
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Column(
                        children: [
                          _buildInfoRow('Name:', travellerName ?? 'N/A'),
                          _buildInfoRow(
                            'Departure Time:',
                            bookingData?['departureTime'] is Timestamp
                                ? (bookingData?['departureTime'] as Timestamp)
                                    .toDate()
                                    .toString().substring(0, 16)
                                : 'N/A',
                          ),
                          _buildInfoRow(
                              'From:', tripData?['departureCity'] ?? 'N/A'),
                          _buildInfoRow(
                              'To:', tripData?['destinationCity'] ?? 'N/A'),
                          _buildInfoRow(
                              'Agency:', agencyData?['name'] ?? 'N/A'),
                          _buildInfoRow(
                              'Seats Booked:',
                              bookingData?['seatsBooked']?.length.toString() ??
                                  '0'),
                          _buildInfoRow('Price:',
                              tripData?['price']?.toString() ?? 'N/A'),
                        ],
                      ),
                    ),
                    const SizedBox(height: 32),

                    // Phone Number Input Field
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      child: Row(
                        children: [
                          const Text(
                            'Phone Nbr:',
                            style: TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: 18,
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: TextField(
                              controller: _phoneController,
                              decoration: InputDecoration(
                                contentPadding: const EdgeInsets.symmetric(
                                    horizontal: 12, vertical: 14),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                  borderSide: const BorderSide(
                                      color: Colors.grey, width: 1),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                  borderSide: const BorderSide(
                                      color: Colors.grey, width: 1),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                  borderSide: const BorderSide(
                                      color: Color(0xFF3630A1), width: 1.5),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 32),

                    // Proceed to Checkout Button
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      child: ElevatedButton(
                        onPressed: () {
                          _updateBooking(_phoneController.text);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF3630A1),
                          minimumSize: const Size(double.infinity, 50),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: const Text('Proceed to Checkout',
                            style: TextStyle(color: Colors.white)),
                      ),
                    ),
                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ),
    );
  }
}
