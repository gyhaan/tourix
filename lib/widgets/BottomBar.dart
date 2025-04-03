import 'package:flutter/material.dart';
import 'package:tourix_app/screens/booked_trips.dart';
import 'package:tourix_app/screens/profile.dart';
import 'package:tourix_app/screens/planned_trips.dart';
import 'navigation_item.dart';

class BottomBar extends StatelessWidget {
  const BottomBar({super.key});

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
              label: 'Home',
              isActive: true,
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const PlannedTrips()));
              }),
          NavigationItem(
              icon: Icons.history,
              label: 'Bookings',
              isActive: true,
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const BookedTrips()));
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
        ],
      ),
    );
  }
}
