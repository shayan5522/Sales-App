import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shoporbit/app/themes/styles.dart';
import 'package:shoporbit/app/ui/widgets/appbar.dart';
import 'package:shoporbit/app/ui/widgets/buttons.dart';
import 'package:shoporbit/app/ui/widgets/textfield.dart';
import '../../../controllers/auth/labour_signup_controller.dart';

class LabourSignUpScreen extends StatelessWidget {
  LabourSignUpScreen({super.key});
  final controller = Get.put(LabourSignupController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppbar(title: "Labour SignUp"),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(height: 40),
                Center(child: Image.asset('assets/images/ownersignup.png', height: 160)),
                const SizedBox(height: 30),
                Text("Labour Registration", style: AppTextStyles.subheading),
                const SizedBox(height: 8),
                Text("Enter your unique invite code", style: AppTextStyles.subtitle.copyWith(color: Colors.black26)),
                const SizedBox(height: 32),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text("Invite Code", style: AppTextStyles.title),
                ),
                const SizedBox(height: 8),
                CustomTextField(
                  onChanged: (val) => controller.shopCodeController.value = val,
                  labelText: 'Enter invite code',
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
                  text: "Register",
                  isLoading: controller.isLoading.value,
                  onPressed: controller.registerLabour,
                )),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
