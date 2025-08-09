import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

class SalesController extends GetxController {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> saveSale(List<Map<String, dynamic>> cart) async {
    try {
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
        'createdAt': FieldValue.serverTimestamp(),
        'items': items,
      };

      await salesRef.set(salesData);
      Get.snackbar('Success', 'Sales saved successfully');
    } catch (e) {
      Get.snackbar('Error', 'Failed to save Sales: $e');
    }
  }
}