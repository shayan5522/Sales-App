import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../ui/screens/owner/owner_dashboard.dart';

class OwnerSignupController extends GetxController {
  final isLoading = false.obs;
  final shopName = ''.obs;
  final referralCode = ''.obs;

  List<String> generateInviteCodes(int count) {
    const chars = 'ABCDEFGHJKLMNPQRSTUVWXYZ23456789';
    return List.generate(count, (_) {
      return List.generate(6, (i) => chars[(DateTime.now().microsecondsSinceEpoch + i) % chars.length]).join();
    });
  }

  Future<void> registerOwner() async {
    final name = shopName.value.trim();
    final referral = referralCode.value.trim();
    final user = FirebaseAuth.instance.currentUser;

    if (name.isEmpty || user == null) {
      Get.snackbar("Error", "Shop name required or user not logged in");
      return;
    }

    isLoading.value = true;
    final uid = user.uid;
    final phone = user.phoneNumber ?? '';
    final shopCode = uid.substring(0, 6).toUpperCase();

    await FirebaseFirestore.instance.collection('users').doc(uid).set({
      'uid': uid,
      'phone': phone,
      'role': 'owner',
      'shopName': name,
      'shopCode': shopCode,
      'referralCode': referral,
    });

    final inviteCodes = generateInviteCodes(3);
    for (String code in inviteCodes) {
      await FirebaseFirestore.instance.collection('invites').doc(code).set({
        'code': code,
        'ownerId': uid,
        'used': false,
        'usedBy': null,
        'createdAt': FieldValue.serverTimestamp(),
      });
    }

    isLoading.value = false;
    Get.offAll(() => OwnerDashboard());
  }
}
