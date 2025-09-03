import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_apps/services/api_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:logger/logger.dart';

var logger = Logger();

class AnalysisScreen extends StatefulWidget {
  const AnalysisScreen({super.key});

  @override
  _AnalysisScreenState createState() => _AnalysisScreenState();
}

class _AnalysisScreenState extends State<AnalysisScreen> {
  List<Map<String, dynamic>> analysisData = []; //store the analysis issues
  bool isLoading = true;
  String fileName = '';
  late String historyId; // To store historyId passed from HomeScreen

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    final arguments = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>;
    if (arguments.containsKey('historyId')) {
      historyId = arguments['historyId'];
      _fetchAnalysisData();
    } else {
      // if historyId is missing
      logger.e('No historyId found in arguments!');
      setState(() {
        isLoading = false;
      });
    }
  }
  // Backend
  Future<void> _fetchAnalysisData() async {
    try {
      String? token = await _getToken();
      if (token == null) {
        throw Exception('No token found');
      }

      var response = await ApiService().getAnalysisResults(token, historyId);
      logger.e("issues: $response[issues]");

      if (response['issues'] != null) {
        setState(() {
          analysisData = List<Map<String, dynamic>>.from(response['issues']);
          fileName = response['filename']; // Save filename from the response
          isLoading = false; // Set loading to false once data is fetched
        });
      } else {
        setState(() {
          analysisData = [];
          isLoading = false;
        });
      }
    } catch (e) {
      // Handle errors
      setState(() {
        isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Failed to load analysis data1: $e"),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<String?> _getToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
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
                      Navigator.pop(context);
                    },
                    child: SvgPicture.asset("assets/icons/Back.svg", height: 24),
                  ),
                  const Text(
                    "Analysis",
                    style: TextStyle(
                      fontFamily: "RobotoMono",
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
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
                      fileName.isEmpty ? "Loading..." : fileName,
                      style: TextStyle(
                        fontFamily: "RobotoMono",
                        fontSize: width * 0.045,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    SizedBox(height: height * 0.02),

                    // If still loading, show a progress indicator
                    if (isLoading)
                      const Center(child: CircularProgressIndicator()),

                    // If no issues, display "No issues found"
                    if (!isLoading && analysisData.isEmpty)
                      const Center(
                        child: Text(
                          "No issues found",
                          style: TextStyle(
                            fontFamily: "RobotoMono",
                            fontSize: 18,
                            color: Colors.black,
                          ),
                        ),
                      ),

                    // List of issues if data is available
                    if (!isLoading && analysisData.isNotEmpty)
                      Expanded(
                        child: ListView.builder(
                          itemCount: analysisData.length,
                          itemBuilder: (context, index) {
                            var issue = analysisData[index];
                            return _buildAnalysisItem(issue['type'], issue['message'], issue['suggestion']);
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

  Widget _buildAnalysisItem(String type, String message, String suggestion) {
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
            type,
            style: const TextStyle(
              fontFamily: "RobotoMono",
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            message,
            style: const TextStyle(
              fontFamily: "RobotoMono",
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            "Suggestion: $suggestion",
            style: const TextStyle(
              fontFamily: "RobotoMono",
              fontStyle: FontStyle.italic,
              color: Colors.black87,
            ),
          ),
        ],
      ),
    );
  }
}
