import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../services/auth_service.dart';
import '../../ui/screens/auth/otp.dart';
import '../../ui/screens/auth/owner_signup.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../ui/screens/labour/panel/labour_panel.dart';
import '../../ui/screens/owner/owner_Panel/owner_panel.dart';
import '../../ui/widgets/custom_snackbar.dart';
class AuthController extends GetxController {
  final AuthService _authService = AuthService();
  var verificationId = ''.obs;
  RxBool isLoading = false.obs;
  var lastError = ''.obs;

  Future<void> sendOtp(String phone) async {
    isLoading.value = true;
    lastError.value = '';
    try {
      await _authService.sendOtp(
        phone: phone,
        codeSent: (verId) {
          verificationId.value = verId;
          isLoading.value = false; // Only stop loading after navigation
          Get.to(() => OTPVerificationScreen());
        },
        onError: (e) {
          isLoading.value = false;
          lastError.value = e.message ?? "OTP failed";
          CustomSnackbar.show(
            title: "Error",
            message: lastError.value,
            isError: true,
          );
        },
      );
    } catch (e) {
      isLoading.value = false;
      lastError.value = "Failed to send OTP";
      CustomSnackbar.show(
        title: "Error",
        message: lastError.value,
        isError: true,
      );
      print('error is: $e');
    }
  }


  Future<void> verifyOtp(String otpCode) async {

    try {
      // Step 1: Verify OTP
      final userCred = await _authService.verifyOtp(
        verificationId: verificationId.value,
        smsCode: otpCode,
      );

      final uid = userCred.user!.uid;

      // Step 2: Fetch user document from Firestore
      final doc = await FirebaseFirestore.instance.collection('users').doc(uid).get();

      if (doc.exists) {
        final data = doc.data()!;
        final role = data['role'];
        final shopName = data['shopName'];

        // Step 3: Save data locally
        final prefs = await SharedPreferences.getInstance();
        await prefs.setBool('isLoggedIn', true);
        await prefs.setString('uid', uid);
        await prefs.setString('role', role);

        // Step 4: Navigate based on role
        if (role == 'labour') {
          Get.offAll(() => LaborPanel());
        } else if (role == 'owner') {
          if (shopName != null && shopName.toString().isNotEmpty) {
            Get.offAll(() => OwnerPanel());
          } else {
            Get.offAll(() => OwnerSignUpScreen());
          }
        } else {
          CustomSnackbar.show(
            title: "Error",
            message: "Unknown role assigned to user.",
            isError: true,
          );
        }
      } else {
        Get.offAll(() => OwnerSignUpScreen());
      }
    } catch (e) {
      CustomSnackbar.show(
        title: "Verification Failed",
        message: e.toString(),
        isError: true,
      );
      rethrow;
    }
  }


}
