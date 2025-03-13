import 'package:flutter/material.dart';
import '../components/TopBar.dart';
import '../components/TopImageScreen.dart';

class TicketTopBar extends StatelessWidget implements PreferredSizeWidget {
  final String pageTitle;

  const TicketTopBar({
    super.key,
    required this.pageTitle,
  });

  @override
  Size get preferredSize => Size.fromHeight(120); // Adjust height as needed

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TopBar(),
          TopImageScreen(pageTitle: pageTitle),
        ],
      ),
    );
  }
}