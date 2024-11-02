import 'package:flutter/material.dart';
import 'onboarding_page.dart';
import 'dart:async';
// import 'onboarding_page.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key})
      : super(key: key); // Add the key parameter here

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Timer(
        const Duration(seconds: 3),
        () => Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (context) => OnboardingPage())));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: // Replace with your desired splash screen image/widget
            Image.asset(
          'asset/logo2.jpg',
          width: 300,
          height: 300,
        ),
      ),
    );
  }
}
