import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tourix_app/screens/planned_trips.dart';
import 'package:tourix_app/screens/ticket_screen.dart';
// Ensure this exists

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final Color customBlue = const Color(0xFF3D2DB6);

  // Controllers for input fields
  final TextEditingController fullNameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  String? selectedRole;
  bool isLoading = false; // ✅ State for showing loading indicator

  void signUpUsers() async {
    if (selectedRole == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please select a role")),
      );
      return;
    }

    setState(() {
      isLoading = true; // ✅ Show loading
    });

    try {
      // 1️⃣ Create user in Firebase Authentication
      UserCredential userCredential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );

      // 2️⃣ Get the newly created user ID
      String uid = userCredential.user!.uid;

      // 3️⃣ Store additional user details in Firestore
      await FirebaseFirestore.instance.collection("users").doc(uid).set({
        "name": fullNameController.text.trim(),
        "role": selectedRole!.toLowerCase(),
        "email": emailController.text.trim(),
        "createdAt": Timestamp.now(),
      });

      // ✅ Show success message
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Account created successfully!")),
      );

      // 4️⃣ Navigate based on role
      if (selectedRole == "User") {
        // Pass the user ID to TicketScreen
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => const TicketScreen(), // Pass the UID here
          ),
        );
      } else if (selectedRole == "Agency") {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const PlannedTrips()),
        );
      }
    } catch (e) {
      print("❌ Error: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: ${e.toString()}")),
      );
    } finally {
      setState(() {
        isLoading = false; // ✅ Hide loading
      });
    }
  }

  @override
  void dispose() {
    fullNameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Image.asset(
                  'assets/images/Frame2.png',
                  width: 100,
                  height: 100,
                  fit: BoxFit.cover,
                ),
                const SizedBox(height: 20),
                const Text(
                  "Create Account",
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 20),
                // Full Name Input
                TextField(
                  controller: fullNameController,
                  decoration: InputDecoration(
                    labelText: "Full Name",
                    border: const OutlineInputBorder(),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: customBlue),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                // Role Dropdown
                DropdownButtonFormField<String>(
                  decoration: InputDecoration(
                    border: const OutlineInputBorder(),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: customBlue),
                    ),
                  ),
                  value: selectedRole,
                  hint: const Text("Select Role"),
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
                const SizedBox(height: 10),
                // Email Input
                TextField(
                  controller: emailController,
                  decoration: InputDecoration(
                    labelText: "Email",
                    border: const OutlineInputBorder(),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: customBlue),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                // Password Input
                TextField(
                  controller: passwordController,
                  obscureText: true,
                  decoration: InputDecoration(
                    labelText: "Password",
                    border: const OutlineInputBorder(),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: customBlue),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                // Create Account Button
                ElevatedButton(
                  onPressed: isLoading
                      ? null
                      : signUpUsers, // ✅ Disable button when loading
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size(double.infinity, 50),
                    backgroundColor: customBlue,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: isLoading
                      ? const CircularProgressIndicator(
                          color: Colors.white) // ✅ Show loading
                      : const Text("Create an Account"),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
