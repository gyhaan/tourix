import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:tourix_app/widgets/bottom_bar.dart';
import 'ticket_seat.dart';

class TravellersPage extends StatefulWidget {
  const TravellersPage({super.key});

  @override
  _TravellersPageState createState() => _TravellersPageState();
}

class _TravellersPageState extends State<TravellersPage> {
  final TextEditingController travellerController = TextEditingController();
  List<Map<String, String>> travellers = [];
  String? selectedTime;

  List<String> generateTimeSlots() {
    List<String> times = [];
    DateTime start = DateTime(2025, 1, 1, 5, 0);
    DateTime end = DateTime(2025, 1, 1, 20, 0);
    DateFormat formatter = DateFormat('hh:mm a');

    while (start.isBefore(end) || start.isAtSameMomentAs(end)) {
      times.add(formatter.format(start));
      start = start.add(const Duration(minutes: 30));
    }
    return times;
  }

  void _addTraveller() {
    if (travellerController.text.isNotEmpty && selectedTime != null) {
      setState(() {
        travellers.add({
          'name': travellerController.text.trim(),
          'time': selectedTime!,
        });
        travellerController.clear();
      });
    }
  }

  void _goToNext() {
    if (travellers.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please add at least one traveller")),
      );
      return;
    }

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SeatSelectionPage(
          travellerData: travellers,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final timeSlots = generateTimeSlots();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF3630A1),
        elevation: 0,
        title: Row(
          children: [
            Image.asset(
              'assets/images/frame.png', // ✅ your logo image path
              height: 32,
            ),
            const SizedBox(width: 8),
            const Text("Tourix"),
          ],
        ),
      ),
      body: Container(
        color: const Color(0xFFFFF0F3),
        padding: const EdgeInsets.fromLTRB(16, 24, 16, 0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "When are you travelling?",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 8),
            DropdownButtonFormField<String>(
              value: selectedTime,
              items: timeSlots.map((String time) {
                return DropdownMenuItem<String>(
                  value: time,
                  child: Text(time),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  selectedTime = value;
                });
              },
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Departure Time',
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              "Add more travellers",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: travellerController,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: 'Enter traveller name',
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                IconButton(
                  icon: const Icon(Icons.add_circle, color: Color(0xFF3630A1)),
                  onPressed: _addTraveller,
                ),
              ],
            ),
            const SizedBox(height: 16),
            if (travellers.isNotEmpty)
              ...travellers.map(
                (traveller) => ListTile(
                  leading: const Icon(Icons.radio_button_checked,
                      color: Color(0xFF3630A1)),
                  title: Text(traveller['name'] ?? ''),
                  subtitle: Text("Departure: ${traveller['time']}"),
                ),
              ),
            const Spacer(),
            ElevatedButton(
              onPressed: _goToNext,
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                backgroundColor: const Color(0xFF3630A1),
              ),
              child: const Text(
                "Next",
                style: TextStyle(color: Colors.white), // ✅ white text
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: const BottomNavigationBarWidget(),
    );
  }
}
