import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ChgPassword extends StatefulWidget {
  const ChgPassword({super.key});

  @override
  State<ChgPassword> createState() => _ChgPasswordState();
}

class _ChgPasswordState extends State<ChgPassword> {
  final TextEditingController newPasswordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();
  bool isLoading = false;

  void changePassword() async {
    final newPassword = newPasswordController.text.trim();
    final confirmPassword = confirmPasswordController.text.trim();

    if (newPassword != confirmPassword) {
      showDialog(
        context: context,
        builder: (_) => const AlertDialog(
          title: Text("Password Mismatch"),
          content: Text("New password and confirm password must be the same."),
        ),
      );
      return;
    }

    if (newPassword.length < 6) {
      showDialog(
        context: context,
        builder: (_) => const AlertDialog(
          title: Text("Weak Password"),
          content: Text("Password must be at least 6 characters long."),
        ),
      );
      return;
    }

    setState(() => isLoading = true);

    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) throw Exception("User not logged in.");

      await user.updatePassword(newPassword);
      await FirebaseAuth.instance.signOut();

      if (context.mounted) {
        showDialog(
          context: context,
          builder: (_) => AlertDialog(
            title: const Text("Success"),
            content: const Text(
              "Password changed successfully. Please log in again.",
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.popUntil(context, (route) => route.isFirst);
                  Navigator.pushReplacementNamed(context, '/login');
                },
                child: const Text("OK"),
              ),
            ],
          ),
        );
      }
    } catch (e) {
      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: const Text("Error"),
          content: Text(e.toString()),
        ),
      );
    } finally {
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            // Background design (same as before)
            Positioned(
              top: -screenHeight * 0.5,
              right: -screenWidth * 0.2,
              child: CircleAvatar(
                backgroundColor: Colors.blue.shade900,
                radius: screenWidth * 1.0,
              ),
            ),
            Positioned(
              top: screenHeight * 0.05,
              right: -screenWidth * 0.1,
              child: const CircleAvatar(
                backgroundColor: Colors.white,
                radius: 68,
              ),
            ),
            Positioned(
              bottom: -screenHeight * 0.6,
              left: -screenWidth * 0.07,
              child: CircleAvatar(
                backgroundColor: Colors.blue.shade900,
                radius: screenWidth * 1.0,
              ),
            ),
            Positioned(
              bottom: -screenHeight * 0.07,
              left: screenWidth * 0.09,
              child: const CircleAvatar(
                backgroundColor: Colors.white,
                radius: 68,
              ),
            ),

            // Form
            Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: Container(
                  width: 330,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 32,
                    vertical: 30,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.black,
                        blurRadius: 10,
                        offset: Offset(1, 1),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const Text(
                        'Change Password',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      const SizedBox(height: 30),

                      TextField(
                        controller: newPasswordController,
                        obscureText: true,
                        decoration: InputDecoration(
                          prefixIcon: const Icon(Icons.lock),
                          labelText: 'New Password',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),

                      TextField(
                        controller: confirmPasswordController,
                        obscureText: true,
                        decoration: InputDecoration(
                          prefixIcon: const Icon(Icons.lock_outline),
                          labelText: 'Confirm Password',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                      const SizedBox(height: 30),

                      ElevatedButton(
                        onPressed: () async {
                          final newPassword = newPasswordController.text.trim();
                          final confirmPassword = confirmPasswordController.text
                              .trim();

                          if (newPassword.isEmpty || confirmPassword.isEmpty) {
                            showDialog(
                              context: context,
                              builder: (_) => const AlertDialog(
                                title: Text("Error"),
                                content: Text("Please fill out all fields."),
                              ),
                            );
                            return;
                          }

                          if (newPassword != confirmPassword) {
                            showDialog(
                              context: context,
                              builder: (_) => const AlertDialog(
                                title: Text("Mismatch"),
                                content: Text("Passwords do not match."),
                              ),
                            );
                            return;
                          }

                          try {
                            final user = FirebaseAuth.instance.currentUser;
                            await user?.updatePassword(newPassword);

                            showDialog(
                              context: context,
                              builder: (_) => AlertDialog(
                                title: const Text("Success"),
                                content: const Text(
                                  "Password changed successfully.",
                                ),
                                actions: [
                                  TextButton(
                                    onPressed: () {
                                      Navigator.pop(context); // Close dialog
                                      Navigator.pop(context); // Go back to feed
                                    },
                                    child: const Text("OK"),
                                  ),
                                ],
                              ),
                            );
                          } catch (e) {
                            showDialog(
                              context: context,
                              builder: (_) => AlertDialog(
                                title: const Text("Error"),
                                content: Text(
                                  "Failed to change password.\n\n${e.toString()}",
                                ),
                              ),
                            );
                          }
                        },
                        child: const Text(
                          "Change Password",
                        ), // ✅ This was missing
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
