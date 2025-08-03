import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:salesapp/app/ui/screens/labour/labour_dashboard.dart';
import 'package:salesapp/app/ui/screens/labour/panel/labour_panel.dart';
import '../../services/auth_service.dart';
import '../../ui/screens/auth/labour_signup.dart';
import '../../ui/screens/auth/otp.dart';
import '../../ui/screens/auth/owner_signup.dart';
import '../../ui/screens/auth/signup_as.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../../ui/screens/owner/dashboard/owner_dashboard.dart';
import '../../ui/screens/owner/owner_Panel/owner_panel.dart';

class AuthController extends GetxController {
  final AuthService _authService = AuthService();
  var verificationId = ''.obs;

  Future<void> sendOtp(String phone) async {
    await _authService.sendOtp(
      phone: phone,
      codeSent: (verId) {
        verificationId.value = verId;
        Get.to(() => OTPVerificationScreen());
      },
      onError: (e) {
        Get.snackbar("Error", e.message ?? "OTP failed");
      },
    );
  }


  Future<void> verifyOtp(String otpCode) async {
    try {
      final userCred = await _authService.verifyOtp(
        verificationId: verificationId.value,
        smsCode: otpCode,
      );

      final uid = userCred.user!.uid;
      final doc = await FirebaseFirestore.instance.collection('users').doc(uid).get();

      if (doc.exists) {
        final data = doc.data()!;
        final role = data['role'];

        if (role == 'labour') {
          Get.offAll(() => LaborPanel());
        } else if (role == 'owner') {
          final shopName = data['shopName'];
          if (shopName != null && shopName.toString().isNotEmpty) {
            Get.offAll(() => OwnerPanel());
          } else {
            Get.offAll(() => OwnerSignUpScreen());
          }
        } else {
          Get.snackbar("Error", "Unknown role assigned to user.");
        }
      } else {
        // No user doc found — assume new owner
        Get.offAll(() => OwnerSignUpScreen());
      }
    } catch (e) {
      Get.snackbar("Verification Failed", e.toString());
      rethrow;
    }
  }




}
