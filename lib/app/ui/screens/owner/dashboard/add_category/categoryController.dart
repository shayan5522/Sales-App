import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AddCategoryController extends GetxController {
  final TextEditingController categoryNameController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  RxBool isLoading = false.obs;

  Future<void> saveCategory() async {
    final name = categoryNameController.text.trim();
    if (name.isEmpty) {
      Get.snackbar("Error", "Please enter category name",
          snackPosition: SnackPosition.BOTTOM);
      return;
    }

    try {
      isLoading.value = true;
      final user = _auth.currentUser;
      if (user == null) {
        Get.snackbar("Error", "No logged-in user found",
            snackPosition: SnackPosition.BOTTOM);
        return;
      }

      final uid = user.uid;

      await _firestore
          .collection("users")
          .doc(uid)
          .collection("categories")
          .add({
        "name": name,
        "createdAt": FieldValue.serverTimestamp(),
      });

      Get.snackbar("Success", "Category '$name' saved",
          snackPosition: SnackPosition.BOTTOM);

      categoryNameController.clear();
    } catch (e) {
      Get.snackbar("Error", "Failed to save category: $e",
          snackPosition: SnackPosition.BOTTOM);
    } finally {
      isLoading.value = false;
    }
  }
}
