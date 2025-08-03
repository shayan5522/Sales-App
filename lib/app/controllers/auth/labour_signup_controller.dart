import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:salesapp/app/ui/screens/labour_panel.dart';
import '../../ui/screens/labour/labour_dashboard.dart';

class LabourSignupController extends GetxController {
  final isLoading = false.obs;
  final shopCodeController = ''.obs;

  Future<void> registerLabour() async {
    final inputCode = shopCodeController.value.trim().toUpperCase();
    final user = FirebaseAuth.instance.currentUser;

    if (inputCode.isEmpty || user == null) {
      Get.snackbar("Error", "Invite code required or user not logged in");
      return;
    }

    isLoading.value = true;

    try {
      final inviteDoc = await FirebaseFirestore.instance
          .collection('invites')
          .doc(inputCode)
          .get();

      if (!inviteDoc.exists) {
        print('❌ Code "$inputCode" not found.');
        Get.snackbar("Error", "Invalid invite code");
        isLoading.value = false;
        return;
      }

      final invite = inviteDoc.data()!;
      if (invite['used'] == true) {
        print('⚠️ Code "$inputCode" already used.');
        Get.snackbar("Error", "This invite code has already been used");
        isLoading.value = false;
        return;
      }

      final uid = user.uid;
      final phone = user.phoneNumber ?? '';
      final shopName = invite['shopName'];
      final ownerId = invite['ownerId'];

      // Register labour
      await FirebaseFirestore.instance.collection('users').doc(uid).set({
        'uid': uid,
        'phone': phone,
        'role': 'labour',
        'shopName': shopName,
        'shopCode': inputCode,
        'ownerId': ownerId,
      });

      // Mark invite code as used
      await FirebaseFirestore.instance.collection('invites').doc(inputCode).update({
        'used': true,
        'usedBy': uid,
      });

      print('✅ Code "$inputCode" used successfully.');
      Get.offAll(() => LaborPanel());
    } catch (e) {
      print('❌ Error during labour registration: $e');
      Get.snackbar("Error", "Something went wrong during registration.");
    } finally {
      isLoading.value = false;
    }
  }
}
