import 'package:flutter/material.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'home_screen.dart';

class SignUpScreen extends StatefulWidget {
  final bool fromMenu;
  const SignUpScreen({Key? key, this.fromMenu = false}) : super(key: key);

  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final nameController = TextEditingController();
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();
  final dobController = TextEditingController();
  final roleController = TextEditingController();

  File? _image;

  Future<void> _pickImage() async {
    final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

  Future<void> _saveLoginStatus() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isLoggedIn', true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: widget.fromMenu ? AppBar(title: Text("Edit Profile")) : null,
      body: Padding(
        padding: EdgeInsets.all(20),
        child: ListView(
          children: [
            GestureDetector(
              onTap: _pickImage,
              child: CircleAvatar(
                radius: 50,
                backgroundColor: Colors.grey[700],
                backgroundImage: _image != null ? FileImage(_image!) : null,
                child: _image == null ? Icon(Icons.camera_alt, color: Colors.white) : null,
              ),
            ),
            SizedBox(height: 20),
            TextField(controller: nameController, decoration: InputDecoration(labelText: "Your Name?")),
            TextField(controller: usernameController, decoration: InputDecoration(labelText: "What should we call you? [username]")),
            TextField(controller: passwordController, decoration: InputDecoration(labelText: "Password?"), obscureText: true),
            TextField(controller: dobController, decoration: InputDecoration(labelText: "Date of Birth?")),
            TextField(controller: roleController, decoration: InputDecoration(labelText: "What Do You Do Exactly?")),
            SizedBox(height: 20),
            ElevatedButton(
              child: Text("Confirm"),
              onPressed: () async {
                await _saveLoginStatus();
                if (!context.mounted) return;
                if (widget.fromMenu) {
                  Navigator.pushReplacement(
                      context, MaterialPageRoute(builder: (_) => HomeScreen()));
                } else {
                  Navigator.pushReplacementNamed(context, '/login');
                }
              },
            )
          ],
        ),
      ),
    );
  }
}