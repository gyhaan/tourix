import 'package:flutter/material.dart';
import 'dart:async';
import 'screens/login.dart';
import 'screens/signup.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Scaffold(
          body: LoginPage(),
        )
        // routes: {
        //   '/login': (context) => LoginPage(),
        //   '/signup': (context) => SignUpPage(),
        // },
        );
  }
}

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Timer(Duration(seconds: 20), () {
      Navigator.pushReplacementNamed(context, '/login');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand, // Makes the image cover the whole screen
        children: [
          // Background Image (Reduce blurriness)
          Image.asset(
            'assets/images/splash_image.png', // Ensure the image path is correct
            fit: BoxFit.cover, // Use BoxFit.cover to fill the screen
            filterQuality: FilterQuality.high, // Improves image quality
          ),
          // Overlay for better text readability (reduce opacity to improve clarity)
          Container(
            color: Colors.black.withOpacity(0.3), // Reduce overlay opacity
          ),
          // Centered Content
          Align(
            alignment: Alignment(0.0, 0.4), // Moves text downward
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  "TOURIX",
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.white, // Changed to white
                  ),
                ),
                SizedBox(height: 10),
                Text(
                  "You can book your ticket here!",
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.white, // Changed to white
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
