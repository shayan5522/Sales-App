import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../ui/screens/labour/labour_dashboard.dart';

class LabourSignupController extends GetxController {
  final isLoading = false.obs;

  final shopCodeController = ''.obs;

  Future<void> registerLabour() async {
    final code = shopCodeController.value.trim().toUpperCase();
    final user = FirebaseAuth.instance.currentUser;

    if (code.isEmpty || user == null) {
      Get.snackbar("Error", "Invite code required or user not logged in");
      return;
    }

    isLoading.value = true;

    final inviteDoc = await FirebaseFirestore.instance
        .collection('invites')
        .doc(code)
        .get();

    if (!inviteDoc.exists) {
      isLoading.value = false;
      Get.snackbar("Error", "Invalid invite code");
      return;
    }

    final invite = inviteDoc.data()!;
    final bool used = invite['used'] ?? false;

    if (used) {
      isLoading.value = false;
      Get.snackbar("Error", "This invite code has already been used");
      return;
    }

    final uid = user.uid;
    final phone = user.phoneNumber ?? '';

    await FirebaseFirestore.instance.collection('users').doc(uid).set({
      'uid': uid,
      'phone': phone,
      'role': 'labour',
      'shopCode': code,
      'ownerId': invite['ownerId'],
    });

    await FirebaseFirestore.instance.collection('invites').doc(code).update({
      'used': true,
      'usedBy': uid,
    });

    isLoading.value = false;
    Get.offAll(() => LabourDashboard());
  }
}
