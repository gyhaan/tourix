import 'package:flutter/material.dart';

class NavigationItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isActive;

  const NavigationItem({
    super.key,
    required this.icon,
    required this.label,
    required this.isActive,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          icon,
          color: isActive ? Colors.white : Colors.white70,
          size: 24,
        ),
        Text(
          label,
          style: TextStyle(
            color: isActive ? Colors.white : Colors.white70,
            fontSize: 12,
          ),
        ),
      ],
    );
  }
}