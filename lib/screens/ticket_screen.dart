import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tourix_app/screens/Search.dart';
import 'package:tourix_app/widgets/bottom_bar.dart';
import 'package:tourix_app/widgets/no_tickets_available.dart';
import '../models/ticket_info.dart';
import '../widgets/ticket_card.dart';

class TicketScreen extends StatefulWidget {
  final String userId; // Pass the user ID when navigating to this screen
  const TicketScreen({Key? key, required this.userId}) : super(key: key);

  @override
  _TicketScreenState createState() => _TicketScreenState();
}

class _TicketScreenState extends State<TicketScreen> {
  late Future<List<Map<String, dynamic>>> _ticketsFuture;

  @override
  void initState() {
    super.initState();
    _ticketsFuture = fetchUpcomingTickets(widget.userId);
  }

  Future<List<Map<String, dynamic>>> fetchUpcomingTickets(String userId) async {
    try {
      // Convert userId into a Firestore reference
      final userRef = FirebaseFirestore.instance.doc("users/$userId");
      print("Fetching tickets for userRef: $userRef");

      // Query upcoming tickets (without `active` filter)
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection("bookings")
          .where("travellerID", isEqualTo: userRef) // Reference comparison
          .where("departureTime",
              isGreaterThan:
                  Timestamp.fromDate(DateTime.now())) // Future tickets
          .orderBy("departureTime",
              descending: false) // Sort by upcoming departures
          .get();

      print("Found ${querySnapshot.docs.length} upcoming bookings.");

      // Map Firestore documents to TicketInfo objects
      List<Map<String, dynamic>> tickets = [];

      for (var doc in querySnapshot.docs) {
        var data = doc.data() as Map<String, dynamic>;

        // Step 1: Filter active bookings in Dart
        if (data["active"] != true) continue; // Skip inactive bookings

        print("\n--- Processing Booking Document ---");
        print("Booking Document ID: ${doc.id}");
        print("Booking Data: $data");

        // Step 2: Fetch trip document asynchronously
        DocumentReference tripRef = data["tripID"];
        print("Fetching Trip Document with tripID: $tripRef");

        // Fetch trip document
        DocumentSnapshot tripSnapshot = await tripRef.get();
        var tripData = tripSnapshot.data() as Map<String, dynamic>? ?? {};

        // Extract trip details
        String origin = tripData["departureCity"] ?? "Unknown";
        String destination = tripData["destinationCity"] ?? "Unknown";

        // Step 3: Fetch agency document asynchronously (if available)
        String agencyName = "Unknown Agency";
        if (tripData.containsKey("agencyID")) {
          DocumentReference agencyRef = tripData["agencyID"];
          print("Fetching Agency Document with agencyID: $agencyRef");

          // Fetch agency document
          DocumentSnapshot agencySnapshot = await agencyRef.get();
          var agencyData = agencySnapshot.data() as Map<String, dynamic>? ?? {};
          agencyName = agencyData["name"] ?? "Unknown Agency";
        }

        // Extract passenger count
        int passengers = (data["seatsBooked"] as List).length;

        // Construct ticket map
        var ticket = {
          "date": data["departureTime"]
              .toDate()
              .toString()
              .split(" ")[0], // Extract date
          "time": data["departureTime"]
              .toDate()
              .toString()
              .split(" ")[1], // Extract time
          "ticketCode": doc.id.substring(0, 5), // Shortened ticket code
          "origin": origin,
          "destination": destination,
          "passengers": passengers,
          "busType": agencyName, // Use agency name instead of busType
        };

        print("Created TicketInfo: $ticket");
        tickets.add(ticket);
      }

      print("\nTotal Tickets Fetched: ${tickets.length}");
      return tickets;
    } catch (e) {
      print("Error fetching tickets: $e");
      throw e;
    }
  }

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
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: 16.0),
            child: Icon(Icons.notifications, color: Colors.white),
          ),
        ],
      ),
      body: Column(
        children: [
          // Header
          Container(
            height: 140,
            width: double.infinity,
            decoration: const BoxDecoration(
              color: Color(0xFF3630A1),
              image: DecorationImage(
                image: NetworkImage(
                    'https://images.unsplash.com/photo-1494515843206-f3117d3f51b7?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=1172&q=80'),
                fit: BoxFit.cover,
                colorFilter: ColorFilter.mode(
                  Colors.black26,
                  BlendMode.darken,
                ),
              ),
            ),
            child: const Center(
              child: Text(
                'Upcoming Tickets',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          const SizedBox(
            height: 15,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Align(
              alignment: Alignment.centerRight,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => const Search()),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF3D2DB6), // Button color
                  foregroundColor: Colors.white, // Text color
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text('Book Ticket'),
              ),
            ),
          ),

          const SizedBox(
            height: 15,
          ),
          // Fetch and display tickets
          Expanded(
            child: FutureBuilder<List<Map<String, dynamic>>>(
              // Modify this to be the correct type.
              future: _ticketsFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text("Failed to load tickets."));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const NoTicketsAvailable();
                }

                final tickets = snapshot.data!;
                return ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  itemCount: tickets.length,
                  itemBuilder: (context, index) {
                    // Convert the map data into a TicketInfo object
                    final ticketData = tickets[index];
                    final ticket = TicketInfo(
                      date: ticketData['date'],
                      time: ticketData['time'],
                      ticketCode: ticketData['ticketCode'],
                      origin: ticketData['origin'],
                      destination: ticketData['destination'],
                      passengers: ticketData['passengers'],
                      busType: ticketData['busType'],
                    );

                    return Padding(
                      padding: const EdgeInsets.only(bottom: 16),
                      child: TicketCard(
                          ticket: ticket), // Pass TicketInfo instead of Map
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
      bottomNavigationBar: const BottomNavigationBarWidget(),
    );
  }
}
