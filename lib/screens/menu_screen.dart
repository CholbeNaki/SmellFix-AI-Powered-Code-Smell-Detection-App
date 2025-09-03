import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MenuScreen extends StatelessWidget {
  const MenuScreen({super.key});

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
            // Top close button
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: width * 0.05,
                vertical: height * 0.02,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: const Icon(Icons.close, color: Colors.white, size: 40),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // Logo + App name
            Column(
              children: [
                SvgPicture.asset(
                  "assets/icons/icon.svg",
                  width: width * 0.5,
                ),
              ],
            ),

            const SizedBox(height: 50),

            // Menu items
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  _buildMenuItem(
                    "Account Settings",
                    "assets/icons/accsettings.svg",
                    onTap: () {
                      Navigator.pushNamed(context, "/accountSettings");
                    },
                  ),
                  _buildMenuItem(
                    "History",
                    "assets/icons/history.svg",
                    onTap: () {
                      Navigator.pushNamed(context, "/history");
                    },
                  ),

                  const SizedBox(height: 30),

                  // Dark mode toggle (not implemented)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        "Dark Mode",
                        style: TextStyle(
                          fontFamily: "RobotoMono",
                          fontSize: 18,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Switch(
                        value: true,
                        onChanged: (val) {
                          // TODO: handle dark mode toggle
                        },
                        activeColor: Colors.white,
                        inactiveThumbColor: Colors.grey,
                      ),
                    ],
                  ),

                  const SizedBox(height: 30),

                  // Sign out
                  _buildMenuItem(
                    "Sign Out",
                    "assets/icons/sign_out_icon.svg",
                    onTap: () {
                      signOut(context);
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuItem(String title, String iconPath, {VoidCallback? onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 25),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgPicture.asset(
              iconPath,
              width: 26,
              height: 26,
            ),
            const SizedBox(width: 14),
            Text(
              title,
              style: const TextStyle(
                fontFamily: "RobotoMono",
                fontSize: 18,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }


  void signOut(BuildContext context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('token');
    Navigator.pushReplacementNamed(context, '/login');
  }
}
