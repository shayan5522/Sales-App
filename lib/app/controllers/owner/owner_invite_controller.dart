import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class OwnerInviteController extends GetxController {
  final RxList<Map<String, dynamic>> invites = <Map<String, dynamic>>[].obs;

  @override
  void onInit() {
    fetchInvites();
    super.onInit();
  }

  void fetchInvites() async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) return;

    final query = await FirebaseFirestore.instance
        .collection('invites')
        .where('ownerId', isEqualTo: uid)
        .get();

    // ✅ Explicit cast to Map<String, dynamic>
    invites.value = query.docs.map((doc) => doc.data() as Map<String, dynamic>).toList();
  }
}
