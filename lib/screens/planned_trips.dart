import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tourix_app/models/planned_trips_info.dart';
import 'package:tourix_app/widgets/bottom_bar.dart';
import 'package:tourix_app/widgets/planned_trip_card.dart';

class PlannedTrips extends StatefulWidget {
  final String userId;
  const PlannedTrips({Key? key, required this.userId}) : super(key: key);

  @override
  _PlannedTripsState createState() => _PlannedTripsState();
}

class _PlannedTripsState extends State<PlannedTrips> {
  Future<List<PlannedTripsInfo>> fetchPlannedTrips() async {
    try {
      QuerySnapshot tripSnapshot =
          await FirebaseFirestore.instance.collection("trips").get();

      List<PlannedTripsInfo> trips = [];

      for (var doc in tripSnapshot.docs) {
        var data = doc.data() as Map<String, dynamic>;
        String origin = data["departureCity"] ?? "Unknown";
        String destination = data["destinationCity"] ?? "Unknown";
        int price = data["price"] ?? 0;
        int seats = data["totalSeats"] ?? 0;

        // Fetch agency name
        String agencyName = "Unknown Agency";
        if (data.containsKey("agencyID")) {
          DocumentReference agencyRef = data["agencyID"];
          DocumentSnapshot agencySnapshot = await agencyRef.get();
          var agencyData = agencySnapshot.data() as Map<String, dynamic>?;
          agencyName = agencyData?["fullName"] ?? "Unknown Agency";
        }

        trips.add(PlannedTripsInfo(
          seats: seats,
          origin: origin,
          destination: destination,
          price: price,
          busType: agencyName,
        ));
      }

      return trips;
    } catch (e) {
      print("Error fetching planned trips: $e");
      return [];
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
                'Planned Trips',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          Expanded(
            child: FutureBuilder<List<PlannedTripsInfo>>(
              future: fetchPlannedTrips(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return const Center(child: Text("Error fetching trips"));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(
                      child: Text("No planned trips available"));
                }

                return ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  itemCount: snapshot.data!.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 16),
                      child: PlannedTripCard(
                        trip: snapshot.data![index],
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
