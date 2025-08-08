import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

class SalesController extends GetxController {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> saveSale(List<Map<String, dynamic>> cart) async {
    try {
      final uid = _auth.currentUser!.uid;
      final saleRef = _firestore.collection('users').doc(uid).collection('sales').doc();

      double totalAmount = 0.0;
      final items = cart.map((item) {
        final price = (item['price'] as num).toDouble();
        final quantity = (item['quantity'] as num).toInt();
        totalAmount += price * quantity;
        return {
          'title': item['title'],
          'price': price,
          'quantity': quantity,
          'imagePath': item['imagePath'],
        };
      }).toList();

      final saleData = {
        'id': saleRef.id,
        'totalAmount': totalAmount,
        'createdAt': FieldValue.serverTimestamp(),
        'items': items,
      };
      await saleRef.set(saleData);
      Get.snackbar('Success', 'Sale saved successfully');
    } catch (e) {
      Get.snackbar('Error', 'Failed to save sale: $e');
    }
  }
}
