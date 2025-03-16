import 'package:flutter/material.dart';
import 'login.dart'; // Ensure this file contains the correct screens for User and Agency

class SignUpPage extends StatefulWidget {
  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final Color customBlue = Color(0xFF3D2DB6);
  String? selectedRole;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.0),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Logo
                Image.asset(
                  'assets/images/Frame2.png',
                  width: 100,
                  height: 100,
                  fit: BoxFit.cover,
                ),
                SizedBox(height: 20),
                Text(
                  "Create Account",
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                SizedBox(height: 20),
                // Full Name Input
                TextField(
                  decoration: InputDecoration(
                    labelText: "Full Name",
                    border: OutlineInputBorder(),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: customBlue),
                    ),
                  ),
                ),
                SizedBox(height: 10),
                // Role Dropdown
                DropdownButtonFormField<String>(
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: customBlue),
                    ),
                  ),
                  value: selectedRole,
                  hint: Text("Role"),
                  items: ["User", "Agency"].map((role) {
                    return DropdownMenuItem(
                      value: role,
                      child: Text(role),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      selectedRole = value;
                    });
                  },
                ),
                SizedBox(height: 10),
                // Email Input
                TextField(
                  decoration: InputDecoration(
                    labelText: "Email",
                    border: OutlineInputBorder(),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: customBlue),
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
                      borderSide: BorderSide(color: customBlue),
                    ),
                  ),
                ),
                SizedBox(height: 20),
                // Create Account Button
                ElevatedButton(
                  onPressed: () {
                    if (selectedRole == "User") {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => LoginPage()), // Navigate to User screen
                      );
                    } else if (selectedRole == "Agency") {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => LoginPage()), // Navigate to Agency screen
                      );
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text("Please select a role")),
                      );
                    }
                  },
                  child: Text("Create an Account"),
                  style: ElevatedButton.styleFrom(
                    minimumSize: Size(double.infinity, 50),
                    backgroundColor: customBlue,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
