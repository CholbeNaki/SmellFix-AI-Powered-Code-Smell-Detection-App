import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: const Color(0xFF0A0A23),
      body: SingleChildScrollView(
        child: SizedBox(
          height: screenHeight,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.06),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SizedBox(height: screenHeight * 0.13),

                // Optional: Logo on top
                SvgPicture.asset(
                  "assets/icons/icon.svg",
                  width: screenWidth * 0.5,
                  height: screenWidth * 0.5,
                ),

                SizedBox(height: screenHeight * 0.08),

                // Email Input
                TextField(
                  style: const TextStyle(
                    fontFamily: "RobotoMono",
                    color: Colors.white,
                  ),
                  decoration: InputDecoration(
                    hintText: "What do we call you? [username]",
                    hintStyle: const TextStyle(
                      fontFamily: "RobotoMono",
                      color: Colors.white54,
                    ),
                    filled: true,
                    fillColor: const Color(0xFF1A1A40),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5),
                      borderSide: BorderSide.none,
                    ),
                    contentPadding: EdgeInsets.symmetric(
                        vertical: screenHeight * 0.02,
                        horizontal: screenWidth * 0.04),
                  ),
                ),

                SizedBox(height: screenHeight * 0.025),

                // Password Input
                TextField(
                  obscureText: true,
                  style: const TextStyle(
                    fontFamily: "RobotoMono",
                    color: Colors.white,
                  ),
                  decoration: InputDecoration(
                    hintText: "Password",
                    hintStyle: const TextStyle(
                      fontFamily: "RobotoMono",
                      color: Colors.white54,
                    ),
                    filled: true,
                    fillColor: const Color(0xFF1A1A40),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5),
                      borderSide: BorderSide.none,
                    ),
                    contentPadding: EdgeInsets.symmetric(
                        vertical: screenHeight * 0.02,
                        horizontal: screenWidth * 0.04),
                  ),
                ),

                SizedBox(height: screenHeight * 0.05),

                // Login Button
                SizedBox(
                  width: double.infinity,
                  height: screenHeight * 0.065,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF0A0A23),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5),
                      ),
                    ),
                    onPressed: () {
                      // Add login logic
                    },
                    child: Text(
                      "Login",
                      style: TextStyle(
                        fontFamily: "RobotoMono",
                        fontSize: screenHeight * 0.022,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),

                SizedBox(height: screenHeight * 0.02),

                // SignUp Button (outlined)
                SizedBox(
                  width: double.infinity,
                  height: screenHeight * 0.065,
                  child: OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: Colors.white, width: 2),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5),
                      ),
                    ),
                    onPressed: () {
                      Navigator.pushNamed(context, "/signup");
                    },
                    child: Text(
                      "Sign Up",
                      style: TextStyle(
                        fontFamily: "RobotoMono",
                        fontSize: screenHeight * 0.022,
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
      ),
    );
  }
}
