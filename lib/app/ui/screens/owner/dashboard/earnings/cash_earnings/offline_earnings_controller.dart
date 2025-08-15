import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

import '../../../../../widgets/custom_snackbar.dart';

class OfflineEarningsController extends GetxController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  RxDouble totalSales = 0.0.obs;
  RxDouble totalProfit = 0.0.obs;
  RxList<Map<String, dynamic>> transactions = <Map<String, dynamic>>[].obs;
  RxBool isLoading = false.obs;
  Rx<DateTime> fromDate = DateTime.now().obs;
  Rx<DateTime> toDate = DateTime.now().obs;

  @override
  void onInit() {
    super.onInit();
    // Initialize with today's date
    fromDate.value = DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);
    toDate.value = DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day, 23, 59, 59);
    fetchOfflineEarnings();
  }

  void updateDateRange(DateTime newFromDate, DateTime newToDate) {
    fromDate.value = newFromDate;
    toDate.value = newToDate;
    fetchOfflineEarnings();
  }

  Future<void> fetchOfflineEarnings() async {
    try {
      isLoading.value = true;
      transactions.clear();
      totalSales.value = 0.0;
      totalProfit.value = 0.0;

      final uid = _auth.currentUser?.uid;
      if (uid == null) return;

      // First get all cash sales (without date filtering)
      final snapshot = await _firestore
          .collection('users')
          .doc(uid)
          .collection('sales')
          .where('paymentType', isEqualTo: 'Cash')
          .get();

      // Process all documents and filter locally
      for (var doc in snapshot.docs) {
        final data = doc.data();
        final createdAt = (data['createdAt'] as Timestamp?)?.toDate();

        // Skip if no createdAt date or outside our date range
        if (createdAt == null ||
            createdAt.isBefore(fromDate.value) ||
            createdAt.isAfter(toDate.value)) {
          continue;
        }

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

      // Sort transactions by date (newest first)
      transactions.sort((a, b) {
        final aDate = (a['createdAt'] as Timestamp).toDate();
        final bDate = (b['createdAt'] as Timestamp).toDate();
        return bDate.compareTo(aDate);
      });

    } catch (e) {
      CustomSnackbar.show(title: 'Error', message: 'Failed to fetch Cash earnings. Try Again Later');
    } finally {
      isLoading.value = false;
    }
  }
}