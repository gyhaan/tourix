import 'package:flutter/material.dart';
import 'signup.dart'; // Ensure this file exists

class LoginPage extends StatelessWidget {
  // Define a custom blue color matching the one in the image
  final Color customBlue =
      const Color(0xFF3D2DB6); // Adjust this color to match exactly

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // Set background to white
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset(
              'assets/images/Frame2.png',
              width: 100,
              height: 100,
              fit: BoxFit.cover, // Keep original image color
            ),
            const SizedBox(height: 20),
            const Text(
              "Welcome Back",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.black, // Black text for title
              ),
            ),
            const SizedBox(height: 20),
            TextField(
              decoration: InputDecoration(
                labelText: "Email",
                border: const OutlineInputBorder(),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: customBlue), // Blue border
                ),
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              obscureText: true,
              decoration: InputDecoration(
                labelText: "Password",
                border: const OutlineInputBorder(),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: customBlue), // Blue border
                ),
              ),
            ),
            const SizedBox(height: 10),
            Align(
              alignment: Alignment.centerRight,
              child: GestureDetector(
                onTap: () {
                  // Navigate to Forgot Password Page
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const SignUpPage()),
                  );
                },
                child: Text(
                  "Forgot Password?",
                  style:
                      TextStyle(color: customBlue, fontWeight: FontWeight.w500),
                ),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Navigate to BookingOne after login
                // Navigator.push(
                //   context,
                //   MaterialPageRoute(builder: (context) => BookingOne()),
                // );
              },
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 50),
                backgroundColor: customBlue, // Button color
                foregroundColor: Colors.white, // Text color
                shape: RoundedRectangleBorder(
                  borderRadius:
                      BorderRadius.circular(8), // Match the rounded style
                ),
              ),
              child: const Text("Login"),
            ),
            const SizedBox(height: 20),
            GestureDetector(
              onTap: () {
                // Navigate to SignUpPage
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const SignUpPage()),
                );
              },
              child: Text.rich(
                TextSpan(
                  text: "Don’t have an account? ",
                  style: const TextStyle(
                      color: Colors.black87), // Regular text color
                  children: [
                    TextSpan(
                      text: "Sign Up",
                      style: TextStyle(
                        color: customBlue, // Light blue clickable text
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
