import 'dart:math';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:salesapp/app/ui/screens/owner/owner_Panel/owner_panel.dart';

class OwnerSignupController extends GetxController {
  final isLoading = false.obs;
  final shopName = ''.obs;
  final referralCode = ''.obs;

  List<String> _generateInviteCodes(int count) {
    const chars = 'ABCDEFGHJKLMNPQRSTUVWXYZ23456789';
    final random = Random.secure();
    return List.generate(count, (_) {
      return List.generate(6, (_) => chars[random.nextInt(chars.length)]).join();
    });
  }

  Future<void> _saveInviteCode(String code, String shopDocId, String ownerUid) async {
    final data = {
      'code': code,
      'ownerId': ownerUid,
      'shopDocId': shopDocId,
      'used': false,
      'usedBy': null,
      'createdAt': FieldValue.serverTimestamp(),
    };

    // // Save under subcollection
    // final shopInviteRef = FirebaseFirestore.instance
    //     .collection('users')
    //     .doc(shopDocId)
    //     .collection('invites')
    //     .doc(code);
    //
    // await shopInviteRef.set(data);

    // Also save to top-level 'invites' collection for easy querying
    final globalInviteRef = FirebaseFirestore.instance
        .collection('invites')
        .doc(shopName.value)
        .collection('codes')
        .doc(code);


    await globalInviteRef.set(data);
  }

  Future<void> registerOwner() async {
    final rawName = shopName.value.trim();
    final sanitizedShopName = rawName.replaceAll(RegExp(r'[^\w\s]'), '').replaceAll(' ', '_');
    final referral = referralCode.value.trim();
    final user = FirebaseAuth.instance.currentUser;

    if (rawName.isEmpty || user == null) {
      Get.snackbar("Error", "Shop name required or user not logged in");
      return;
    }

    isLoading.value = true;

    try {
      final uid = user.uid;
      final phone = user.phoneNumber ?? '';
      final shopCode = uid.substring(0, 6).toUpperCase();

      final shopDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(sanitizedShopName)
          .get();

      if (shopDoc.exists) {
        Get.snackbar("Error", "This shop name is already registered.");
        return;
      }

      await FirebaseFirestore.instance.collection('users').doc(sanitizedShopName).set({
        'uid': uid,
        'phone': phone,
        'role': 'owner',
        'shopName': rawName,
        'shopCode': shopCode,
        'referralCode': referral,
      });

      final inviteCodes = _generateInviteCodes(3);
      for (final code in inviteCodes) {
        await _saveInviteCode(code, sanitizedShopName, uid);
      }

      Get.offAll(() =>  OwnerPanel());
    } catch (e) {
      Get.snackbar("Error", "Failed to register shop: ${e.toString()}");
    } finally {
      isLoading.value = false;
    }
  }
}
