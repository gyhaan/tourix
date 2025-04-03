import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tourix_app/widgets/bottom_bar.dart';
import '../widgets/TopBar.dart';
import '../widgets/TopImageScreen.dart';
import '../widgets/TicketInfoBody.dart';

class TicketInfoScreen extends StatefulWidget {
  final String uid;

  const TicketInfoScreen({super.key, required this.uid});

  @override
  _TicketInfoScreenState createState() => _TicketInfoScreenState();
}

class _TicketInfoScreenState extends State<TicketInfoScreen> {
  late Future<Map<String, dynamic>> _ticketDetailsFuture;

  @override
  void initState() {
    super.initState();
    _ticketDetailsFuture = fetchBookingDetails(widget.uid);
  }

  Future<Map<String, dynamic>> fetchBookingDetails(String uid) async {
    try {
      DocumentSnapshot bookingSnapshot = await FirebaseFirestore.instance
          .collection("bookings")
          .doc(uid)
          .get();
      if (!bookingSnapshot.exists) {
        throw "Booking not found";
      }
      var bookingData = bookingSnapshot.data() as Map<String, dynamic>;

      // Fetch trip details
      DocumentSnapshot tripSnapshot = await bookingData["tripID"].get();
      var tripData = tripSnapshot.data() as Map<String, dynamic>? ?? {};

      // Fetch agency details
      DocumentSnapshot agencySnapshot = await tripData["agencyID"].get();
      var agencyData = agencySnapshot.data() as Map<String, dynamic>? ?? {};

      // Fetch traveller details
      DocumentSnapshot travellerSnapshot =
          await bookingData["travellerID"].get();
      var travellerData =
          travellerSnapshot.data() as Map<String, dynamic>? ?? {};

      return {
        "name": travellerData["name"] ?? "Unknown",
        "departureDate":
            bookingData["departureTime"].toDate().toString().split(" ")[0],
        "departureTime": bookingData["departureTime"]
            .toDate()
            .toString()
            .split(" ")[1]
            .substring(0, 5),
        "from": tripData["departureCity"] ?? "Unknown",
        "to": tripData["destinationCity"] ?? "Unknown",
        "agency": agencyData["name"] ?? "Unknown Agency",
        "seatsBooked": bookingData["seatsBooked"].length,
        "seatName": bookingData["seatsBooked"].join(", "),
        "price": tripData["price"].toString(),
        "paymentMethod": bookingData["paymentMethod"] ?? "Unknown",
      };
    } catch (e) {
      print("Error fetching booking details: $e");
      rethrow;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const PreferredSize(
        preferredSize: Size.fromHeight(kToolbarHeight),
        child: TopBar(),
      ),
      body: FutureBuilder<Map<String, dynamic>>(
        future: _ticketDetailsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return const Center(child: Text("Error loading ticket details."));
          } else if (!snapshot.hasData) {
            return const Center(child: Text("No ticket details found."));
          }

          final ticketData = snapshot.data!;

          return SingleChildScrollView(
            child: Column(
              children: [
                const TopImageScreen(pageTitle: "Ticket Details"),
                const SizedBox(height: 30.0),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: TicketInfobody(
                    name: ticketData["name"],
                    departureDate: ticketData["departureDate"],
                    departureTime: ticketData["departureTime"],
                    from: ticketData["from"],
                    to: ticketData["to"],
                    agency: ticketData["agency"],
                    seatsBooked: ticketData["seatsBooked"],
                    seatName: ticketData["seatName"],
                    price: ticketData["price"],
                    paymentMethod: ticketData["paymentMethod"],
                  ),
                ),
                const SizedBox(height: 20.0),
              ],
            ),
          );
        },
      ),
      bottomNavigationBar: const BottomNavigationBarWidget(),
    );
  }
}
