import 'package:flutter/material.dart';
import 'navigation_item.dart';

class BottomNavigationBarWidget extends StatelessWidget {
  const BottomNavigationBarWidget({Key? key}) : super(key: key);

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
          NavigationItem(icon: Icons.home, label: 'Home', isActive: true),
          NavigationItem(
              icon: Icons.bookmark_border, label: 'Bookings', isActive: false),
          NavigationItem(
              icon: Icons.person_outline, label: 'Profile', isActive: false),
          NavigationItem(
              icon: Icons.history, label: 'History', isActive: false),
        ],
      ),
    );
  }
}
