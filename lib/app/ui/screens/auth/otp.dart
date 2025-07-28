import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../controllers/auth/auth_controller.dart';
import 'package:salesapp/app/themes/styles.dart';
import 'package:salesapp/app/ui/widgets/appbar.dart';
import 'package:salesapp/app/ui/widgets/buttons.dart';
import 'package:salesapp/app/ui/widgets/textfield.dart';

class OTPVerificationScreen extends StatelessWidget {
  final TextEditingController otpController = TextEditingController();
  final AuthController authController = Get.find();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppbar(title: "OTP Verification"),
      backgroundColor: const Color(0xFFF6F6F9),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            const SizedBox(height: 50),
            Text("Enter 6-digit OTP sent to your phone", style: AppTextStyles.subtitle),
            const SizedBox(height: 24),
            CustomTextField(
              controller: otpController,
              labelText: 'Enter OTP',
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 32),
            PrimaryButton(
              text: "Verify OTP",
              onPressed: () {
                final code = otpController.text.trim();
                if (code.length == 6) {
                  authController.verifyOtp(code);
                } else {
                  Get.snackbar("Error", "Enter valid 6-digit OTP");
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
