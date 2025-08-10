import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

import '../../../../widgets/custom_snackbar.dart';

class SalesController extends GetxController {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final isLoading = true.obs;

  Future<void> saveSale(List<Map<String, dynamic>> cart, String paymentType) async {
    try {
      isLoading.value = true;
      final uid = _auth.currentUser!.uid;

      final salesRef = _firestore
          .collection('users')
          .doc(uid)
          .collection('sales')
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
          'originalPrice': item['originalPrice'], // Store original price
          'discount': item.containsKey('discount') ? item['discount'] : 0.0,
        };
      }).toList();

      final salesData = {
        'id': salesRef.id,
        'totalAmount': totalAmount,
        'paymentType': paymentType, // Added payment type
        'createdAt': FieldValue.serverTimestamp(),
        'items': items,
      };

      await salesRef.set(salesData);
      CustomSnackbar.show(
        title: "Success",
        message: "Sales saved successfully",
        isError: false,
      );
    } catch (e) {
      CustomSnackbar.show(
        title: "Error",
        message: "Failed to save Sales: $e",
        isError: true,
      );
    }
    finally{
      isLoading.value = false;
    }
  }
}