import 'package:flutter/material.dart';

class TopImageScreen extends StatelessWidget {
  final String pageTitle;

  const TopImageScreen({
    Key? key,
    required this.pageTitle, 
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 119,
      child: DecoratedBox(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/Remera.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: Center(
          child: Text(
            pageTitle, 
            style: const TextStyle(fontSize: 24, color: Colors.white),
          ),
        ),
      ),
    );
  }
}
