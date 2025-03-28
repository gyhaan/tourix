import 'package:flutter/material.dart';
import 'dart:async';
import 'AgencyBooking.dart'; // Import your home screen

class Splash extends StatefulWidget {
  const Splash({super.key});

  @override
  State<Splash> createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  @override
  void initState() {
    super.initState();
    Timer(const Duration(milliseconds: 4000), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => const Booking(),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF3630A1),
      body: Center(
        child: Image(
          image: AssetImage('assets/images/logo.png'),
          width: 150,
          height: 150,
        ),
      ),
    );
  }
}
