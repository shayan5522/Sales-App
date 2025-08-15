import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

class OnlineEarningsController extends GetxController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  RxDouble totalSales = 0.0.obs;
  RxDouble totalProfit = 0.0.obs;
  RxList<Map<String, dynamic>> transactions = <Map<String, dynamic>>[].obs;
  RxBool isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    fetchOnlineEarnings();
  }

  Future<void> fetchOnlineEarnings() async {
    try {
      isLoading.value = true;
      transactions.clear();
      totalSales.value = 0.0;
      totalProfit.value = 0.0;

      final uid = _auth.currentUser?.uid;
      if (uid == null) return;

      final snapshot = await _firestore
          .collection('users')
          .doc(uid)
          .collection('sales')
          .where('paymentType', isEqualTo: 'Online')
          .get();

      for (var doc in snapshot.docs) {
        final data = doc.data();
        final amount = (data['totalAmount'] ?? 0).toDouble();
        totalSales.value += amount;

        // Calculate profit from items
        double saleProfit = 0.0;
        final items = data['items'] as List? ?? [];

        for (var item in items.cast<Map<String, dynamic>>()) {
          final originalPrice = (item['originalPrice'] ?? 0).toDouble();
          final salePrice = (item['price'] ?? 0).toDouble();
          final quantity = (item['quantity'] ?? 0).toInt();
          final discount = (item['discount'] ?? 0).toDouble();

          // Calculate profit considering discount
          saleProfit += ((salePrice - discount) - originalPrice) * quantity;
        }

        totalProfit.value += saleProfit;

        transactions.add({
          'id': doc.id,
          'amount': amount,
          'profit': saleProfit,
          'items': items,
          'createdAt': data['createdAt'],
        });
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to fetch online earnings: $e');
    } finally {
      isLoading.value = false;
    }
  }
}