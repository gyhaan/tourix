import 'package:flutter/material.dart';
import './components/BottomBar.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return  MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        navigationBarTheme: NavigationBarThemeData(
          labelTextStyle: MaterialStateProperty.all(
            const TextStyle(color: Colors.white, fontSize: 14),
          ),
          indicatorColor: Colors.white.withOpacity(0.2),
          backgroundColor: const Color(0xFF3630A1),
          labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
        ),
      ),
      home: HomeScreen(),
    );
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF3630A1),
        elevation: 0,
        title: Row(
          children: [
            Image.asset('assets/images/Frame.png',
                height: 24, width: 24),
            const SizedBox(width: 8),
            const Text(
              'Tourix',
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
      body: const Center(child: Text("Home Screen")),
      bottomNavigationBar: const BottomBar(),
    );
  }
}