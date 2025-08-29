import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String selectedMode = 'Static';
  final TextEditingController _chatController = TextEditingController();
  String? selectedFileName;
  bool fileSelected = false;
  bool isTextEntered = false;

  @override
  void initState() {
    super.initState();
    _chatController.addListener(() {
      setState(() {
        isTextEntered = _chatController.text.trim().isNotEmpty;
      });
    });
  }

  Future<void> pickFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['py', 'java'],
    );

    if (result != null && result.files.isNotEmpty) {
      setState(() {
        selectedFileName = result.files.single.name;
        fileSelected = true;
      });
    }
  }

  void onAnalyzePressed() {
    String inputText = _chatController.text.trim();

    if (inputText.isEmpty && selectedFileName == null) {
      return;
    }

    // Navigate to Analysis Screen instead of just printing
    Navigator.pushNamed(context, "/analysis", arguments: {
      'input': inputText.isNotEmpty ? inputText : selectedFileName,
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: const Color(0xFF0A0A23),
      body: SafeArea(
        child: Column(
          children: [
            // Top bar
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SvgPicture.asset('assets/icons/top_left_logo.svg', height: 24),
                  GestureDetector(
                    onTap: () {
                      Navigator.pushNamed(context, "/menu"); // Hamburger opens Menu
                    },
                    child: SvgPicture.asset('assets/icons/Hamburger.svg', height: 24),
                  ),
                ],
              ),
            ),

            // White container
            Expanded(
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(10),
                    topRight: Radius.circular(10),
                  ),
                ),
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      // Avatar and info
                      Column(
                        children: [
                          CircleAvatar(
                            radius: 80,
                            backgroundImage: AssetImage('assets/images/avatar.png'),
                          ),
                          const SizedBox(height: 10),
                          const Text(
                            'Joeylene Rivera',
                            style: TextStyle(
                              fontFamily: 'RobotoMono',
                              fontWeight: FontWeight.bold,
                              fontSize: 29,
                              color: Color(0xFF0A0A23),
                            ),
                          ),
                          const SizedBox(height: 2),
                          const Text(
                            '@jorenrui',
                            style: TextStyle(
                                fontFamily: 'RobotoMono',
                                fontSize: 18,
                                color: Color(0xFF0A0A23)
                            ),
                          ),
                          const SizedBox(height: 2),
                          const Text(
                            'Web Developer who has\na thing for design',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontFamily: 'RobotoMono',
                                fontSize: 18,
                                color: Color(0xFF0A0A23)
                            ),
                          ),
                          const SizedBox(height: 20),
                        ],
                      ),

                      // Mode toggle
                      Row(
                        children: [
                          Expanded(
                            child: ElevatedButton(
                              onPressed: () => setState(() => selectedMode = 'Static'),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: selectedMode == 'Static'
                                    ? const Color(0xFF0A0A23)
                                    : Colors.white,
                                foregroundColor: selectedMode == 'Static'
                                    ? Colors.white
                                    : const Color(0xFF0A0A23),
                                side: const BorderSide(color: Color(0xFF0A0A23)),
                                padding: const EdgeInsets.symmetric(vertical: 12),
                                shape: const RoundedRectangleBorder(
                                  borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(4),
                                    bottomLeft: Radius.circular(4),
                                  ),
                                ),
                              ),
                              child: const Text(
                                'Static Mode',
                                style: TextStyle(
                                  fontFamily: 'RobotoMono',
                                  fontSize: 18,
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            child: ElevatedButton(
                              onPressed: () => setState(() => selectedMode = 'Suggestion'),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: selectedMode == 'Suggestion'
                                    ? const Color(0xFF0A0A23)
                                    : Colors.white,
                                foregroundColor: selectedMode == 'Suggestion'
                                    ? Colors.white
                                    : const Color(0xFF0A0A23),
                                side: const BorderSide(color: Color(0xFF0A0A23)),
                                padding: const EdgeInsets.symmetric(vertical: 12),
                                shape: const RoundedRectangleBorder(
                                  borderRadius: BorderRadius.only(
                                    topRight: Radius.circular(4),
                                    bottomRight: Radius.circular(4),
                                  ),
                                ),
                              ),
                              child: const Text(
                                'Suggestion Mode',
                                style: TextStyle(
                                  fontFamily: 'RobotoMono',
                                  fontSize: 18,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),

                      // Chat box or file selected
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                        decoration: BoxDecoration(
                          color: const Color(0xFFEFEFEF),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: fileSelected
                                  ? Text(
                                'File: $selectedFileName',
                                style: const TextStyle(
                                    fontFamily: 'RobotoMono',
                                    fontSize: 16,
                                    fontWeight: FontWeight.w300,
                                    color: Color(0xFF0A0A23)
                                ),
                              )
                                  : TextField(
                                controller: _chatController,
                                maxLines: null,
                                decoration: const InputDecoration(
                                  hintText: 'Paste your code or\nupload a file [.py/.java]',
                                  border: InputBorder.none,
                                  hintStyle: TextStyle(
                                      fontFamily: 'RobotoMono',
                                      fontSize: 16,
                                      fontWeight: FontWeight.w300,
                                      color: Color(0xFF0A0A23)
                                  ),
                                ),
                                style: const TextStyle(
                                    fontFamily: 'RobotoMono',
                                    fontSize: 16,
                                    fontWeight: FontWeight.w300,
                                    color: Color(0xFF0A0A23)
                                ),
                              ),
                            ),
                            if (!isTextEntered)
                              GestureDetector(
                                onTap: pickFile,
                                child: SvgPicture.asset(
                                  fileSelected
                                      ? 'assets/icons/attachment_icon2.svg'
                                      : 'assets/icons/attachment_icon1.svg',
                                  width: 24,
                                  height: 24,
                                ),
                              ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Analyze Button
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: onAnalyzePressed, // Now navigates to Analysis Screen
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF0A0A23),
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(4),
                            ),
                          ),
                          child: const Text(
                            'Analyze',
                            style: TextStyle(
                              fontFamily: 'RobotoMono',
                              fontSize: 18,
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
          ],
        ),
      ),
    );
  }
}
