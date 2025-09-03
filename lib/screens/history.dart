import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_apps/services/api_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:logger/logger.dart';

var logger = Logger();

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  _HistoryScreenState createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  List<Map<String, dynamic>> historyItems = [];

  @override
  void initState() {
    super.initState();
    _getHistory();
  }

  //Backend
  Future<void> _getHistory() async {
    try {
      String? token = await _getToken();
      if (token == null) throw Exception('No token found');

      var response = await ApiService().getHistory(token);

      setState(() {
        historyItems = List<Map<String, dynamic>>.from(response);
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Failed to load history: $e"),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> _deleteHistory(String historyId) async {
    try {
      String? token = await _getToken();
      if (token == null) throw Exception('No token found');

      await ApiService().deleteHistory(token, historyId);

      setState(() {
        historyItems.removeWhere((item) => item['_id'] == historyId);
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("History item deleted successfully"),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to delete item: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> _renameHistory(String historyId, String newFileName) async {
    try {
      String? token = await _getToken();
      if (token == null) throw Exception('No token found');

      await ApiService().renameHistory(token, historyId, newFileName);

      setState(() {
        int index = historyItems.indexWhere((item) => item['_id'] == historyId);
        if (index != -1) {
          historyItems[index]['fileName'] = newFileName;
        }
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('History item renamed'),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to rename item: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void _getHistoryItem(String historyId) {
    Navigator.pushNamed(context, '/historyview', arguments: {'historyId': historyId});
  }

  Future<String?> _getToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }

  // Function to show rename dialog
  Future<void> _showRenameDialog(String historyId, String currentName) async {
    TextEditingController _controller = TextEditingController(text: currentName);

    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Rename History Item'),
          content: TextField(
            controller: _controller,
            decoration: const InputDecoration(
              labelText: 'New File Name',
              border: OutlineInputBorder(),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                String newName = _controller.text.trim();
                if (newName.isNotEmpty) {
                  _renameHistory(historyId, newName);
                }
                Navigator.pop(context);
              },
              child: const Text('Rename'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final width = size.width;
    final height = size.height;

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
                      Navigator.pushNamedAndRemoveUntil(context, '/home', (route) => false);
                    },
                    child: SvgPicture.asset("assets/icons/Back.svg", height: 24),
                  ),

                  // Title
                  Row(
                    children: [
                      SvgPicture.asset("assets/icons/history.svg", width: width * 0.06),
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
                    child: SvgPicture.asset("assets/icons/Hamburger.svg", height: 24),
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
                          final item = historyItems[index];
                          return Container(
                            margin: EdgeInsets.only(bottom: height * 0.02),
                            padding: EdgeInsets.all(width * 0.04),
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.black, width: 1),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // File name
                                Text(
                                  item['fileName'] ?? 'Unnamed',
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
                                      onTap: () => _getHistoryItem(item['_id']),
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
                                      onTap: () => _showRenameDialog(item['_id'], item['fileName'] ?? 'Unnamed'),
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
                                      onTap: () => _deleteHistory(item['_id']),
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
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
