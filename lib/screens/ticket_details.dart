import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tourix_app/widgets/bottom_bar.dart';
import 'ticket_seat.dart';

class TravellersPage extends StatefulWidget {
  final String bookingDocID;
  const TravellersPage({super.key, required this.bookingDocID});

  @override
  _TravellersPageState createState() => _TravellersPageState();
}

class _TravellersPageState extends State<TravellersPage> {
  final TextEditingController travellerController = TextEditingController();
  List<Map<String, String>> travellers = [];
  String? selectedTime;
  DateTime? selectedDate;
  bool isLoading = false; // Track loading state

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

  void _goToNext() async {
    if (selectedDate == null || selectedTime == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please fill all details")),
      );
      return;
    }

    DateTime departureDateTime = DateTime(
      selectedDate!.year,
      selectedDate!.month,
      selectedDate!.day,
      int.parse(selectedTime!.split(":")[0]),
      int.parse(selectedTime!.split(":")[1].split(" ")[0]),
    );

    setState(() {
      isLoading = true;
    });

    try {
      DocumentSnapshot bookingSnapshot = await FirebaseFirestore.instance
          .collection('bookings')
          .doc(widget.bookingDocID)
          .get();

      if (!bookingSnapshot.exists) {
        throw Exception("Booking not found");
      }

      Map<String, dynamic> bookingData =
          bookingSnapshot.data() as Map<String, dynamic>;
      DocumentReference tripRef = bookingData['tripID'];

      DocumentSnapshot tripSnapshot = await tripRef.get();

      if (!tripSnapshot.exists) {
        throw Exception("Trip details not found");
      }

      Map<String, dynamic> tripData =
          tripSnapshot.data() as Map<String, dynamic>;
      String departureCity = tripData['departureCity'];
      String destinationCity = tripData['destinationCity'];

      List<dynamic> totalSeats = List.from(tripData['availableSeats'] ?? []);

      QuerySnapshot bookingsSnapshot = await FirebaseFirestore.instance
          .collection('bookings')
          .where('departureTime', isEqualTo: departureDateTime)
          .where('active', isEqualTo: true)
          .get();

      List<List<dynamic>> bookedSeats = [];

      for (var doc in bookingsSnapshot.docs) {
        var data = doc.data() as Map<String, dynamic>;
        var tripRef = data['tripID'] as DocumentReference;
        DocumentSnapshot tripSnap = await tripRef.get();
        if (!tripSnap.exists) continue;

        var tripDetails = tripSnap.data() as Map<String, dynamic>;
        if (tripDetails['departureCity'] == departureCity &&
            tripDetails['destinationCity'] == destinationCity) {
          bookedSeats.add(List.from(data['seatsBooked']));
        }
      }

      List<dynamic> allBookedSeats = bookedSeats.expand((x) => x).toList();
      int remainingSeats = totalSeats.length - allBookedSeats.length;

      if (travellers.length + 1 > remainingSeats) {
        throw Exception("Not enough seats available for the selected trip.");
      }

      await FirebaseFirestore.instance
          .collection('bookings')
          .doc(widget.bookingDocID)
          .update({
        'departureTime': departureDateTime,
      });

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => SeatSelectionPage(
            travellerData: travellers,
            bookingDocID: widget.bookingDocID,
          ),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: $e")),
      );

      print(e);
    } finally {
      setState(() {
        isLoading = false;
      });
    }
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
        padding: const EdgeInsets.fromLTRB(16, 24, 16, 0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "When are you travelling?",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 8),
            GestureDetector(
              onTap: () async {
                DateTime? pickedDate = await showDatePicker(
                  context: context,
                  initialDate: selectedDate ?? DateTime.now(),
                  firstDate: DateTime.now(),
                  lastDate: DateTime(2101),
                );
                if (pickedDate != null) {
                  setState(() {
                    selectedDate = pickedDate;
                  });
                }
              },
              child: AbsorbPointer(
                child: TextField(
                  decoration: InputDecoration(
                    labelText: 'Departure Date',
                    hintText: selectedDate == null
                        ? 'Pick a date'
                        : DateFormat('yyyy-MM-dd').format(selectedDate!),
                    border: const OutlineInputBorder(),
                  ),
                ),
              ),
            ),
            if (selectedDate != null) ...[
              const SizedBox(height: 8),
              Text(
                "Selected Date: ${DateFormat('EEEE, MMMM d, yyyy').format(selectedDate!)}",
                style:
                    const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
              ),
            ],
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
            const Text("Add more travellers",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
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
            Expanded(
              child: ListView.builder(
                itemCount: travellers.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    leading: const Icon(Icons.radio_button_checked,
                        color: Color(0xFF3630A1)),
                    title: Text(travellers[index]['name'] ?? ''),
                    subtitle: Text("Departure: ${travellers[index]['time']}"),
                  );
                },
              ),
            ),
            isLoading
                ? const Center(child: CircularProgressIndicator())
                : ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF3630A1),
                      minimumSize: const Size(double.infinity, 50),
                    ),
                    onPressed: _goToNext,
                    child: const Text("Next",
                        style: TextStyle(color: Colors.white)),
                  ),
          ],
        ),
      ),
      bottomNavigationBar: const BottomNavigationBarWidget(),
    );
  }
}
