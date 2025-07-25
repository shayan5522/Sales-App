import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:salesapp/app/themes/styles.dart';
import 'package:salesapp/app/ui/widgets/appbar.dart';
import 'package:salesapp/app/ui/widgets/buttons.dart';
import 'package:salesapp/app/ui/widgets/textfield.dart';

import '../../../themes/colors.dart';
import 'labour_signin.dart';

class OwnerSignUpScreen extends StatelessWidget {
  const OwnerSignUpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppbar(title: "Owner SignUp"),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            children: [
              const SizedBox(height: 40),
              Center(
                child: Image.asset(
                  'assets/images/ownersignup.png',
                  height: 160,
                ),
              ),

              const SizedBox(height: 30),
               Text(
                "Owner Registration",
                style: AppTextStyles.subheading
              ),
              const SizedBox(height: 8),
              Text(
                "Create an account and enjoy the App",
                style: AppTextStyles.subtitle.copyWith(color: Colors.black26)
              ),

              const SizedBox(height: 32),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Shop Name",
                  style: AppTextStyles.title,
                ),
              ),
              const SizedBox(height: 8),
              CustomTextField(
                labelText: 'Enter shop name',
              ),
              const SizedBox(height: 24),

              // Terms Checkbox
              Row(
                children: [
                  Checkbox(
                    value: true,
                    onChanged: (value) {},
                    visualDensity: VisualDensity.compact,
                  ),
                  Expanded(
                    child: Text(
                      "I agree to terms and conditions",
                      style: AppTextStyles.subtitleSmall,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 16),

              PrimaryButton(text: "Sign Up", onPressed: (){Get.to(()=>LabourSignUpScreen());}),

              const Spacer(),

              // Sign In Text
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Already have an account? ",style: AppTextStyles.subtitle),
                  GestureDetector(
                    onTap: () {
                      // Navigate to Sign In
                    },
                    child:  Text(
                      "Sign In",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: AppColors.primary,
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
