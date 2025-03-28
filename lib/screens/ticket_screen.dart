import 'package:flutter/material.dart';
import 'package:tourix_app/widgets/bottom_bar.dart';
import 'package:tourix_app/widgets/no_tickets_available.dart';
import '../models/ticket_info.dart';
import '../widgets/ticket_card.dart';

class TicketScreen extends StatelessWidget {
  const TicketScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Sample ticket data
    final List<TicketInfo> tickets = [
      TicketInfo(
        date: '9/11/2025',
        time: '11:00 AM',
        ticketCode: 'AB123',
        origin: 'Rwamagana',
        destination: 'Nyagatare',
        passengers: 2,
        busType: 'Volcano',
      ),
      TicketInfo(
        date: '9/11/2025',
        time: '11:00 AM',
        ticketCode: 'AB123',
        origin: 'Rwamagana',
        destination: 'Nyagatare',
        passengers: 2,
        busType: 'Volcano',
      ),
      TicketInfo(
        date: '9/11/2025',
        time: '11:00 AM',
        ticketCode: 'AB123',
        origin: 'Rwamagana',
        destination: 'Nyagatare',
        passengers: 2,
        busType: 'Volcano',
      ),
      TicketInfo(
        date: '9/11/2025',
        time: '11:00 AM',
        ticketCode: 'AB123',
        origin: 'Rwamagana',
        destination: 'Nyagatare',
        passengers: 2,
        busType: 'Volcano',
      ),
    ];

    return Scaffold(
      // AppBar with Tourix logo and notification icon
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: const Color(0xFF3630A1),
        elevation: 0,
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(5),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(5),
              ),
              child: const Icon(Icons.home, color: Color(0xFF3630A1), size: 20),
              // Later replace with: Image.asset('assets/logo.png', width: 24, height: 24)
            ),
            const SizedBox(width: 8),
            const Text(
              'Tourix',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: 16.0),
            child: Icon(Icons.notifications, color: Colors.white),
          ),
        ],
      ),
      body: Column(
        // spacing: tickets.isEmpty ? 110.0 : 0,
        children: [
          // Header image container with "Upcoming Tickets" text
          Container(
            height: 140,
            width: double.infinity,
            decoration: const BoxDecoration(
              color: Color(0xFF3630A1),
              image: DecorationImage(
                image: NetworkImage(
                    'https://images.unsplash.com/photo-1494515843206-f3117d3f51b7?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=1172&q=80'),
                fit: BoxFit.cover,
                colorFilter: ColorFilter.mode(
                  Colors.black26,
                  BlendMode.darken,
                ),
              ),
            ),
            child: const Center(
              // Use Center widget to center the text
              child: Text(
                'Upcoming Tickets',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),

          tickets.isEmpty
              ? const NoTicketsAvailable()
              : Padding(
                  padding: const EdgeInsets.fromLTRB(24, 16, 24, 16),
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF3630A1),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 32, vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: const Text(
                        'Book Ticket',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                  ),
                ),

          // Ticket List
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              itemCount: tickets.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: TicketCard(ticket: tickets[index]),
                );
              },
            ),
          ),
        ],
      ),
      bottomNavigationBar: const BottomNavigationBarWidget(),
    );
  }
}
