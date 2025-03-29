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

      // Query upcoming tickets
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection("booking")
          .where("travellerID", isEqualTo: userRef) // Reference comparison
          .where("departureTime",
              isGreaterThan: DateTime.now()) // Future tickets
          .orderBy("departureTime",
              descending: false) // Sort by upcoming departures
          .get();

      print("Found ${querySnapshot.docs.length} upcoming bookings.");

      // Map Firestore documents to TicketInfo objects
      List<Map<String, dynamic>> tickets = [];
      for (var doc in querySnapshot.docs) {
        print("\n--- Processing Booking Document ---");
        print("Booking Document ID: ${doc.id}");
        var data = doc.data() as Map<String, dynamic>;
        print("Booking Data: $data");

        // Step 1: Resolve the tripID reference to get the trip document
        DocumentReference tripRef =
            data["tripID"]; // This is a DocumentReference
        print("Fetching Trip Document with tripID: $tripRef");
        DocumentSnapshot tripSnapshot = await tripRef.get();
        var tripData = tripSnapshot.data() as Map<String, dynamic>?;
        print("Trip Document Data: $tripData");

        // Extract origin and destination from the trip document
        String origin = tripData?["departureCity"] ?? "Unknown";
        String destination = tripData?["destinationCity"] ?? "Unknown";
        print("Extracted Origin: $origin, Destination: $destination");

        // Step 2: Resolve the agencyID reference inside the trip document
        String agencyName = "Unknown Agency";
        if (tripData != null && tripData.containsKey("agencyID")) {
          DocumentReference agencyRef =
              tripData["agencyID"]; // This is a DocumentReference
          print("Fetching Agency Document with agencyID: $agencyRef");
          DocumentSnapshot agencySnapshot = await agencyRef.get();
          var agencyData = agencySnapshot.data() as Map<String, dynamic>?;
          print("Agency Document Data: $agencyData");
          // Assuming the full name is stored in a field called "fullName" in the users collection
          agencyName = agencyData?["name"] ?? "Unknown Agency";
          print("Extracted Agency Name: $agencyName");
        } else {
          print("No agencyID found in trip document or tripData is null.");
        }

        var ticket = {
          "date": data["departureTime"]
              .toDate()
              .toString()
              .split(" ")[0], // Extract date
          "time": data["departureTime"]
              .toDate()
              .toString()
              .split(" ")[1], // Extract time
          "ticketCode": doc.id
              .substring(0, 5), // Use Firestore document ID as ticket code
          "origin": origin, // From trip document
          "destination": destination, // From trip document
          "passengers": (data["seatsBooked"] as List).length,
          // "busType": data["busType"] ?? "Standard",
          "busType": agencyName, // Add the agency name to the map
        };

        print(
            "Created TicketInfo: { date: ${data["departureTime"].toDate().toString().split(" ")[0]}, time: ${data["departureTime"].toDate().toString().split(" ")[1]}, ticketCode: ${doc.id}, origin: ${origin}, destination: ${destination}, passengers: ${(data["seatsBooked"] as List).length}, busType: ${data["busType"]} }");

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
                  Navigator.push(
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
