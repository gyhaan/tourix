import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tourix_app/screens/booking_info.dart';
import 'package:tourix_app/widgets/BottomBar.dart';

class SeatSelectionPage extends StatefulWidget {
  final String bookingDocID;
  final List<Map<String, String>> travellerData;
  final FirebaseFirestore? firestore;

  const SeatSelectionPage({
    super.key,
    required this.travellerData,
    required this.bookingDocID,
    this.firestore,
  });

  @override
  _SeatSelectionPageState createState() => _SeatSelectionPageState();
}

class _SeatSelectionPageState extends State<SeatSelectionPage> {
  String? selectedSeatNumber;
  Set<String> bookedSeats = {};
  List<String> availableSeats = [];
  bool isLoading = true;
  bool isSubmitting = false;
  bool _initialized = false;

  FirebaseFirestore get _firestore =>
      widget.firestore ?? FirebaseFirestore.instance;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_initialized) {
      _initialized = true;
      _fetchAvailableSeats();
    }
  }

  Future<void> _fetchAvailableSeats() async {
    if (!mounted) return;
    setState(() => isLoading = true);

    try {
      // Get booking document using bookingDocID
      DocumentSnapshot bookingDoc =
          await _firestore
              .collection('bookings')
              .doc(widget.bookingDocID)
              .get();

      if (!mounted) return;

      if (!bookingDoc.exists) {
        setState(() => isLoading = false);
        return;
      }

      // Convert tripID from Firestore reference to String
      DocumentReference tripRef = bookingDoc['tripID'];
      String tripID = tripRef.id;

      Timestamp departureTime = bookingDoc['departureTime'];

      // Fetch trip details using tripID reference
      DocumentSnapshot tripDoc = await tripRef.get();

      if (!mounted) return;

      if (!tripDoc.exists) {
        setState(() => isLoading = false);
        return;
      }

      List<String> totalSeats = List<String>.from(tripDoc['availableSeats']);

      // Fetch all active bookings for the same trip & departureTime
      QuerySnapshot bookingSnapshot =
          await _firestore
              .collection('bookings')
              .where('tripID', isEqualTo: tripRef)
              .where('departureTime', isEqualTo: departureTime)
              .where('active', isEqualTo: true)
              .get();

      if (!mounted) return;

      Set<String> allBookedSeats = {};

      for (var doc in bookingSnapshot.docs) {
        List<dynamic> seats = doc['seatsBooked'] ?? [];
        allBookedSeats.addAll(seats.map((e) => e.toString()));
      }

      // Filter available seats
      List<String> filteredSeats =
          totalSeats.where((seat) => !allBookedSeats.contains(seat)).toList();

      setState(() {
        availableSeats = filteredSeats;
        isLoading = false;
      });
    } catch (e) {
      print(e);
      if (!mounted) return;
      setState(() => isLoading = false);
      // Use Future.microtask to show the error after the build is complete
      Future.microtask(() {
        if (mounted) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text("Error fetching seats: $e")));
        }
      });
    }
  }

  void _addSeat() {
    if (selectedSeatNumber == null ||
        bookedSeats.contains(selectedSeatNumber)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please select a valid seat number")),
      );
      return;
    }

    setState(() {
      bookedSeats.add(selectedSeatNumber!);
      selectedSeatNumber = null;
    });
  }

  void _removeSeat(String seat) {
    setState(() {
      bookedSeats.remove(seat);
    });
  }

  Future<void> _updateBookingInFirestore() async {
    int requiredSeats = widget.travellerData.length + 1;

    if (bookedSeats.length != requiredSeats) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            "You must select exactly $requiredSeats seats before proceeding!",
          ),
        ),
      );
      return;
    }

    setState(() => isSubmitting = true);

    try {
      await _firestore.collection('bookings').doc(widget.bookingDocID).update({
        'seatsBooked': bookedSeats.toList(),
      });

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Booking updated successfully!")),
      );

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder:
              (context) => BookingInfoScreen(bookingId: widget.bookingDocID),
        ),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Error updating booking: $e")));
    } finally {
      if (mounted) {
        setState(() => isSubmitting = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF3630A1),
        iconTheme: const IconThemeData(color: Colors.white),
        elevation: 0,
        title: Row(
          children: [
            Image.asset('assets/images/Frame.png', height: 32),
            const SizedBox(width: 8),
            const Text("Tourix", style: TextStyle(color: Colors.white)),
          ],
        ),
      ),
      body:
          isLoading
              ? const Center(child: CircularProgressIndicator())
              : SingleChildScrollView(
                child: Container(
                  color: Colors.white,
                  padding: const EdgeInsets.fromLTRB(
                    16,
                    16,
                    16,
                    50,
                  ), // Added bottom padding
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "Select Bus Seats",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      Center(
                        child: Image.asset(
                          'assets/images/Bus_seats.jpg',
                          height: MediaQuery.of(context).size.height * 0.6,
                          fit: BoxFit.contain,
                        ),
                      ),
                      const SizedBox(height: 20),
                      Row(
                        children: [
                          const Text(
                            "Seat Nbr:",
                            style: TextStyle(fontSize: 16),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: DropdownButtonFormField<String>(
                              value: selectedSeatNumber,
                              decoration: const InputDecoration(
                                border: OutlineInputBorder(),
                                contentPadding: EdgeInsets.symmetric(
                                  horizontal: 12,
                                ),
                              ),
                              items:
                                  availableSeats.map((String number) {
                                    return DropdownMenuItem<String>(
                                      value: number,
                                      child: Text(number),
                                    );
                                  }).toList(),
                              onChanged: (value) {
                                setState(() {
                                  selectedSeatNumber = value;
                                });
                              },
                            ),
                          ),
                          const SizedBox(width: 10),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF3630A1),
                              padding: const EdgeInsets.symmetric(
                                vertical: 12,
                                horizontal: 16,
                              ),
                            ),
                            onPressed: _addSeat,
                            child: const Text(
                              "+",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      if (bookedSeats.isNotEmpty)
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              "Selected Seats:",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 10),
                            Wrap(
                              spacing: 8,
                              runSpacing: 8,
                              children:
                                  bookedSeats.map((seat) {
                                    return Chip(
                                      label: Text(seat),
                                      onDeleted: () => _removeSeat(seat),
                                      backgroundColor: const Color(0xFF3630A1),
                                      labelStyle: const TextStyle(
                                        color: Colors.white,
                                      ),
                                      deleteIconColor: Colors.white,
                                    );
                                  }).toList(),
                            ),
                          ],
                        ),
                      const SizedBox(height: 20),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF3630A1),
                          minimumSize: const Size(double.infinity, 50),
                        ),
                        onPressed:
                            isSubmitting ? null : _updateBookingInFirestore,
                        child:
                            isSubmitting
                                ? const CircularProgressIndicator(
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                    Colors.white,
                                  ),
                                )
                                : const Text(
                                  "Confirm Seats",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                      ),
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ),
      bottomNavigationBar: const BottomBar(),
    );
  }
}
