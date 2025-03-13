import 'package:flutter/material.dart';
import '../components/TopBar.dart';
import '../components/BottomBar.dart';
import '../components/Searchbar.dart';

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
            const SizedBox(height: 20.0),  // Moved inside children list
            const Searchbar(),
            Expanded(
              child: Container(),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomBar(),
    );
  }
}