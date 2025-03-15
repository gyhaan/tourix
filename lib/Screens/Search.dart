import 'package:flutter/material.dart';
import '../components/TopBar.dart';
import '../components/BottomBar.dart';
import '../components/Searchbar.dart';
import '../components/TicketOptions.dart';

class Search extends StatelessWidget {
  const Search({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: TopBar(),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        child: Column(
          children: [
            const SizedBox(height: 20.0),
            const Searchbar(),
            SizedBox(height: 35.0,),
            TicketOptions(trip: 'Rwamagana-Nyagatare', agency: 'Volcano'),
            SizedBox(height: 15.0,),
            TicketOptions(trip: 'Rwamagana-Nyagatare', agency: 'Volcano'),
            SizedBox(height: 15.0,),
            TicketOptions(trip: 'Rwamagana-Nyagatare', agency: 'Volcano'),
          ],
        ),
      ),
      bottomNavigationBar: BottomBar(),
    );
  }
}
