import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../controllers/auth/auth_controller.dart';
import 'package:salesapp/app/themes/styles.dart';
import 'package:salesapp/app/ui/widgets/appbar.dart';
import 'package:salesapp/app/ui/widgets/buttons.dart';
import 'package:salesapp/app/ui/widgets/textfield.dart';

import '../../widgets/custom_snackbar.dart';

class OTPVerificationScreen extends StatefulWidget {
  const OTPVerificationScreen({super.key}); // also fix constructor

  @override
  State<OTPVerificationScreen> createState() => _OTPVerificationScreenState();
}

class _OTPVerificationScreenState extends State<OTPVerificationScreen> {
  final TextEditingController otpController = TextEditingController();
  final AuthController authController = Get.find();

  bool _isVerifying = false; // ✅ move it here

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
              isLoading: _isVerifying,
              onPressed: _isVerifying
                  ? () {}
                  : () async {
                final code = otpController.text.trim();
                if (code.length != 6) {
                  CustomSnackbar.show(
                    title: "Error",
                    message: "Enter valid 6-digit OTP",
                    isError: true,
                  );

                  return;
                }

                setState(() => _isVerifying = true);

                try {
                  await authController.verifyOtp(code);
                } catch (_) {
                  // error already handled inside controller
                }

                setState(() => _isVerifying = false);
              },
            ),
          ],
        ),
      ),
    );
  }
}

