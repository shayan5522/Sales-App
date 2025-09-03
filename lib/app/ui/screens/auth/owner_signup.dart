import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shoporbit/app/themes/styles.dart';
import 'package:shoporbit/app/ui/widgets/appbar.dart';
import 'package:shoporbit/app/ui/widgets/buttons.dart';
import 'package:shoporbit/app/ui/widgets/textfield.dart';
import 'package:shoporbit/app/themes/colors.dart';
import '../../../controllers/auth/owner_signup_controller.dart';
class OwnerSignUpScreen extends StatelessWidget {
  OwnerSignUpScreen({super.key});
  final controller = Get.put(OwnerSignupController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppbar(title: "Owner SignUp",showBackButton: false,),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(height: 40),
              Center(child: Image.asset('assets/images/ownersignup.png', height: 160)),
              const SizedBox(height: 30),
              Text("Owner Registration", style: AppTextStyles.subheading),
              const SizedBox(height: 8),
              Text("Create an account and enjoy the App", style: AppTextStyles.subtitle.copyWith(color: Colors.black26)),
              const SizedBox(height: 32),
              Align(alignment: Alignment.centerLeft, child: Text("Shop Name", style: AppTextStyles.title)),
              const SizedBox(height: 8),
              CustomTextField(
                labelText: 'Enter shop name',
                onChanged: (val) => controller.shopName.value = val,
              ),
              const SizedBox(height: 32),
              Align(alignment: Alignment.centerLeft, child: Text("Referral Code", style: AppTextStyles.title)),
              const SizedBox(height: 8),
              CustomTextField(
                labelText: 'Enter referral code (optional)',
                onChanged: (val) => controller.referralCode.value = val,
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  Checkbox(value: true, onChanged: (value) {}, visualDensity: VisualDensity.compact),
                  Expanded(child: Text("I agree to terms and conditions", style: AppTextStyles.subtitleSmall)),
                ],
              ),
              const SizedBox(height: 16),
              Obx(() => PrimaryButton(
                text: "Sign Up",
                isLoading: controller.isLoading.value,
                onPressed: controller.registerOwner,
              )),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Already have an account? ", style: AppTextStyles.subtitle),
                  GestureDetector(
                    onTap: (
                        ) {}, // You can navigate to login screen here
                    child: Text("Sign In", style: TextStyle(fontWeight: FontWeight.bold, color: AppColors.primary)),
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
