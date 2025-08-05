import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ExpenseController extends GetxController {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore  = FirebaseFirestore.instance;

  final TextEditingController nameController = TextEditingController();
  final TextEditingController amountController = TextEditingController();
  final TextEditingController descController = TextEditingController();

  final RxList<String> categoryList = <String>[].obs;
  final RxBool isLoading = false.obs;

  RxnString selectedCategory = RxnString();

  @override
  void onInit() {
    super.onInit();
    fetchCategories();
  }

  /// 🔹 Fetch user's categories from Firestore
  Future<void> fetchCategories() async {
    try {
      final user = _auth.currentUser;
      if (user == null) return;

      final snapshot = await _firestore
          .collection('users')
          .doc(user.uid)
          .collection('categories')
          .get();

      categoryList.assignAll(
        snapshot.docs.map((doc) => doc['name'].toString()).toList(),
      );
    } catch (e) {
      Get.snackbar("Error", "Failed to load categories: $e");
    }
  }

  /// 🔹 Save expense to user's Firestore
  Future<void> saveExpense() async {
    final name = nameController.text.trim();
    final amount = amountController.text.trim();
    final desc = descController.text.trim();
    final category = selectedCategory.value;

    if (name.isEmpty || amount.isEmpty || category == null) {
      Get.snackbar("Validation", "Please fill all required fields");
      return;
    }

    try {
      isLoading.value = true;
      final user = _auth.currentUser;
      if (user == null) return;

      await _firestore
          .collection('users')
          .doc(user.uid)
          .collection('expenses')
          .add({
        "name": name,
        "amount": double.tryParse(amount) ?? 0.0,
        "description": desc,
        "category": category,
        "createdAt": FieldValue.serverTimestamp(),
      });

      Get.snackbar("Success", "Expense saved successfully");

      // Clear form fields
      nameController.clear();
      amountController.clear();
      descController.clear();
      selectedCategory.value = null;
    } catch (e) {
      Get.snackbar("Error", "Failed to save expense: $e");
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void onClose() {
    nameController.dispose();
    amountController.dispose();
    descController.dispose();
    super.onClose();
  }
}
