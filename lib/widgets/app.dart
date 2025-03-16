import 'screens/ticket_screen.dart';
import 'package:flutter/material.dart';

class TicketApp extends StatelessWidget {
  const TicketApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: const Color(0xFF3630A1),
        colorScheme: ColorScheme.fromSwatch().copyWith(
          primary: const Color(0xFF3630A1),
        ),
        fontFamily: "Inter",
      ),
      home: const TicketScreen(),
    );
  }
}
