import 'package:flutter/material.dart';
import 'dart:async';
import './TicketInfo.dart'; // Import your home screen

class Splash extends StatefulWidget {
  const Splash({super.key});

  @override
  State<Splash> createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  @override
  void initState() {
    super.initState();
    // Shorter duration since we already have native splash
    Timer(const Duration(milliseconds: 500), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => const TicketInfoBar(pageTitle: 'TicketInfo',), // Replace with your home screen
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Color(0xFF3630A1), 
      body: Center(
        child: Image(
          image: AssetImage('assets/logo.png'),
          width: 150, 
          height: 150, 
        ),
      ),
    );
  }
}