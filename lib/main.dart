// 📁 lib/main.dart
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'screens/gettingstarted.dart';
import 'screens/login.dart';
import 'screens/home_screen.dart';
import 'screens/signup_screen.dart';

void main() {
  runApp(const SmellFixApp());
}

class SmellFixApp extends StatelessWidget {
  const SmellFixApp({super.key});

  Future<Widget> _getInitialScreen() async {
    final prefs = await SharedPreferences.getInstance();
    final seenIntro = prefs.getBool('seenIntro') ?? false;
    final isLoggedIn = prefs.getBool('isLoggedIn') ?? false;

    if (!seenIntro) {
      await prefs.setBool('seenIntro', true);
      return const GettingStartedScreen();
    } else if (isLoggedIn) {
      return const HomeScreen();
    } else {
      return const LoginScreen();
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SmellFix',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark(),
      home: FutureBuilder<Widget>(
        future: _getInitialScreen(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return snapshot.data!;
          } else {
            return const Scaffold(
              body: Center(child: CircularProgressIndicator()),
            );
          }
        },
      ),
      routes: {
        '/login': (context) => const LoginScreen(),
        '/home': (context) => const HomeScreen(),
        '/signup': (context) => const SignUpScreen(),
        '/getting_started': (context) => const GettingStartedScreen(),
      },
    );
  }
}
