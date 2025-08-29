import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

import '../../../../widgets/custom_snackbar.dart';

class TransactionController extends GetxController {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> addTransaction({
    required String name,
    required String detail,
    required double price,
    required DateTime date,
    required bool isCredit, // true = credit, false = debit
  }) async {
    try {
      final uid = _auth.currentUser!.uid;
      final data = {
        'name': name,
        'detail': detail,
        'price': price,
        'date': Timestamp.fromDate(date),
        'createdAt': FieldValue.serverTimestamp(),
      };

      final collectionName = isCredit ? 'credits' : 'debits';

      await _firestore
          .collection('users')
          .doc(uid)
          .collection(collectionName)
          .add(data);

      // Get.snackbar('Success', '${isCredit ? "Credit" : "Debit"} added!');
      CustomSnackbar.show(
        title: "Success",
        message: "${isCredit ? "Credit" : "Debit"} added!",
      );
    } catch (e) {
      CustomSnackbar.show(
        title: "Error",
        message: "Failed to add transaction: $e",
        isError: true,
      );
      // Get.snackbar('Error', 'Failed to add transaction: $e');
    }
  }
}
