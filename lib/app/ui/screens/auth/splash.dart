import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../labour/panel/labour_panel.dart';
import '../owner/dashboard/owner_dashboard.dart';
import '../auth/signup_as.dart'; // or your login/start screen
import '../owner/owner_Panel/owner_panel.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    checkLoginStatus();
  }

  Future<void> checkLoginStatus() async {
    await Future.delayed(Duration(seconds: 2)); // Optional: splash delay

    final prefs = await SharedPreferences.getInstance();
    final isLoggedIn = prefs.getBool('isLoggedIn') ?? false;
    final role = prefs.getString('role');

    if (isLoggedIn && role != null) {
      if (role == 'labour') {
        Get.offAll(() => LaborPanel());
      } else if (role == 'owner') {
        Get.offAll(() => OwnerPanel());
      } else {
        Get.offAll(() => SignUpAsScreen());
      }
    } else {
      Get.offAll(() => SignUpAsScreen()); // Not logged in
    }
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
