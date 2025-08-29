import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class AnalysisScreen extends StatelessWidget {
  const AnalysisScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final width = size.width;
    final height = size.height;

    return Scaffold(
      backgroundColor: const Color(0xFF0A0A23),
      body: SafeArea(
        child: Column(
          children: [
            // Top bar
            Padding(
              padding: EdgeInsets.symmetric(horizontal: width * 0.05, vertical: height * 0.015),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Back button
                  GestureDetector(
                    onTap: () {
                      Navigator.pop(context); // Back to previous screen (HomeScreen)
                    },
                    child: SvgPicture.asset("assets/icons/Back.svg", width: width * 0.07),
                  ),

                  const Text(
                    "Analysis",
                    style: TextStyle(
                      fontFamily: "RobotoMono",
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),

                  // Hamburger opens menu
                  GestureDetector(
                    onTap: () {
                      Navigator.pushNamed(context, "/menu");
                    },
                    child: SvgPicture.asset("assets/icons/Hamburger.svg", width: width * 0.07),
                  ),
                ],
              ),
            ),

            // White container
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
                padding: EdgeInsets.all(width * 0.05),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "File: example.py",
                      style: TextStyle(
                        fontFamily: "RobotoMono",
                        fontSize: width * 0.045,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    SizedBox(height: height * 0.02),

                    Expanded(
                      child: ListView(
                        children: [
                          _buildAnalysisItem("Long Method", "Function `processData()` is too long"),
                          _buildAnalysisItem("Duplicate Code", "Found in `utils.py` and `main.py`"),
                          _buildAnalysisItem("Large Class", "Class `Manager` has 500+ lines"),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAnalysisItem(String smell, String detail) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            smell,
            style: const TextStyle(
              fontFamily: "RobotoMono",
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            detail,
            style: const TextStyle(
              fontFamily: "RobotoMono",
              color: Colors.black,
            ),
          ),
        ],
      ),
    );
  }
}
