import 'package:flutter/material.dart';
import 'package:smart_event_explorer_frontend/models/UserModel.dart';
import 'package:smart_event_explorer_frontend/screens/Home/home.dart';
import 'package:smart_event_explorer_frontend/screens/auth/LoginScreen.dart';
import 'package:smart_event_explorer_frontend/services/UserService.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: FutureBuilder(
        future: _initializeApp(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.data == true) {
              return Home();
            } else {
              return LoginScreen();
            }
          }
          return Center(
            child: Image.asset(
              "lib/assets/gif/splash_both.gif",
              alignment: AlignmentGeometry.center,
              fit: BoxFit.contain,
            ),
          );
        },
      ),
    );
  }
}

Future<bool> _initializeApp() async {
  // Simulate some loading work
  // await Future.delayed(const Duration(milliseconds: 5500));

  bool isLoggedIn = await _checkLoginStatus();
  return isLoggedIn;
}

Future<bool> _checkLoginStatus() async {
  User? currentUser = await UserService().getUser();
  if (currentUser != null) {
    return true;
  } else {
    return false;
  }
}
