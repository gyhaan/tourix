import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart'; // Import Firebase Auth
import 'package:tourix_app/screens/Search.dart';
import 'package:tourix_app/screens/TicketInfo.dart';
import 'package:tourix_app/widgets/bottom_bar.dart';
import 'package:tourix_app/widgets/no_tickets_available.dart';
import '../models/ticket_info.dart';
import '../widgets/ticket_card.dart';

class TicketScreen extends StatefulWidget {
  const TicketScreen({Key? key}) : super(key: key);

  @override
  _TicketScreenState createState() => _TicketScreenState();
}

class _TicketScreenState extends State<TicketScreen> {
  late Future<List<Map<String, dynamic>>> _ticketsFuture;

  @override
  void initState() {
    super.initState();
    _ticketsFuture = fetchUpcomingTickets();
  }

  Future<List<Map<String, dynamic>>> fetchUpcomingTickets() async {
    try {
      // Get current user
      User? user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        print("No authenticated user found.");
        return [];
      }

      String userId = user.uid;
      final userRef = FirebaseFirestore.instance.doc("users/$userId");
      print("Fetching tickets for userRef: $userRef");

      // Query upcoming tickets
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection("bookings")
          .where("travellerID", isEqualTo: userRef)
          .where("departureTime",
              isGreaterThan: Timestamp.fromDate(DateTime.now()))
          .orderBy("departureTime", descending: false)
          .get();

      print("Found ${querySnapshot.docs.length} upcoming bookings.");

      List<Map<String, dynamic>> tickets = [];

      for (var doc in querySnapshot.docs) {
        var data = doc.data() as Map<String, dynamic>;
        if (data["active"] != true) continue;

        print("\n--- Processing Booking Document ---");
        print("Booking Document ID: ${doc.id}");
        print("Booking Data: $data");

        // Fetch trip details
        DocumentReference tripRef = data["tripID"];
        DocumentSnapshot tripSnapshot = await tripRef.get();
        var tripData = tripSnapshot.data() as Map<String, dynamic>? ?? {};

        String origin = tripData["departureCity"] ?? "Unknown";
        String destination = tripData["destinationCity"] ?? "Unknown";

        // Fetch agency details
        String agencyName = "Unknown Agency";
        if (tripData.containsKey("agencyID")) {
          DocumentReference agencyRef = tripData["agencyID"];
          DocumentSnapshot agencySnapshot = await agencyRef.get();
          var agencyData = agencySnapshot.data() as Map<String, dynamic>? ?? {};
          agencyName = agencyData["name"] ?? "Unknown Agency";
        }

        int passengers = (data["seatsBooked"] as List).length;

        var ticket = {
          "bookingId": doc.id,
          "date": data["departureTime"].toDate().toString().split(" ")[0],
          "time": data["departureTime"].toDate().toString().split(" ")[1],
          "ticketCode": doc.id.substring(0, 5),
          "origin": origin,
          "destination": destination,
          "passengers": passengers,
          "busType": agencyName,
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

  Future<void> cancelTicket(String bookingId) async {
    await FirebaseFirestore.instance
        .collection("bookings")
        .doc(bookingId)
        .update({"active": false});
    setState(() {
      _ticketsFuture = fetchUpcomingTickets();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: const Color(0xFF3630A1),
        iconTheme: const IconThemeData(color: Colors.white),
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
          Container(
            height: 140,
            width: double.infinity,
            decoration: const BoxDecoration(
              color: Color(0xFF3630A1),
              image: DecorationImage(
                image: NetworkImage(
                    'https://images.unsplash.com/photo-1494515843206-f3117d3f51b7?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fA%3D%3D&auto=format&fit=crop&w=1172&q=80'),
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
          const SizedBox(height: 15),
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
                  backgroundColor: const Color(0xFF3D2DB6),
                  foregroundColor: Colors.white,
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
          const SizedBox(height: 15),
          Expanded(
            child: FutureBuilder<List<Map<String, dynamic>>>(
              future: _ticketsFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return const Center(child: Text("Failed to load tickets."));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const NoTicketsAvailable();
                }

                final tickets = snapshot.data!;
                return ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  itemCount: tickets.length,
                  itemBuilder: (context, index) {
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

                    return Dismissible(
                      key: Key(ticketData['bookingId']),
                      direction: DismissDirection.endToStart,
                      background: Container(
                        color: Colors.red,
                        alignment: Alignment.centerRight,
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: const Icon(Icons.delete, color: Colors.white),
                      ),
                      confirmDismiss: (direction) async {
                        return await showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                            title: const Text("Cancel Ticket"),
                            content: const Text(
                                "Are you sure you want to cancel this ticket?"),
                            actions: [
                              TextButton(
                                onPressed: () =>
                                    Navigator.of(context).pop(false),
                                child: const Text("No"),
                              ),
                              TextButton(
                                onPressed: () =>
                                    Navigator.of(context).pop(true),
                                child: const Text("Yes"),
                              ),
                            ],
                          ),
                        );
                      },
                      onDismissed: (direction) {
                        cancelTicket(ticketData['bookingId']);
                      },
                      child: GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => TicketInfoScreen(
                                  uid: ticketData['bookingId']),
                            ),
                          );
                        },
                        child: Padding(
                          padding: const EdgeInsets.only(bottom: 16),
                          child: TicketCard(ticket: ticket),
                        ),
                      ),
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


// import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:tourix_app/screens/Search.dart';
// import 'package:tourix_app/screens/TicketInfo.dart';
// import 'package:tourix_app/widgets/bottom_bar.dart';
// import 'package:tourix_app/widgets/no_tickets_available.dart';
// import '../models/ticket_info.dart';
// import '../widgets/ticket_card.dart';

// class TicketScreen extends StatefulWidget {
//   const TicketScreen({Key? key}) : super(key: key);

//   @override
//   _TicketScreenState createState() => _TicketScreenState();
// }

// class _TicketScreenState extends State<TicketScreen> {
//   late Future<List<Map<String, dynamic>>> _ticketsFuture;

//   @override
//   void initState() {
//     super.initState();
//     _ticketsFuture = fetchUpcomingTickets();
//   }

//   Future<List<Map<String, dynamic>>> fetchUpcomingTickets() async {
//     try {
//       User? user = FirebaseAuth.instance.currentUser;
//       if (user == null) return [];
      
//       String userId = user.uid;
//       final userRef = FirebaseFirestore.instance.doc("users/$userId");

//       QuerySnapshot querySnapshot = await FirebaseFirestore.instance
//           .collection("bookings")
//           .where("travellerID", isEqualTo: userRef)
//           .where("departureTime", isGreaterThan: Timestamp.fromDate(DateTime.now()))
//           .where("active", isEqualTo: true)
//           .orderBy("departureTime", descending: false)
//           .get();

//       List<Map<String, dynamic>> tickets = querySnapshot.docs.map((doc) {
//         var data = doc.data() as Map<String, dynamic>;
//         return {
//           "bookingId": doc.id,
//           "date": data["departureTime"].toDate().toString().split(" ")[0],
//           "time": data["departureTime"].toDate().toString().split(" ")[1],
//           "ticketCode": doc.id.substring(0, 5),
//           "origin": data["tripID"]["departureCity"] ?? "Unknown",
//           "destination": data["tripID"]["destinationCity"] ?? "Unknown",
//           "passengers": (data["seatsBooked"] as List).length,
//           "busType": "Agency", // Fetch agency info if needed
//         };
//       }).toList();

//       return tickets;
//     } catch (e) {
//       print("Error fetching tickets: $e");
//       return [];
//     }
//   }

//   Future<void> cancelTicket(String bookingId) async {
//     await FirebaseFirestore.instance.collection("bookings").doc(bookingId).update({"active": false});
//     setState(() {
//       _ticketsFuture = fetchUpcomingTickets();
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         automaticallyImplyLeading: false,
//         backgroundColor: const Color(0xFF3630A1),
//         title: const Text('Tourix', style: TextStyle(color: Colors.white)),
//       ),
//       body: FutureBuilder<List<Map<String, dynamic>>>(
//         future: _ticketsFuture,
//         builder: (context, snapshot) {
//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return const Center(child: CircularProgressIndicator());
//           } else if (snapshot.hasError || !snapshot.hasData || snapshot.data!.isEmpty) {
//             return const NoTicketsAvailable();
//           }

//           final tickets = snapshot.data!;
//           return ListView.builder(
//             padding: const EdgeInsets.symmetric(horizontal: 24),
//             itemCount: tickets.length,
//             itemBuilder: (context, index) {
//               final ticketData = tickets[index];
//               final ticket = TicketInfo(
//                 date: ticketData['date'],
//                 time: ticketData['time'],
//                 ticketCode: ticketData['ticketCode'],
//                 origin: ticketData['origin'],
//                 destination: ticketData['destination'],
//                 passengers: ticketData['passengers'],
//                 busType: ticketData['busType'],
//               );
              
//               return Dismissible(
//                 key: Key(ticketData['bookingId']),
//                 direction: DismissDirection.endToStart,
//                 background: Container(
//                   color: Colors.red,
//                   alignment: Alignment.centerRight,
//                   padding: const EdgeInsets.symmetric(horizontal: 20),
//                   child: const Icon(Icons.delete, color: Colors.white),
//                 ),
//                 confirmDismiss: (direction) async {
//                   return await showDialog(
//                     context: context,
//                     builder: (context) => AlertDialog(
//                       title: const Text("Cancel Ticket"),
//                       content: const Text("Are you sure you want to cancel this ticket?"),
//                       actions: [
//                         TextButton(
//                           onPressed: () => Navigator.of(context).pop(false),
//                           child: const Text("No"),
//                         ),
//                         TextButton(
//                           onPressed: () => Navigator.of(context).pop(true),
//                           child: const Text("Yes"),
//                         ),
//                       ],
//                     ),
//                   );
//                 },
//                 onDismissed: (direction) {
//                   cancelTicket(ticketData['bookingId']);
//                 },
//                 child: GestureDetector(
//                   onTap: () {
//                     Navigator.push(
//                       context,
//                       MaterialPageRoute(
//                         builder: (context) => TicketInfoScreen(uid: ticketData['bookingId']),
//                       ),
//                     );
//                   },
//                   child: Padding(
//                     padding: const EdgeInsets.only(bottom: 16),
//                     child: TicketCard(ticket: ticket),
//                   ),
//                 ),
//               );
//             },
//           );
//         },
//       ),
//       bottomNavigationBar: const BottomNavigationBarWidget(),
//     );
//   }
// }
