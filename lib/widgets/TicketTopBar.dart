import 'package:flutter/material.dart';
import 'TopBar.dart';
import 'TopImageScreen.dart';

class TicketTopBar extends StatelessWidget {
  final String pageTitle; 

  const TicketTopBar({
    Key? key,
    required this.pageTitle, 
  }) : super(key: key);

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