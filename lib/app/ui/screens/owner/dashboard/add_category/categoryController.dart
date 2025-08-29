import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:salesapp/app/ui/widgets/custom_snackbar.dart';
class AddCategoryController extends GetxController {
  final TextEditingController categoryNameController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  RxBool isLoading = false.obs;
  Future<void> saveCategory() async {
    final name = categoryNameController.text.trim();
    if (name.isEmpty) {
      CustomSnackbar.show(
        title: "Error",
        message: "Please enter category name",
        isError: true,
      );
      return;
    }

    try {
      isLoading.value = true;
      final user = _auth.currentUser;
      if (user == null) {
        CustomSnackbar.show(
          title: "Error",
          message: "No logged-in user found",
          isError: true,
        );
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

      CustomSnackbar.show(
        title: "Success",
        message: "Category '$name' saved",
      );
      categoryNameController.clear();
    } catch (e) {
      CustomSnackbar.show(
        title: "Error",
        message: "Failed to save category: $e",
        isError: true,
      );
    } finally {
      isLoading.value = false;
    }
  }
}
