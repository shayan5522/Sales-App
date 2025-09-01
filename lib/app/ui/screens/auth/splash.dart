import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../themes/styles.dart';
import '../labour/panel/labour_panel.dart';
import '../auth/signup_as.dart';
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
    await Future.delayed(const Duration(seconds: 3));

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
      Get.offAll(() => SignUpAsScreen());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // Clean background
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // App icon with animation
            AnimatedContainer(
              duration: const Duration(seconds: 2),
              curve: Curves.easeInOut,
              height: 120,
              width: 120,
              child: Image.asset("assets/icon/app_icon.png"),
            ),

            const SizedBox(height: 20),

            // App name
            Text(
              "Shop Orbit",
              style: AppTextStyles.title.copyWith(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),

            const SizedBox(height: 40),

            // Progress indicator
            const CircularProgressIndicator(
              strokeWidth: 2.5,
              color: Colors.blueAccent,
            ),
          ],
        ),
      ),
    );
  }
}
