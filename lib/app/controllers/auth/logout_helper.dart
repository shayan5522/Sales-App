import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:get/get.dart';
import '../../ui/screens/auth/signup_as.dart';

Future<void> logoutUser() async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.clear();

  Get.offAll(() => const SignUpAsScreen());
}

Future<void> LabourLogoutUser() async {
  final prefs = await SharedPreferences.getInstance();
  final inviteCode = prefs.getString('inviteCode');
  if (inviteCode != null && inviteCode.isNotEmpty) {
    try {
      // Reset invite code status
      await FirebaseFirestore.instance.collection('invites').doc(inviteCode).update({
        'used': false,
        'usedBy': null,
      });
    } catch (e) {
      print("Error resetting invite code: $e");
    }
  }

  await prefs.clear();
  Get.offAll(() => const SignUpAsScreen());
}