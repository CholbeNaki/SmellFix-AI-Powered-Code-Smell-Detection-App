import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_apps/services/api_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool _isPasswordVisible = false;

  void _login() async {
    if (_usernameController.text.isEmpty || _passwordController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Please fill in both fields'),
        backgroundColor: Colors.red,
      ));
      return;
    }
    try {
      var response = await ApiService().login(
        _usernameController.text,
        _passwordController.text,
      );

      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('token', response['token']);

      Navigator.pushReplacementNamed(context, '/home');
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Login failed: $e'),
        backgroundColor: Colors.red,
      ));
    }
  }

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

                SvgPicture.asset(
                  "assets/icons/icon.svg",
                  width: screenWidth * 0.5,
                  height: screenWidth * 0.5,
                ),

                SizedBox(height: screenHeight * 0.08),

                // Username Input
                TextField(
                  controller: _usernameController,
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

                // Password Input with Show/Hide functionality
                TextField(
                  controller: _passwordController,
                  obscureText: !_isPasswordVisible, // Toggle password visibility
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
                    suffixIcon: IconButton(
                      icon: Icon(
                        _isPasswordVisible
                            ? Icons.visibility_off_outlined
                            : Icons.visibility_outlined,
                        color: Colors.white,
                      ),
                      onPressed: () {
                        setState(() {
                          _isPasswordVisible = !_isPasswordVisible; // Toggle the password visibility
                        });
                      },
                    ),
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
                    onPressed: _login,
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

                // SignUp Button
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
