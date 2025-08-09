// 🔹 Controller for managing invites (labours)
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

import '../../../widgets/custom_snackbar.dart';

class UserManagementController extends GetxController {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  RxList<Map<String, dynamic>> invites = <Map<String, dynamic>>[].obs;

  Future<void> fetchInvites() async {
    try {
      print("Fetching invites...");
      final uid = _auth.currentUser?.uid;
      if (uid == null) throw Exception("User not logged in");

      final snapshot = await _firestore
          .collection('invites')
          .where('ownerId', isEqualTo: uid) // ✅ filter by ownerId
          .get();

      print("Snapshot has ${snapshot.docs.length} docs");

      invites.assignAll(snapshot.docs.map((doc) {
        final data = doc.data();
        return {
          'id': doc.id,
          'code': data['code'] ?? '',
          'used': data['used'] ?? false,
          'image': 'assets/images/laboursignin.png',
        };
      }).toList());
    } catch (e) {
      CustomSnackbar.show(
        title: "Error",
        message: "Failed to fetch invites: $e",
        isError: true,
      );
      // Get.snackbar("Error", "Failed to load invites: $e");
      // print("Fetch Error: $e");
    }
  }



  Future<void> resetInviteCode(String inviteId) async {
    try {
      final uid = _auth.currentUser?.uid;
      if (uid == null) throw Exception("User not logged in");

      final newCode = _generateRandomCode();

      await _firestore.collection('invites').doc(inviteId).update({
        'code': newCode,
        'used': false,
      });

      await fetchInvites();
      CustomSnackbar.show(
        title: "Success",
        message: "Invite code reset successfully",
        isError: false,
      );
      // Get.snackbar("Success", "Invite code reset successfully");
    } catch (e) {
        CustomSnackbar.show(
          title: "Error",
          message: "Failed to reset code: $e",
          isError: true,
        );
      // Get.snackbar("Error", "Failed to reset code: $e");
    }
  }

  Future<void> deleteInvite(String inviteId) async {
    try {
      final uid = _auth.currentUser?.uid;
      if (uid == null) throw Exception("User not logged in");

      await _firestore.collection('invites').doc(inviteId).delete();

      invites.removeWhere((invite) => invite['id'] == inviteId);
      CustomSnackbar.show(
        title: "Success",
        message: "Invite removed successfully",
        isError: false,
      );
      // Get.snackbar("Deleted", "Invite removed successfully");
    } catch (e) {
      CustomSnackbar.show(
        title: "Error",
        message: "Failed to delete invite: $e",
        isError: true,
      );
      // Get.snackbar("Error", "Failed to delete invite: $e");
    }
  }

  String _generateRandomCode() {
    const chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
    return List.generate(6, (index) => chars[DateTime.now().millisecondsSinceEpoch % chars.length]).join();
  }
}