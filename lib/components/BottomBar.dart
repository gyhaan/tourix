import 'package:flutter/material.dart';

class BottomBar extends StatelessWidget {
  const BottomBar({super.key});

  @override
  Widget build(BuildContext context) {
    return NavigationBar(
      destinations: const <Widget>[
        NavigationDestination(
          icon: Icon(Icons.home, color: Colors.white),
          label: 'Home',
          selectedIcon: Icon(Icons.home_filled, color: Colors.white),
        ),
        NavigationDestination(
          icon: Icon(Icons.book_online_outlined, color: Colors.white),
          label: 'Bookings',
          selectedIcon: Icon(Icons.book_online, color: Colors.white),
        ),
        NavigationDestination(
          icon: Icon(Icons.person_outline, color: Colors.white),
          label: 'Profile',
          selectedIcon: Icon(Icons.person, color: Colors.white),
        ),
        NavigationDestination(
          icon: Icon(Icons.history_outlined, color: Colors.white),
          label: 'History',
          selectedIcon: Icon(Icons.history, color: Colors.white),
        ),
      ],
    );
  }
}