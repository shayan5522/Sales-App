import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:salesapp/app/themes/styles.dart';
import 'package:salesapp/app/ui/screens/auth/labour_signup.dart';
import 'package:salesapp/app/ui/screens/auth/signup.dart';
import 'package:salesapp/app/ui/widgets/appbar.dart';
import 'package:salesapp/app/ui/widgets/buttons.dart';


class SignUpAsScreen extends StatefulWidget {
  const SignUpAsScreen({super.key});

  @override
  State<SignUpAsScreen> createState() => _SignUpAsScreenState();
}

class _SignUpAsScreenState extends State<SignUpAsScreen> {
  bool _isLoadingOwner = false;
  bool _isLoadingLabour = false;

  void _handleOwnerTap() async {
    setState(() => _isLoadingOwner = true);
    await Future.delayed(const Duration(seconds: 1));
    setState(() => _isLoadingOwner = false);
    Get.to(() =>  SignUpScreen());
  }

  void _handleLabourTap() async {
    setState(() => _isLoadingLabour = true);
    await Future.delayed(const Duration(seconds: 1));
    setState(() => _isLoadingLabour = false);
    Get.to(() => LabourSignUpScreen());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F6F9),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16),
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(height: 20),
              Image.asset('assets/images/signupas.png', height: 250),
              const SizedBox(height: 40),
              Text('Sign Up Your Account As', style: AppTextStyles.heading),
              const SizedBox(height: 40),

              PrimaryButton(
                text: "Owner",
                isLoading: _isLoadingOwner,
                onPressed: _isLoadingOwner ? () {} : _handleOwnerTap,
              ),

              const SizedBox(height: 16),

              PrimaryButton(
                text: "Labour",
                isLoading: _isLoadingLabour,
                onPressed: _isLoadingLabour ? () {} : _handleLabourTap,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
