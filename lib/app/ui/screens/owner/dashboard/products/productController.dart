import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:salesapp/app/ui/widgets/custom_snackbar.dart';

class ProductController extends GetxController {
  RxList<Map<String, dynamic>> products = <Map<String, dynamic>>[].obs;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final isLoading = true.obs;

  /// 🔹 Add a new product to Firestore
  Future<void> addProduct({
    required String title,
    required double price,
    File? imageFile,
  }) async {
    try {
      final uid = _auth.currentUser!.uid;

      // 🔸 Upload image if provided
      String imageUrl = 'assets/images/products.png';
      if (imageFile != null) {
        final ref = FirebaseStorage.instance
            .ref()
            .child('product_images')
            .child('$uid/${DateTime.now().millisecondsSinceEpoch}.jpg');

        await ref.putFile(imageFile);
        imageUrl = await ref.getDownloadURL();
      }

      // 🔸 Generate new doc reference to get ID
      final docRef = _firestore
          .collection('users')
          .doc(uid)
          .collection('products')
          .doc();

      final productData = {
        'id': docRef.id,
        'title': title,
        'price': price,
        'imagePath': imageUrl,
        'createdAt': FieldValue.serverTimestamp(),
      };

      // 🔸 Save product to Firestore
      await docRef.set(productData);

      await fetchProducts(); // Refresh list
    } catch (e) {
      CustomSnackbar.show(title: "Error", message: "Failed to add product: $e");
    }
  }

  /// 🔹 Fetch all products for the current user
  Future<void> fetchProducts() async {
    try {
      isLoading.value = true;
      final uid = _auth.currentUser!.uid;

      final snapshot = await _firestore
          .collection('users')
          .doc(uid)
          .collection('products')
          .orderBy('createdAt', descending: true)
          .get();

      final productList = snapshot.docs.map((doc) {
        final data = doc.data();
        return {
          'id': doc.id,
          'title': data['title'] ?? '',
          'price': data['price'] ?? 0,
          'imagePath': data['imagePath'] ?? 'assets/images/products.png',
        };
      }).toList();

      products.assignAll(productList);
    } catch (e) {
      CustomSnackbar.show(title: "Error", message: "Failed to fetch products: $e", isError: true);
    }finally {
      isLoading.value = false;
    }
  }

  /// 🔹 Delete a product by its document ID
  Future<void> deleteProduct(String productId) async {
    try {
      final uid = _auth.currentUser!.uid;

      await _firestore
          .collection('users')
          .doc(uid)
          .collection('products')
          .doc(productId)
          .delete();

      await fetchProducts(); // Refresh list
    } catch (e) {
      CustomSnackbar.show(title: "Error", message: "Failed to delete product: $e", isError: true);
    }
  }
}
