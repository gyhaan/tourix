import 'package:flutter/material.dart';
import '../widgets/TopBar.dart';
import '../widgets/TopImageScreen.dart';
import '../widgets/BottomBar.dart';
import '../widgets/TicketInfoBody.dart';

class TicketInfo extends StatelessWidget {
  final String pageTitle;

  const TicketInfo({
    super.key,
    required this.pageTitle,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const PreferredSize(
        preferredSize: Size.fromHeight(kToolbarHeight),
        child: TopBar(),
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minHeight: constraints.maxHeight,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TopImageScreen(pageTitle: pageTitle),
                  const SizedBox(height: 30.0),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16.0),
                    child: TicketInfobody(
                      name: 'Ian Ganza',
                      departureDate: '28/03/2025',
                      departureTime: '14:00',
                      from: 'Kigali',
                      to: 'Bugex',
                      agency: 'Volcano',
                      seatsBooked: 3,
                      seatName: 'A4',
                      price: '£20',
                      paymentMethod: 'Momo',
                    ),
                  ),
                  const SizedBox(height: 20.0),
                ],
              ),
            ),
          );
        },
      ),
      bottomNavigationBar: BottomBar(),
    );
  }
}
