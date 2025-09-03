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
  // Constants for SharedPreferences keys
  static const String _isLoggedInKey = 'isLoggedIn';
  static const String _roleKey = 'role';
  static const String _labourRole = 'labour';
  static const String _ownerRole = 'owner';

  @override
  void initState() {
    super.initState();
    _checkLoginStatus();
  }

  Future<void> _checkLoginStatus() async {
    try {
      // Add delay for splash screen
      await Future.delayed(const Duration(seconds: 3));

      // Check if widget is still mounted before proceeding
      if (!mounted) return;

      final prefs = await SharedPreferences.getInstance();
      final isLoggedIn = prefs.getBool(_isLoggedInKey) ?? false;
      final role = prefs.getString(_roleKey);

      _navigateBasedOnAuthStatus(isLoggedIn, role);
    } catch (e) {
      // Handle any errors gracefully
      if (mounted) {
        Get.offAll(() => SignUpAsScreen());
      }
    }
  }

  void _navigateBasedOnAuthStatus(bool isLoggedIn, String? role) {
    if (!mounted) return;

    if (isLoggedIn && role != null) {
      switch (role) {
        case _labourRole:
          Get.offAll(() => LaborPanel());
          break;
        case _ownerRole:
          Get.offAll(() => OwnerPanel());
          break;
        default:
        // Handle unexpected role values
          Get.offAll(() => SignUpAsScreen());
          break;
      }
    } else {
      Get.offAll(() => SignUpAsScreen());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AnimatedContainer(
              duration: const Duration(seconds: 2),
              curve: Curves.easeInOut,
              height: 120,
              width: 120,
              child: Image.asset("assets/icon/app_icon.png"),
            ),
            const SizedBox(height: 20),
            Text(
              "Shop Orbit",
              style: AppTextStyles.title.copyWith(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 40),
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