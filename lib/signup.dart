import 'package:flutter/material.dart';
import 'login.dart'; // Ensure this file contains BookingOne

class SignUpPage extends StatelessWidget {
  // Define the custom blue color
  final Color customBlue = Color(0xFF3D2DB6); // Adjusted to match the image

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // Set background to white
      body: Padding(
        padding: EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Logo
            Image.asset(
              'assets/images/Frame2.png',
              width: 100,
              height: 100,
              fit: BoxFit.cover, // Keeps the original image color
            ),
            SizedBox(height: 20),
            Text(
              "Create Account",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.black),
            ),
            SizedBox(height: 20),
            // First Name Input
            TextField(
              decoration: InputDecoration(
                labelText: "First Name",
                border: OutlineInputBorder(),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: customBlue), // Blue border when focused
                ),
              ),
            ),
            SizedBox(height: 10),
            // Last Name Input
            TextField(
              decoration: InputDecoration(
                labelText: "Last Name",
                border: OutlineInputBorder(),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: customBlue), // Blue border when focused
                ),
              ),
            ),
            SizedBox(height: 10),
            // Email Input
            TextField(
              decoration: InputDecoration(
                labelText: "Email",
                border: OutlineInputBorder(),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: customBlue), // Blue border when focused
                ),
              ),
            ),
            SizedBox(height: 10),
            // Password Input
            TextField(
              obscureText: true,
              decoration: InputDecoration(
                labelText: "Password",
                border: OutlineInputBorder(),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: customBlue), // Blue border when focused
                ),
              ),
            ),
            SizedBox(height: 20),
            // Sign Up Button (Navigates to BookingOne)
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => LoginPage()), // Navigate to BookingOne
                );
              },
              child: Text("Create an Account"),
              style: ElevatedButton.styleFrom(
                minimumSize: Size(double.infinity, 50),
                backgroundColor: customBlue, // Correct blue button color
                foregroundColor: Colors.white, // White text color
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8), // Match the rounded button style
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
