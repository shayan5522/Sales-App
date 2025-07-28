import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:salesapp/app/themes/styles.dart';
import 'package:salesapp/app/ui/screens/auth/labour_signin.dart';
import 'package:salesapp/app/ui/screens/auth/signup.dart';
import 'package:salesapp/app/ui/widgets/appbar.dart';
import 'package:salesapp/app/ui/widgets/buttons.dart';

class SignUpAsScreen extends StatelessWidget {
  const SignUpAsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //appBar: CustomAppbar(title: "SignUp As"),
      backgroundColor: const Color(0xFFF6F6F9),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16),
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(height: 20),
              Image.asset(
                'assets/images/signupas.png',
                height: 250,
              ),
              const SizedBox(height: 40),
               Text(
                'Sign Up Your Account As',
                style: AppTextStyles.heading,
              ),
              const SizedBox(height: 40),
              PrimaryButton(text: "Owner", onPressed: (){Get.to(()=>SignUpScreen());}),
              const SizedBox(height: 16),
              PrimaryButton(text: "Labour", onPressed: (){Get.to(()=>LabourSignUpScreen());}),
            ],
          ),
        ),
      ),
    );
  }
}
