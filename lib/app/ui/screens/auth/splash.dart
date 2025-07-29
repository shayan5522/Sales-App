import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:salesapp/app/ui/screens/auth/signup_as.dart';
import '../../../themes/styles.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();

    Timer(const Duration(seconds: 5), () {
      Get.off(() =>  SignUpAsScreen());
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xFF7CCEC8),
              Color(0xFF25A5DF),
              Color(0xFF0194E9),
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            stops: [0.0, 0.31, 0.44],
          ),
        ),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Image.asset(
                'assets/images/ownersignup.png',
                width: 120,
                height: 120,
              ),
              const SizedBox(height: 20),
              Text(
                'Sales App',
                style: AppTextStyles.heading.copyWith(color: Colors.white),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
