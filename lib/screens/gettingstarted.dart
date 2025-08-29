import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class GettingStartedScreen extends StatelessWidget {
  const GettingStartedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: const Color(0xFF0A0A23),
      body: SingleChildScrollView(
        child: SizedBox(
          height: screenHeight, // ensures it fills the screen height
          child: Column(
            children: [
              SizedBox(height: screenHeight * 0.08),

              // Logo
          SvgPicture.asset(
            "assets/icons/icon.svg",
            width: screenWidth * 0.5,
            height: screenWidth * 0.5,

              ),


              SizedBox(height: screenHeight * 0.01),

              // Subtitle
              Text(
                "Your code smell detection agent",
                style: TextStyle(
                  fontFamily: "RobotoMono",
                  fontSize: screenHeight * 0.018,
                  color: Colors.white,
                ),
              ),

              SizedBox(height: screenHeight * 0.05),

              // White rounded container
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
                  padding: EdgeInsets.symmetric(
                    horizontal: screenWidth * 0.06,
                    vertical: screenHeight * 0.04,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        "Getting Started",
                        style: TextStyle(
                          fontFamily: "RobotoMono",
                          fontSize: screenHeight * 0.03,
                          fontWeight: FontWeight.bold,
                          color: const Color(0xFF0A0A23),
                        ),
                      ),

                      SizedBox(height: screenHeight * 0.05),

                      // SignUp Button
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
                            Navigator.pushNamed(context, "/signup");
                          },
                          child: Text(
                            "SignUp",
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

                      // Login Button (outlined)
                      SizedBox(
                        width: double.infinity,
                        height: screenHeight * 0.065,
                        child: OutlinedButton(
                          style: OutlinedButton.styleFrom(
                            side: const BorderSide(
                                color: Color(0xFF0A0A23), width: 2),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5),
                            ),
                          ),
                          onPressed: () {
                            Navigator.pushNamed(context, "/login");
                          },
                          child: Text(
                            "Login",
                            style: TextStyle(
                              fontFamily: "RobotoMono",
                              fontSize: screenHeight * 0.022,
                              fontWeight: FontWeight.bold,
                              color: const Color(0xFF0A0A23),
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
        ),
      ),
    );
  }
}
