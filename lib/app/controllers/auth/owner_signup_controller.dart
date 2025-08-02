import 'dart:math';

import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:salesapp/app/ui/screens/owner/owner_Panel/owner_panel.dart';
import '../../ui/screens/owner/dashboard/owner_dashboard.dart';

class OwnerSignupController extends GetxController {
  final isLoading = false.obs;
  final shopName = ''.obs;
  final referralCode = ''.obs;

  // Generate secure random invite codes
  List<String> generateInviteCodes(int count) {
    const chars = 'ABCDEFGHJKLMNPQRSTUVWXYZ23456789';
    final random = Random.secure();

    return List.generate(count, (_) {
      return List.generate(6, (_) => chars[random.nextInt(chars.length)]).join();
    });
  }

  // Save invite code under user's subcollection
  Future<void> createInviteCode(String code, String shopDocId, String ownerUid) async {
    final docRef = FirebaseFirestore.instance
        .collection('users')
        .doc(shopDocId)
        .collection('invites')
        .doc(code);

    final doc = await docRef.get();
    if (doc.exists) return;

    await docRef.set({
      'code': code,
      'ownerId': ownerUid,
      'used': false,
      'usedBy': null,
      'createdAt': FieldValue.serverTimestamp(),
    });
  }

  // Register the owner with shopName as document ID
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
    final uid = user.uid;
    final phone = user.phoneNumber ?? '';
    final shopCode = uid.substring(0, 6).toUpperCase();

    try {
      // Check for existing shop name
      final shopDoc = await FirebaseFirestore.instance.collection('users').doc(sanitizedShopName).get();
      if (shopDoc.exists) {
        Get.snackbar("Error", "This shop name is already registered. Please use a different name.");
        isLoading.value = false;
        return;
      }

      // Save user with shopName as document ID
      await FirebaseFirestore.instance.collection('users').doc(sanitizedShopName).set({
        'uid': uid,
        'phone': phone,
        'role': 'owner',
        'shopName': rawName,
        'shopCode': shopCode,
        'referralCode': referral,
      });

      // Save invite codes under subcollection
      final inviteCodes = generateInviteCodes(3);
      for (String code in inviteCodes) {
        await createInviteCode(code, sanitizedShopName, uid);
      }

      Get.offAll(() => OwnerPanel());
    } catch (e) {
      // print('Error during registration: $e');
      Get.snackbar("Error", "Failed to register the shop");
    } finally {
      isLoading.value = false;
    }
  }
}
