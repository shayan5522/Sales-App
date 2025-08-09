import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

import '../../../../widgets/custom_snackbar.dart';

class ReturnProductController extends GetxController {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// Add a new intake
  Future<void> returnProduct(List<Map<String, dynamic>> cart) async {
    try {
      final uid = _auth.currentUser!.uid;

      final returnRef = _firestore
          .collection('users')
          .doc(uid)
          .collection('returns')
          .doc(); // auto-generated ID

      double totalAmount = 0.0;

      // Build and sanitize items list
      final List<Map<String, dynamic>> items = cart.map((item) {
        final double price = (item['price'] as num).toDouble();
        final int quantity = (item['quantity'] as num).toInt();

        totalAmount += price * quantity;

        return {
          'title': item['title'],
          'price': price,
          'quantity': quantity,
          'imagePath': item['imagePath'],
        };
      }).toList();

      final returnData = {
        'id': returnRef.id,
        'totalAmount': totalAmount,
        'createdAt': FieldValue.serverTimestamp(),
        'items': items,
      };

      await returnRef.set(returnData);
      CustomSnackbar.show(title: "Success", message: "Return product saved successfully");
    } catch (e) {
      CustomSnackbar.show(title: "Error", message: "Failed to save Return product: $e", isError: true);
    }
  }
}
