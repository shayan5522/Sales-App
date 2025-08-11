import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../ui/screens/labour/panel/labour_panel.dart';
import '../../ui/widgets/custom_snackbar.dart';

class LabourSignupController extends GetxController {
  final isLoading = false.obs;
  final shopCodeController = ''.obs;

  Future<void> registerLabour() async {
    final inputCode = shopCodeController.value.trim().toUpperCase();

    if (inputCode.isEmpty) {
      CustomSnackbar.show(
        title: "Error",
        message: "Invite code is required.",
        isError: true,
      );
      return;
    }

    isLoading.value = true;

    try {
      final inviteDoc = await FirebaseFirestore.instance
          .collection('invites')
          .doc(inputCode)
          .get();

      if (!inviteDoc.exists) {
        CustomSnackbar.show(
          title: "Error",
          message: "Invalid invite code.",
          isError: true,
        );
        return;
      }

      final invite = inviteDoc.data()!;
      if (invite['used'] == true) {
        CustomSnackbar.show(
          title: "Error",
          message: "This code has already been used.",
          isError: true,
        );
        return;
      }

      final shopName = invite['shopName'];
      final ownerId = invite['ownerId'];

      // ✅ Check how many invites are already used for this shop
      final usedInvitesSnapshot = await FirebaseFirestore.instance
          .collection('invites')
          .where('shopName', isEqualTo: shopName)
          .where('used', isEqualTo: true)
          .get();

      if (usedInvitesSnapshot.docs.length >= 3) {
        CustomSnackbar.show(
          title: "Error",
          message: "This shop already has 3 active labours.",
          isError: true,
        );
        return;
      }

      // ✅ Register new labour
      final newLabourDoc = await FirebaseFirestore.instance
          .collection('users')
          .add({
        'role': 'labour',
        'code': inputCode,
        'shopName': shopName,
        'ownerId': ownerId,
        'createdAt': FieldValue.serverTimestamp(),
      });

      // ✅ Mark invite as used
      await FirebaseFirestore.instance
          .collection('invites')
          .doc(inputCode)
          .update({
        'used': true,
        'usedBy': newLabourDoc.id,
      });

      // ✅ Save login state
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('isLoggedIn', true);
      await prefs.setString('role', 'labour');
      await prefs.setString('inviteCode', inputCode);

      print('✅ Labour added with ID: ${newLabourDoc.id}');
      Get.offAll(() => LaborPanel());
    } catch (e) {
      CustomSnackbar.show(
        title: "Error",
        message: "Something went wrong: ${e.toString()}",
        isError: true,
      );
    } finally {
      isLoading.value = false;
    }
  }

}
