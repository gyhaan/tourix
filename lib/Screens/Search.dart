import 'package:flutter/material.dart';
import '../components/TopBar.dart';
import '../components/BottomBar.dart';
import '../components/Searchbar.dart';
import '../components/TicketOptions.dart';

class Search extends StatefulWidget {
  const Search({super.key});

  @override
  _SearchState createState() => _SearchState();
}

class _SearchState extends State<Search> {
  final TextEditingController _searchController = TextEditingController();
  List<Map<String, String>> trips = [
    {'trip': 'Rwamagana-Nyagatare', 'agency': 'Volcano'},
    {'trip': 'Kigali-Rwamagana', 'agency': 'Kigali Bus'},
    {'trip': 'Nyagatare-Kigali', 'agency': 'Nyagatare Express'},
    {'trip': 'Musanze-Kigali', 'agency': 'Musanze Travels'},
    // Add more trips as needed
  ];

  List<Map<String, String>> filteredTrips = [];

  @override
  void initState() {
    super.initState();
    filteredTrips = trips; // Initially show all trips
  }

  void _filterTrips(String query) {
    if (query.isEmpty) {
      setState(() {
        filteredTrips = trips; // Show all trips if query is empty
      });
    } else {
      setState(() {
        filteredTrips = trips.where((trip) {
          return trip['trip']!.toLowerCase().contains(query.toLowerCase());
        }).toList();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: TopBar(),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        child: Column(
          children: [
            const SizedBox(height: 20.0),
            TextField(
              controller: _searchController,
              onChanged: _filterTrips,
              decoration: InputDecoration(
                labelText: 'Search Trips',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.search),
              ),
            ),
            const SizedBox(height: 35.0),
            Expanded(
              child: ListView.builder(
                itemCount: filteredTrips.length,
                itemBuilder: (context, index) {
                  return Column(
                    children: [
                      TicketOptions(
                        trip: filteredTrips[index]['trip']!,
                        agency: filteredTrips[index]['agency']!,
                      ),
                      const SizedBox(height: 15.0), // Add space between containers
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomBar(),
    );
  }
}