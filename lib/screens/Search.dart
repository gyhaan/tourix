import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:tourix_app/screens/ticket_details.dart';
import 'package:tourix_app/widgets/bottom_bar.dart';
import '../widgets/TopBar.dart';
import '../widgets/TicketOptions.dart';

class Search extends StatefulWidget {
  const Search({super.key});

  @override
  _SearchState createState() => _SearchState();
}

class _SearchState extends State<Search> {
  final TextEditingController _searchController = TextEditingController();
  List<Map<String, dynamic>> trips = [];
  List<Map<String, dynamic>> filteredTrips = [];
  bool isLoading = true;
  bool isBooking = false; // State for loading indicator when booking
  String errorMessage = '';

  @override
  void initState() {
    super.initState();
    _fetchTrips();
  }

  Future<void> _fetchTrips() async {
    try {
      QuerySnapshot tripSnapshot =
          await FirebaseFirestore.instance.collection('trips').get();

      List<Map<String, dynamic>> loadedTrips = [];

      for (var tripDoc in tripSnapshot.docs) {
        DocumentReference tripRef =
            FirebaseFirestore.instance.collection('trips').doc(tripDoc.id);

        String departureCity =
            tripDoc['departureCity']?.toString() ?? 'Unknown';
        String destinationCity =
            tripDoc['destinationCity']?.toString() ?? 'Unknown';
        String tripRoute = "$departureCity - $destinationCity";

        String agencyName = "Unknown Agency";

        if (tripDoc['agencyID'] is DocumentReference) {
          DocumentReference agencyRef = tripDoc['agencyID'];

          try {
            DocumentSnapshot agencyDoc = await agencyRef.get();
            if (agencyDoc.exists) {
              var agencyData = agencyDoc.data() as Map<String, dynamic>?;
              agencyName = agencyData?['name'] ?? 'Unknown Agency';
            }
          } catch (e) {
            agencyName = 'Unknown Agency';
          }
        }

        loadedTrips.add({
          'tripID': tripRef,
          'trip': tripRoute,
          'agency': agencyName,
        });
      }

      setState(() {
        trips = loadedTrips;
        filteredTrips = loadedTrips;
        isLoading = false;
      });
    } catch (error) {
      setState(() {
        errorMessage = "Failed to load trips. Please try again.";
        isLoading = false;
      });
    }
  }

  Future<void> _createBooking(DocumentReference tripRef) async {
    setState(() {
      isBooking = true; // Hide all trips and show loading
    });

    try {
      User? user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        throw Exception("User not logged in");
      }

      DocumentReference travellerRef =
          FirebaseFirestore.instance.collection('users').doc(user.uid);

      DocumentReference bookingRef =
          await FirebaseFirestore.instance.collection('bookings').add({
        'travellerID': travellerRef,
        'tripID': tripRef,
        'active': false,
        'createdAt': FieldValue.serverTimestamp(),
      });

      String bookingDocID = bookingRef.id;

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => TravellersPage(bookingDocID: bookingDocID),
        ),
      );
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error creating booking: $error")),
      );
      setState(() {
        isBooking = false; // Show trips again if booking fails
      });
    }
  }

  void _filterTrips(String query) {
    setState(() {
      filteredTrips = query.isEmpty
          ? trips
          : trips.where((trip) {
              return trip['trip']!.toLowerCase().contains(query.toLowerCase());
            }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const TopBar(),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        child: Column(
          children: [
            const SizedBox(height: 20.0),
            TextField(
              controller: _searchController,
              onChanged: _filterTrips,
              decoration: const InputDecoration(
                labelText: 'Search Trips',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.search),
              ),
            ),
            const SizedBox(height: 10.0),
            Expanded(
              child: isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : errorMessage.isNotEmpty
                      ? Center(
                          child: Text(errorMessage,
                              style: const TextStyle(color: Colors.red)),
                        )
                      : isBooking
                          ? const Center(
                              child:
                                  CircularProgressIndicator()) // Show only the loader when booking
                          : filteredTrips.isEmpty
                              ? const Center(child: Text("No trips available."))
                              : ListView.builder(
                                  itemCount: filteredTrips.length,
                                  itemBuilder: (context, index) {
                                    return Column(
                                      children: [
                                        GestureDetector(
                                          onTap: () => _createBooking(
                                              filteredTrips[index]['tripID']),
                                          child: TicketOptions(
                                            trip: filteredTrips[index]['trip']!,
                                            agency: filteredTrips[index]
                                                ['agency']!,
                                          ),
                                        ),
                                        const SizedBox(height: 15.0),
                                      ],
                                    );
                                  },
                                ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: const BottomNavigationBarWidget(),
    );
  }
}
