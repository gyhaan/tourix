import 'package:flutter/material.dart';
import 'package:tourix_app/screens/ticket_screen.dart';

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
