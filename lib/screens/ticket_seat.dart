import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tourix_app/widgets/bottom_bar.dart';

class SeatSelectionPage extends StatefulWidget {
  final String bookingDocID;
  final List<Map<String, String>> travellerData;

  const SeatSelectionPage({
    super.key,
    required this.travellerData,
    required this.bookingDocID,
  });

  @override
  _SeatSelectionPageState createState() => _SeatSelectionPageState();
}

class _SeatSelectionPageState extends State<SeatSelectionPage> {
  String? selectedSeatNumber;
  Set<String> bookedSeats = {};

  final List<String> seatNumbers =
      List<String>.generate(34, (index) => "A${index + 1}");

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
    if (bookedSeats.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please select at least one seat")),
      );
      return;
    }

    try {
      await FirebaseFirestore.instance
          .collection('booking')
          .doc(widget.bookingDocID)
          .update({
        'seatsBooked': bookedSeats.toList(),
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Booking updated successfully!")),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error updating booking: $e")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF3630A1),
        elevation: 0,
        title: Row(
          children: [
            Image.asset('assets/images/frame.png', height: 32),
            const SizedBox(width: 8),
            const Text("Tourix"),
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          color: Colors.white,
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Select Bus Seats",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
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
                  const Text("Seat Nbr:", style: TextStyle(fontSize: 16)),
                  const SizedBox(width: 16),
                  Expanded(
                    child: DropdownButtonFormField<String>(
                      value: selectedSeatNumber,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        contentPadding: EdgeInsets.symmetric(horizontal: 12),
                      ),
                      items: seatNumbers.map((String number) {
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
                          vertical: 12, horizontal: 16),
                    ),
                    onPressed: _addSeat,
                    child: const Text(
                      "+",
                      style: TextStyle(color: Colors.white, fontSize: 20),
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
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 10),
                    SizedBox(
                      height: 100,
                      child: ListView.builder(
                        shrinkWrap: true,
                        itemCount: bookedSeats.length,
                        itemBuilder: (context, index) {
                          String seat = bookedSeats.elementAt(index);
                          return ListTile(
                            title: Text("Seat $seat"),
                            trailing: IconButton(
                              icon: const Icon(Icons.close, color: Colors.red),
                              onPressed: () => _removeSeat(seat),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              const SizedBox(height: 20),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF3630A1),
                  minimumSize: const Size(double.infinity, 50),
                ),
                onPressed: _updateBookingInFirestore,
                child: const Text(
                  "Next",
                  style: TextStyle(color: Colors.white),
                ),
              ),
              const SizedBox(height: 15),
            ],
          ),
        ),
      ),
      bottomNavigationBar: const BottomNavigationBarWidget(),
    );
  }
}
