import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class HistoryScreen extends StatelessWidget {
  const HistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final width = size.width;
    final height = size.height;

    // Example data
    final historyItems = [
      "Java Algorithms",
      "Chat Bot Homepage",
      "Another",
      "Another",
    ];

    return Scaffold(
      backgroundColor: const Color(0xFF0A0A23),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Top bar
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: width * 0.05,
                vertical: height * 0.015,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Back button
                  GestureDetector(
                    onTap: () {
                      Navigator.pushNamedAndRemoveUntil(
                        context,
                        '/home',
                            (route) => false,
                      );
                    },
                    child: const Icon(Icons.arrow_back, color: Colors.white),
                  ),

                  // Title
                  Row(
                    children: [
                      SvgPicture.asset(
                        "assets/icons/history.svg",
                        width: width * 0.06,
                        color: Colors.white,
                      ),
                      const SizedBox(width: 8),
                      const Text(
                        "History",
                        style: TextStyle(
                          fontFamily: "RobotoMono",
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),

                  // Hamburger
                  GestureDetector(
                    onTap: () {
                      Navigator.pushNamed(context, "/menu");
                    },
                    child: const Icon(Icons.menu, color: Colors.white),
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
                    topLeft: Radius.circular(12),
                    topRight: Radius.circular(12),
                  ),
                ),
                padding: EdgeInsets.symmetric(
                  horizontal: width * 0.05,
                  vertical: height * 0.02,
                ),
                child: Column(
                  children: [
                    // History list
                    Expanded(
                      child: ListView.builder(
                        itemCount: historyItems.length,
                        itemBuilder: (context, index) {
                          return Container(
                            margin: EdgeInsets.only(bottom: height * 0.02),
                            padding: EdgeInsets.all(width * 0.04),
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: Colors.black,
                                width: 1,
                              ),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // File name
                                Text(
                                  historyItems[index],
                                  style: const TextStyle(
                                    fontFamily: "RobotoMono",
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.black,
                                  ),
                                ),
                                const SizedBox(height: 8),

                                // Actions row
                                Row(
                                  children: [
                                    // View
                                    GestureDetector(
                                      onTap: () {
                                        Navigator.pushNamed(
                                            context, "/analysis");
                                      },
                                      child: const Text(
                                        "View >",
                                        style: TextStyle(
                                          fontFamily: "RobotoMono",
                                          fontSize: 14,
                                          color: Colors.black,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 20),

                                    // Rename
                                    GestureDetector(
                                      onTap: () {
                                        // TODO: implement rename functionality
                                      },
                                      child: Row(
                                        children: [
                                          const Text(
                                            "Rename",
                                            style: TextStyle(
                                              fontFamily: "RobotoMono",
                                              fontSize: 14,
                                              color: Colors.black,
                                            ),
                                          ),
                                          const SizedBox(width: 4),
                                          SvgPicture.asset(
                                            "assets/icons/rename.svg",
                                            width: 16,
                                            height: 16,
                                          ),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(width: 20),

                                    // Delete
                                    GestureDetector(
                                      onTap: () {
                                        // TODO: implement delete functionality
                                      },
                                      child: Row(
                                        children: [
                                          const Text(
                                            "Delete",
                                            style: TextStyle(
                                              fontFamily: "RobotoMono",
                                              fontSize: 14,
                                              color: Colors.black,
                                            ),
                                          ),
                                          const SizedBox(width: 4),
                                          SvgPicture.asset(
                                            "assets/icons/delete.svg",
                                            width: 16,
                                            height: 16,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ),

                    // Pagination
                    Column(
                      children: [
                        const Text(
                          "Page 1 of 14",
                          style: TextStyle(
                            fontFamily: "RobotoMono",
                            fontSize: 14,
                            color: Colors.black,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            _pageButton("<<"),
                            const SizedBox(width: 4),
                            _pageButton("<"),
                            const SizedBox(width: 4),
                            _pageButton(">"),
                            const SizedBox(width: 4),
                            _pageButton(">>"),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _pageButton(String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.black, width: 1),
      ),
      child: Text(
        label,
        style: const TextStyle(
          fontFamily: "RobotoMono",
          fontSize: 14,
          color: Colors.black,
        ),
      ),
    );
  }
}
