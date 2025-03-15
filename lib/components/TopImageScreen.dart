import 'package:flutter/material.dart';

class TopImageScreen extends StatelessWidget {
  final String pageTitle;

  const TopImageScreen({
    super.key,
    required this.pageTitle, 
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 119,
      width: double.infinity,
      child: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/Remera.png'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Color(0xFF3630A1).withOpacity(0.3),  // Light purple at top
                  Color(0xFF3630A1).withOpacity(0.3),  // Darker purple at bottom
                ],
              ),
            ),
          ),
          Center(
            child: Text(
              pageTitle, 
              style: const TextStyle(
                fontSize: 24,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}