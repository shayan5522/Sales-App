import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:salesapp/app/ui/screens/labour/labour_dashboard.dart';
import '../../services/auth_service.dart';
import '../../ui/screens/auth/labour_signup.dart';
import '../../ui/screens/auth/otp.dart';
import '../../ui/screens/auth/owner_signup.dart';
import '../../ui/screens/auth/signup_as.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../../ui/screens/owner/owner_dashboard.dart';

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
        final role = doc['role'];
        if (role == 'owner') {
          Get.offAll(() => OwnerSignUpScreen());
        } else if (role == 'labour') {
          Get.offAll(() => LabourDashboard());
        } else {
          Get.snackbar("Error", "Unknown role");
        }
      } else {
        Get.offAll(() => OwnerSignUpScreen());
      }

    } catch (e) {
      Get.snackbar("Verification Failed", e.toString());
      rethrow;
    }
  }


}
