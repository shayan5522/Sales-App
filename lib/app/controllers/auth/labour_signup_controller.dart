import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../ui/screens/labour/panel/labour_panel.dart';

class LabourSignupController extends GetxController {
  final isLoading = false.obs;
  final shopCodeController = ''.obs;

  Future<void> registerLabour() async {
    final inputCode = shopCodeController.value.trim().toUpperCase();

    if (inputCode.isEmpty) {
      Get.snackbar("Error", "Invite code is required.");
      return;
    }

    isLoading.value = true;

    try {
      final inviteDoc = await FirebaseFirestore.instance.collection('invites').doc(inputCode).get();

      if (!inviteDoc.exists) {
        Get.snackbar("Error", "Invalid invite code.");
        return;
      }

      final invite = inviteDoc.data()!;
      if (invite['used'] == true) {
        Get.snackbar("Error", "This code has already been used.");
        return;
      }

      final shopName = invite['shopName'];
      final ownerId = invite['ownerId'];

      // Check labour count
      final labourSnapshot = await FirebaseFirestore.instance
          .collection('users')
          .where('role', isEqualTo: 'labour')
          .where('shopName', isEqualTo: shopName)
          .get();

      if (labourSnapshot.docs.length >= 3) {
        Get.snackbar("Error", "This shop already has 3 labours.");
        return;
      }

      // Register new labour
      final newLabourDoc = await FirebaseFirestore.instance.collection('users').add({
        'role': 'labour',
        'code': inputCode,
        'shopName': shopName,
        'ownerId': ownerId,
        'createdAt': FieldValue.serverTimestamp(),
      });

      // Mark invite used
      await FirebaseFirestore.instance.collection('invites').doc(inputCode).update({
        'used': true,
        'usedBy': newLabourDoc.id,
      });

      /// ✅ Save login state
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('isLoggedIn', true);
      await prefs.setString('role', 'labour');

      print('✅ Labour added with ID: ${newLabourDoc.id}');
      Get.offAll(() => LaborPanel());
    } catch (e) {
      Get.snackbar("Error", "Something went wrong: ${e.toString()}");
    } finally {
      isLoading.value = false;
    }
  }

  // /// Optional reusable logout method
  // static Future<void> logout() async {
  //   final prefs = await SharedPreferences.getInstance();
  //   await prefs.clear();
  //   Get.offAllNamed('/login'); // or Get.offAll(() => SignUpAsScreen());
  // }
}
