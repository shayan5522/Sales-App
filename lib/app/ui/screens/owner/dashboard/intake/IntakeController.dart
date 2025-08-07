import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

class IntakeController extends GetxController {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// Add a new intake
  Future<void> saveIntake(List<Map<String, dynamic>> cart) async {
    try {
      final uid = _auth.currentUser!.uid;

      final intakeRef = _firestore
          .collection('users')
          .doc(uid)
          .collection('intakes')
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

      final intakeData = {
        'id': intakeRef.id,
        'totalAmount': totalAmount,
        'createdAt': FieldValue.serverTimestamp(),
        'items': items,
      };

      await intakeRef.set(intakeData);
      Get.snackbar('Success', 'Intake saved successfully');
    } catch (e) {
      Get.snackbar('Error', 'Failed to save intake: $e');
    }
  }
}
