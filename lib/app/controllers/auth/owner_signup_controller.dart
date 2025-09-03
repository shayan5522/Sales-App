import 'dart:math';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../ui/screens/owner/owner_Panel/owner_panel.dart';
import '../../ui/widgets/custom_snackbar.dart';

class OwnerSignupController extends GetxController {
  final isLoading = false.obs;
  final shopName = ''.obs;
  final referralCode = ''.obs;

  /// Generate secure random 6-character invite codes
  List<String> generateInviteCodes(int count) {
    const chars = 'ABCDEFGHJKLMNPQRSTUVWXYZ23456789';
    final random = Random.secure();
    return List.generate(count, (_) {
      return List.generate(6, (_) => chars[random.nextInt(chars.length)]).join();
    });
  }

  /// Save invite code under invites/<code>
  Future<void> createInviteCode(String code, String shopName, String ownerUid) async {
    final codeRef = FirebaseFirestore.instance.collection('invites').doc(code);
    final existing = await codeRef.get();
    if (existing.exists) return; // Avoid duplicates

    await codeRef.set({
      'code': code,
      'shopName': shopName,
      'ownerId': ownerUid,
      'used': false,
      'usedBy': null,
      'createdAt': FieldValue.serverTimestamp(),
    });

    print('✅ Created invite code $code under invites/');
  }

  /// Register the shop owner in users/<uid>
  Future<void> registerOwner() async {
    final rawShopName = shopName.value.trim();
    final sanitizedShopName = rawShopName.replaceAll(RegExp(r'[^\w\s]'), '').replaceAll(' ', '_');
    final referral = referralCode.value.trim();
    final user = FirebaseAuth.instance.currentUser;

    if (rawShopName.isEmpty || user == null) {
      CustomSnackbar.show(
        title: "Error",
        message: "Shop name required or user not logged in",
        isError: true,
      );
      return;
    }

    isLoading.value = true;

    final uid = user.uid;
    final phone = user.phoneNumber ?? '';
    final shopCode = uid.substring(0, 6).toUpperCase();

    try {
      // Check if this phone already owns a shop
      final existingShopQuery = await FirebaseFirestore.instance
          .collection('users')
          .where('role', isEqualTo: 'owner')
          .where('phone', isEqualTo: phone)
          .get();

      if (existingShopQuery.docs.isNotEmpty) {
        CustomSnackbar.show(
          title: "Error",
          message: "This phone number already has a registered shop.",
          isError: true,
        );
        isLoading.value = false;
        return;
      }

      // Register owner under users/<uid>
      await FirebaseFirestore.instance.collection('users').doc(uid).set({
        'uid': uid,
        'phone': phone,
        'role': 'owner',
        'shopName': sanitizedShopName,
        'shopCode': shopCode,
        'referralCode': referral,
        'createdAt': FieldValue.serverTimestamp(),
      });

      // Generate and save invite codes
      final inviteCodes = generateInviteCodes(3);
      for (final code in inviteCodes) {
        await createInviteCode(code, sanitizedShopName, uid);
      }
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('isLoggedIn', true);
      await prefs.setString('role', 'owner');
      await prefs.setString('uid', uid);

      print('✅ Shop registered successfully under users/$uid');
      Get.offAll(() => OwnerPanel());
    } catch (e) {
      print('❌ Error during registration: $e');
      CustomSnackbar.show(
        title: "Error",
        message: "Failed to register the shop.",
        isError: true,
      );
    } finally {
      isLoading.value = false;
    }
  }
}
