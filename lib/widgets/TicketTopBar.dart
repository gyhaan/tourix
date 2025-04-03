import 'package:flutter/material.dart';
import 'TopBar.dart';
import 'TopImageScreen.dart';

class TicketTopBar extends StatelessWidget {
  final String pageTitle; 

  const TicketTopBar({
    super.key,
    required this.pageTitle, 
  });

   @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const TopBar(),
        TopImageScreen(pageTitle: pageTitle), 
      ],
    );
  }
}