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

      final totalAmount = cart.fold<double>(
        0.0,
            (sum, item) => sum + ((item['price'] ?? 0) * (item['quantity'] ?? 0)),
      );
    print(totalAmount);
      final intakeData = {
        'id': intakeRef.id,
        'totalAmount': totalAmount,
        'createdAt': FieldValue.serverTimestamp(),
        'items': cart.map((item) {
          return {
            'title': item['title'],
            'price': item['price'],
            'quantity': item['quantity'],
            'imagePath': item['imagePath'],
          };
        }).toList(),
      };
print(intakeData);
      await intakeRef.set(intakeData);
      Get.snackbar('Success', 'Intake saved successfully');
    } catch (e) {
      Get.snackbar('Error', 'Failed to save intake: $e');
    }
  }
}
