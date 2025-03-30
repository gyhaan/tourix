import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:tourix_app/firebase_options.dart';
import 'package:tourix_app/models/bookInfo.dart';
import 'package:tourix_app/screens/booking_info.dart';
import 'package:tourix_app/screens/ticket_details.dart';
import 'package:tourix_app/screens/ticket_seat.dart';
import 'package:tourix_app/widgets/app.dart';
import 'dart:async';
import 'screens/Search.dart';
import 'screens/AgencyBooking.dart';
import 'screens/login.dart';
import 'screens/signup.dart';
// import './Screens/TicketInfo.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Tourix App',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
        navigationBarTheme: NavigationBarThemeData(
          labelTextStyle: MaterialStateProperty.all(
            const TextStyle(color: Colors.white, fontSize: 14),
          ),
          indicatorColor: Colors.white.withOpacity(0.2),
          backgroundColor: const Color(0xFF3630A1),
          labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
        ),
      ),
      debugShowCheckedModeBanner: false,
      home: LoginPage(),
    );
  }
}


// const BookingInfoScreen(
//         bookingInfo: BookingInfo(
//             userName: "Owen",
//             departureTime: "Volcano",
//             fromLocation: "Volcano",
//             toLocation: "Volcano",
//             agencyName: "Volcano",
//             seatsBooked: 2,
//             price: "123"),
//       ),