import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:salesapp/app/themes/styles.dart';
import 'package:salesapp/app/ui/widgets/appbar.dart';
import 'package:salesapp/app/ui/widgets/buttons.dart';
import 'package:salesapp/app/ui/widgets/textfield.dart';
import 'otp.dart';

class SignUpScreen extends StatelessWidget {
  const SignUpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppbar(title: "SignUp"),
      backgroundColor: const Color(0xFFF6F6F9),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 40),
            Center(child: Image.asset('assets/images/signup.png', height: 180)),
            const SizedBox(height: 24),
            Text(
              'Welcome back to the app',
              style: AppTextStyles.subtitle.copyWith(color: Color(0xFF0F1928)),
            ),

            const SizedBox(height: 24),

            Text('Phone No', style: AppTextStyles.title),

            const SizedBox(height: 8),
            CustomTextField(
              labelText: 'Enter phone number',
            ),
            const SizedBox(height: 32),
            PrimaryButton(text: "Send OTP", onPressed: () {Get.to(()=>OTPVerificationScreen());}),
          ],
        ),
      ),
    );
  }
}
