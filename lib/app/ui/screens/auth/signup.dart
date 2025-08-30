import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:salesapp/app/themes/colors.dart';
import 'package:salesapp/app/themes/styles.dart';
import 'package:salesapp/app/ui/widgets/appbar.dart';
import 'package:salesapp/app/ui/widgets/textfield.dart';
import '../../widgets/custom_snackbar.dart';
import '../../../controllers/auth/auth_controller.dart';

class SignUpScreen extends StatelessWidget {
  SignUpScreen({super.key});

  final TextEditingController phoneController = TextEditingController();
  final AuthController authController = Get.put(AuthController());

  Future<void> _handleSendOtp() async {
    final phone = phoneController.text.trim();
    if (phone.isEmpty) {
      CustomSnackbar.show(
        title: "Error",
        message: "Enter phone number",
        isError: true,
      );
      return;
    }

    try {
      await authController.sendOtp(phone);
    } catch (e) {
      // Error handling is done in the controller
    }
  }

  // Future<void> _handleSendOtp() async {
  //   final phone = phoneController.text.trim();
  //
  //   if (phone.isEmpty) {
  //     CustomSnackbar.show(
  //       title: "Error",
  //       message: "Enter phone number",
  //       isError: true,
  //     );
  //     return;
  //   }
  //
  //   // Indian numbers → 10 digits starting from 6-9
  //   final indiaRegex = RegExp(r'^[6-9]\d{9}$');
  //
  //   // Pakistani numbers → 10 digits after 0 (03xxxxxxxxx → write without leading 0)
  //   // Example: user enters 3xxxxxxxxx (not 03xxxxxxxxx)
  //   final pakistanRegex = RegExp(r'^[3]\d{9}$');
  //
  //   String fullPhone = "";
  //
  //   if (indiaRegex.hasMatch(phone)) {
  //     fullPhone = "+91$phone";
  //   } else if (pakistanRegex.hasMatch(phone)) {
  //     fullPhone = "+92$phone";
  //   } else {
  //     CustomSnackbar.show(
  //       title: "Error",
  //       message: "Enter valid Indian or Pakistani number",
  //       isError: true,
  //     );
  //     return;
  //   }
  //
  //   try {
  //     await authController.sendOtp(fullPhone);
  //   } catch (e) {
  //     // Already handled in controller
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppbar(title: "SignUp"),
      backgroundColor: const Color(0xFFF6F6F9),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 40),
              Center(child: Image.asset('assets/images/signup.png', height: 80)),
              const SizedBox(height: 80),
              Text(
                'Welcome back to the app',
                style: AppTextStyles.title.copyWith(color: Color(0xFF0F1928)),
              ),
              const SizedBox(height: 24),
              Text('Phone No', style: AppTextStyles.title),
              const SizedBox(height: 8),
              CustomTextField(
                controller: phoneController,
                labelText: 'Enter phone number',
              ),
              const SizedBox(height: 32),
              Obx(() {
                return SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      disabledBackgroundColor: AppColors.primary,
                    ),
                    onPressed: authController.isLoading.value
                        ? null
                        : () async {
                      await _handleSendOtp();
                    },
                    child: authController.isLoading.value
                        ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        color: Colors.white,
                        strokeWidth: 2,
                      ),
                    )
                        : Text(
                      "Send OTP",
                      style: AppTextStyles.subheading.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w100,
                      ),
                    ),
                  ),
                );
              }),
            ],
          ),
        ),
      ),
    );
  }
}