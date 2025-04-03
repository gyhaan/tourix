import 'package:flutter/material.dart';
import 'package:tourix_app/screens/previous_ticket_screen.dart';
import 'package:tourix_app/screens/profile.dart';
import 'package:tourix_app/screens/ticket_screen.dart';
import 'navigation_item.dart';

class BottomNavigationBarWidget extends StatelessWidget {
  const BottomNavigationBarWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60,
      decoration: const BoxDecoration(
        color: Color(0xFF3630A1),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 5,
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          NavigationItem(
              icon: Icons.bookmark_border,
              label: 'Bookings',
              isActive: true,
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const TicketScreen()));
              }),
          NavigationItem(
              icon: Icons.person_outline,
              label: 'Profile',
              isActive: true,
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const ProfilePage()));
              }),
          NavigationItem(
              icon: Icons.history,
              label: 'History',
              isActive: true,
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const PreviousTicketScreen()));
              }),
        ],
      ),
    );
  }
}
