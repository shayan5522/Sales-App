import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

import '../../../../widgets/custom_snackbar.dart';

class ReturnProductController extends GetxController {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> returnProduct(List<Map<String, dynamic>> cart) async {
  try {
  final uid = _auth.currentUser!.uid;
  final batch = _firestore.batch();

  // 1. Create the return document
  final returnRef = _firestore
      .collection('users')
      .doc(uid)
      .collection('returns')
      .doc();

  double totalAmount = 0.0;
  final List<Map<String, dynamic>> items = [];

  // 2. Process each item in the return
  for (var item in cart) {
  final double price = (item['price'] as num).toDouble();
  final int quantity = (item['quantity'] as num).toInt();

  totalAmount += price * quantity;

  items.add({
  'title': item['title'],
  'price': price,
  'quantity': quantity,
  'imagePath': item['imagePath'],
  // No need for productId since we're not updating product documents
  });

  // 3. Create a compensating intake record (negative quantity)
  final intakeRef = _firestore
      .collection('users')
      .doc(uid)
      .collection('intakes')
      .doc();

  batch.set(intakeRef, {
  'createdAt': FieldValue.serverTimestamp(),
  'items': [{
  'title': item['title'],
  'price': price,
  'quantity': -quantity, // Negative quantity for return
  'imagePath': item['imagePath'],
  }],
  'totalAmount': -totalAmount, // Negative amount for return
  });
  }

  // 4. Create the return record
  batch.set(returnRef, {
  'id': returnRef.id,
  'totalAmount': totalAmount,
  'createdAt': FieldValue.serverTimestamp(),
  'items': items,
  });

  await batch.commit();

  CustomSnackbar.show(
  title: "Success",
  message: "Return processed successfully"
  );
  } catch (e) {
  CustomSnackbar.show(
  title: "Error",
  message: "Failed to process return: $e",
  isError: true
  );
  print("Error details: $e");
  }
  }

  /// Helper function to calculate current stock for a product
  Future<int> getCurrentStock(String productTitle) async {
  final uid = _auth.currentUser!.uid;

  // Get all intake records for this product
  final intakeSnapshot = await _firestore
      .collection('users')
      .doc(uid)
      .collection('intakes')
      .where('items', arrayContainsAny: [
  {'title': productTitle}
  ])
      .get();

  int totalStock = 0;

  for (var doc in intakeSnapshot.docs) {
  final items = doc['items'] as List;
  for (var item in items.cast<Map<String, dynamic>>()) {
  if (item['title'] == productTitle) {
  totalStock += (item['quantity'] as num).toInt();
  }
  }
  }

  return totalStock;
  }
  }