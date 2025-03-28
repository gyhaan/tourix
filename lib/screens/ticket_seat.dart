import 'package:flutter/material.dart';
import 'package:tourix_app/widgets/bottom_bar.dart';

class SeatSelectionPage extends StatefulWidget {
  final List<Map<String, String>> travellerData;

  const SeatSelectionPage({super.key, required this.travellerData});

  @override
  _SeatSelectionPageState createState() => _SeatSelectionPageState();
}

class _SeatSelectionPageState extends State<SeatSelectionPage> {
  String? selectedSeatNumber;
  Set<String> bookedSeats = {};

  final List<String> seatNumbers =
      List<String>.generate(34, (index) => (index + 1).toString());

  void _goToNext() {
    if (selectedSeatNumber == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please select a seat number")),
      );
      return;
    }

    setState(() {
      bookedSeats.add(selectedSeatNumber!);
      selectedSeatNumber = null;
    });

    for (var traveller in widget.travellerData) {
      print("Name: ${traveller['name']}, Time: ${traveller['time']}, Booked Seat: $bookedSeats");
    }
  }

  Widget _buildSeatStatusList() {
    return Expanded(
      child: ListView.builder(
        itemCount: seatNumbers.length,
        itemBuilder: (context, index) {
          String seat = seatNumbers[index];
          bool isBooked = bookedSeats.contains(seat);
          return ListTile(
            leading: Icon(
              isBooked ? Icons.close : Icons.check_circle,
              color: isBooked ? Colors.red : Colors.green,
            ),
            title: Text('Seat $seat'),
            subtitle: Text(isBooked ? 'Booked' : 'Available'),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF3630A1),
        elevation: 0,
        title: Row(
          children: [
            Image.asset(
              'assets/images/frame.png',
              height: 32,
            ),
            const SizedBox(width: 8),
            const Text("Tourix"),
          ],
        ),
      ),
      body: Container(
        color: const Color(0xFFFFF0F3),
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
                'assets/images/image 1.png',
                height: 300,
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
              ],
            ),
            const SizedBox(height: 20),

            // ✅ Show selected seat number immediately below dropdown
            if (selectedSeatNumber != null)
              Row(
                children: [
                  const Icon(Icons.check_circle, color: Colors.green),
                  const SizedBox(width: 8),
                  Text(
                    'You selected seat number: $selectedSeatNumber',
                    style: const TextStyle(
                        fontSize: 16, fontWeight: FontWeight.w500),
                  ),
                ],
              ),

            const SizedBox(height: 20),
            _buildSeatStatusList(),

            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF3630A1),
                minimumSize: const Size(double.infinity, 50),
              ),
              onPressed: _goToNext,
              child: const Text(
                "Next",
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: const BottomNavigationBarWidget(),
    );
  }
}
