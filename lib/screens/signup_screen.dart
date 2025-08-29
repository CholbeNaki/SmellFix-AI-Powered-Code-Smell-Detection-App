import 'package:flutter/material.dart';

class SignUpScreen extends StatelessWidget {
  const SignUpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A0A23),
      body: Column(
        children: [
          const SizedBox(height: 60),

          // Profile Upload Placeholder
          CircleAvatar(
            radius: 60,
            backgroundColor: Colors.grey.shade300,
            child: const Text("Upload Photo", style: TextStyle(color: Colors.black)),
          ),
          const SizedBox(height: 20),

          Expanded(
            child: Container(
              width: double.infinity,
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(10),
                  topRight: Radius.circular(10),
                ),
              ),
              padding: const EdgeInsets.all(24),
              child: Column(
                children: [
                  _buildTextField("Your Name?"),
                  const SizedBox(height: 16),
                  _buildTextField("What will we call you? [username]"),
                  const SizedBox(height: 16),
                  _buildTextField("Password?", isPassword: true),
                  const SizedBox(height: 16),
                  _buildTextField("Date of Birth"),
                  const SizedBox(height: 16),
                  _buildTextField("What Do You Do Exactly?"),

                  const SizedBox(height: 32),
                  SizedBox(
                    width: double.infinity,
                    height: 48,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF0A0A23),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5),
                        ),
                      ),
                      onPressed: () {
                        Navigator.pushReplacementNamed(context, "/home"); // later add home
                      },
                      child: const Text(
                        "Confirm",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField(String hint, {bool isPassword = false}) {
    return TextField(
      obscureText: isPassword,
      decoration: InputDecoration(
        hintText: hint,
        filled: true,
        fillColor: const Color(0xFFEAEAEA),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(5),
          borderSide: BorderSide.none,
        ),
        suffixIcon: isPassword ? const Icon(Icons.visibility_outlined) : null,
      ),
    );
  }
}
