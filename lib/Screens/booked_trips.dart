import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:tourix_app/widgets/TopBar.dart';

class BookedTrips extends StatefulWidget {
  const BookedTrips({Key? key}) : super(key: key);

  @override
  _BookedTripsState createState() => _BookedTripsState();
}

class _BookedTripsState extends State<BookedTrips> {
  List<Map<String, dynamic>> bookings = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchBookings();
  }

  Future<void> fetchBookings() async {
    try {
      User? user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        print("No user logged in - UID is null");
        setState(() {
          isLoading = false;
        });
        return;
      }
      print("Logged in user UID: ${user.uid}");

      DocumentReference agencyRef =
          FirebaseFirestore.instance.collection("users").doc(user.uid);

      QuerySnapshot bookingSnapshot = await FirebaseFirestore.instance
          .collection("bookings")
          .where("active", isEqualTo: true)
          .get();
      print(
          "Number of booking documents found: ${bookingSnapshot.docs.length}");

      List<Map<String, dynamic>> filteredBookings = [];

      for (var doc in bookingSnapshot.docs) {
        var data = doc.data() as Map<String, dynamic>;
        print("Booking doc data: $data");

        if (!data.containsKey("tripID")) {
          print("Missing tripID in booking: ${doc.id}");
          continue;
        }
        DocumentReference tripRef = data["tripID"];
        DocumentSnapshot tripSnapshot = await tripRef.get();
        var tripData = tripSnapshot.data() as Map<String, dynamic>?;

        if (tripData == null || tripData["agencyID"].id != agencyRef.id) {
          print("Trip Agency ID: ${tripData?["agencyID"].id}");
          print("Current User Agency ID: ${agencyRef.id}");
          print("Trip not found or doesn't belong to agency: ${tripRef.id}");
          continue;
        }

        // Extract departure and destination cities
        String departureCity = tripData["departureCity"] ?? "Unknown";
        String destinationCity = tripData["destinationCity"] ?? "Unknown";

        // Extract traveller name
        String travellerName = "Unknown Traveller";
        if (data.containsKey("travellerID")) {
          DocumentReference travellerRef = data["travellerID"];
          DocumentSnapshot travellerSnapshot = await travellerRef.get();
          var travellerData = travellerSnapshot.data() as Map<String, dynamic>?;
          travellerName = travellerData?["name"] ?? "Unknown Traveller";
        }

        // Extract and format departure time
        Timestamp? departureTimestamp = data["departureTime"] as Timestamp?;
        DateTime departureTime =
            departureTimestamp?.toDate() ?? DateTime(1970, 1, 1);
        String formattedDeparture =
            "${departureTime.year}-${departureTime.month.toString().padLeft(2, '0')}-${departureTime.day.toString().padLeft(2, '0')} "
            "${departureTime.hour.toString().padLeft(2, '0')}:${departureTime.minute.toString().padLeft(2, '0')}";

        // Extract payment method and seat count
        String paymentMethod = data["paymentMethod"] ?? "Unknown";
        List<dynamic> seats = (data["seatsBooked"] as List<dynamic>?) ?? [];
        int seatsCount = seats.length;

        filteredBookings.add({
          "travellerName": travellerName,
          "departureCity": departureCity,
          "destinationCity": destinationCity,
          "departureTime": formattedDeparture,
          "paymentMethod": paymentMethod,
          "seatsBooked": seatsCount,
        });
      }

      print("Filtered bookings: $filteredBookings");
      setState(() {
        bookings = filteredBookings;
        isLoading = false;
      });
    } catch (e) {
      print("Error fetching bookings: $e");
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const TopBar(),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : bookings.isEmpty
              ? const Center(child: Text("No bookings available"))
              : ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: bookings.length,
                  itemBuilder: (context, index) {
                    var booking = bookings[index];
                    return Card(
                      elevation: 0, // Remove shadow
                      margin: const EdgeInsets.only(bottom: 16),
                      shape: RoundedRectangleBorder(
                        side: const BorderSide(
                            color: Color(0xFF3D2DB6), width: 2), // Add border
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(12),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Traveller: ${booking["travellerName"]}",
                              style: const TextStyle(
                                  color: Color(0xFF3D2DB6),
                                  fontWeight: FontWeight.bold),
                            ),
                            Text(
                              "From: ${booking["departureCity"]} → ${booking["destinationCity"]}",
                              style: const TextStyle(color: Color(0xFF3D2DB6)),
                            ),
                            Text(
                              "Departure: ${booking["departureTime"]}",
                              style: const TextStyle(color: Color(0xFF3D2DB6)),
                            ),
                            Text(
                              "Payment: ${booking["paymentMethod"]}",
                              style: const TextStyle(color: Color(0xFF3D2DB6)),
                            ),
                            Text(
                              "Seats: ${booking["seatsBooked"]}",
                              style: const TextStyle(color: Color(0xFF3D2DB6)),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
    );
  }
}
