import 'package:flutter/material.dart';
import 'package:tourix_app/models/bookInfo.dart';
import 'package:tourix_app/widgets/bottom_bar.dart';

class BookingInfoScreen extends StatelessWidget {
  final BookingInfo bookingInfo;

  const BookingInfoScreen({
    Key? key,
    required this.bookingInfo,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: const Color(0xFF3630A1),
        elevation: 0,
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(5),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(5),
              ),
              child: const Icon(Icons.home, color: Color(0xFF3630A1), size: 20),
            ),
            const SizedBox(width: 8),
            const Text(
              'Tourix',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              // Booking Info Section
              const Text(
                'Booking Info',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 24),

              // Booking Info Details
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Column(
                  children: [
                    _buildInfoRow('Name:', bookingInfo.userName),
                    const SizedBox(height: 12),
                    _buildInfoRow('Departure Time:', bookingInfo.departureTime),
                    const SizedBox(height: 12),
                    _buildInfoRow('From:', bookingInfo.fromLocation),
                    const SizedBox(height: 12),
                    _buildInfoRow('To:', bookingInfo.toLocation),
                    const SizedBox(height: 12),
                    _buildInfoRow('Agency:', bookingInfo.agencyName),
                    const SizedBox(height: 12),
                    _buildInfoRow(
                        'Seats Booked:', bookingInfo.seatsBooked.toString()),
                    const SizedBox(height: 12),
                    _buildInfoRow('Price:', bookingInfo.price),
                  ],
                ),
              ),

              const SizedBox(height: 32),

              // Payment Section
              const Text(
                'Payment',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 24),

              // Phone Number Input
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
                        controller: TextEditingController(
                            text: bookingInfo.phoneNumber),
                        decoration: InputDecoration(
                          contentPadding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 14),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide:
                                const BorderSide(color: Colors.grey, width: 1),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide:
                                const BorderSide(color: Colors.grey, width: 1),
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
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF3630A1),
                    minimumSize: const Size(double.infinity, 50),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text(
                    'Proceed to Checkout',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
      bottomNavigationBar: const BottomNavigationBarWidget(),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Row(
      children: [
        Text(
          label,
          style: const TextStyle(
            fontWeight: FontWeight.w500,
            fontSize: 18,
            color: Colors.black87,
          ),
        ),
        const SizedBox(width: 8),
        Text(
          value,
          style: const TextStyle(
            fontWeight: FontWeight.w400,
            fontSize: 18,
            color: Colors.black87,
          ),
        ),
      ],
    );
  }
}
