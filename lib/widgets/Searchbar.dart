import 'package:flutter/material.dart';

class Searchbar extends StatefulWidget {
  const Searchbar({super.key});

  @override
  State<Searchbar> createState() => _SearchbarState();
}

class _SearchbarState extends State<Searchbar> {
  final myController = TextEditingController();
  
  // Fixed the ClickCancel function
  void clickCancel() {
    setState(() {
      myController.clear(); // Better way to clear text
    });
  }

  @override
  void dispose() {
    myController.dispose(); // Clean up the controller when the widget is disposed
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        width: 380.0,
        child: TextField(
          controller: myController,
          decoration: InputDecoration(
            hintText: 'Search Ticket',
            hintStyle: const TextStyle(color: Color(0xFF3630A1)),
            suffixIcon: GestureDetector(
              onTap: clickCancel, // Remove the () - pass the function reference
              child: const Icon(Icons.cancel, color: Color(0xFF3630A1), size: 24),
            ),
            prefixIcon: const Icon(Icons.search, color: Color(0xFF3630A1), size: 24),
            border: OutlineInputBorder(
              borderSide: const BorderSide(color: Color(0xFF3630A1), width: 1),
              borderRadius: BorderRadius.circular(4),
            ),
            enabledBorder: OutlineInputBorder(
              borderSide: const BorderSide(color: Color(0xFF3630A1), width: 1),
              borderRadius: BorderRadius.circular(4),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: const BorderSide(color: Color(0xFF3630A1), width: 2),
              borderRadius: BorderRadius.circular(4),
            ),
            contentPadding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
          ),
          cursorColor: const Color(0xFF3630A1),
          style: const TextStyle(color: Color(0xFF3630A1)),
        ),
      ),
    );
  }
}