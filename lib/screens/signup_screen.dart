import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter_apps/services/api_service.dart';
import 'package:logger/logger.dart';
import 'package:intl/intl.dart';

var logger = Logger();

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  bool _isPasswordVisible = false;

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _dobController = TextEditingController();
  final TextEditingController _bioController = TextEditingController();

  File? _image;

  // Pick image file
  void _pickImage() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.image,
      );

      if (result != null) {
        setState(() {
          _image = File(result.files.single.path!);
        });
      }
    } on PlatformException catch (e) {
      logger.e("Error fetching image: $e");
    }
  }

  // open the date picker
  Future<void> _selectDateOfBirth() async {
    DateTime? selectedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );

    if (selectedDate != null) {
      // selected date to 'YYYY-MM-DD'
      String formattedDate = DateFormat('yyyy-MM-dd').format(selectedDate);
      setState(() {
        _dobController.text = formattedDate; // Set the formatted date in the TextField
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A0A23),
      body: Column(
        children: [
          const SizedBox(height: 60),
          GestureDetector(
            onTap: _pickImage,
            child: CircleAvatar(
              radius: 60,
              backgroundColor: Colors.grey.shade300,
              backgroundImage: _image != null ? FileImage(_image!) : null,
              child: _image == null
                  ? const Text("Upload Photo", style: TextStyle(color: Colors.black))
                  : null,
            ),
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
                  _buildTextField("Your Name?", controller: _nameController),
                  const SizedBox(height: 16),
                  _buildTextField("What will we call you? [username]", controller: _usernameController),
                  const SizedBox(height: 16),
                  _buildTextField("Password?", isPassword: true, controller: _passwordController),
                  const SizedBox(height: 16),

                  // Date of Birth TextField with date picker
                  GestureDetector(
                    onTap: _selectDateOfBirth,
                    child: AbsorbPointer(
                      child: _buildTextField("Date of Birth", controller: _dobController),
                    ),
                  ),
                  const SizedBox(height: 16),
                  _buildTextField("What Do You Do Exactly?", controller: _bioController),

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
                        _signUp();
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


  void _signUp() async {
    try {
      var response = await ApiService().signUp(
        _nameController.text,
        _usernameController.text,
        _passwordController.text,
        _dobController.text,
        _bioController.text,
        _image,
      );
      Navigator.pushReplacementNamed(context, '/login');
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Sign up failed: $e'),
        backgroundColor: Colors.red,
      ));
    }
  }

  Widget _buildTextField(String hint, {bool isPassword = false, TextEditingController? controller}) {
    return TextField(
      controller: controller,
      obscureText: isPassword && !_isPasswordVisible,
      decoration: InputDecoration(
        hintText: hint,
        filled: true,
        fillColor: const Color(0xFFEAEAEA),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(5),
          borderSide: BorderSide.none,
        ),
        suffixIcon: isPassword
            ? IconButton(
          icon: Icon(
            _isPasswordVisible ? Icons.visibility_off_outlined : Icons.visibility_outlined,
          ),
          onPressed: () {
            setState(() {
              _isPasswordVisible = !_isPasswordVisible;
            });
          },
        )
            : null,
      ),
    );
  }
}
