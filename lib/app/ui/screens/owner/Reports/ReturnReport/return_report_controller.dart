import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

class ReturnReportController extends GetxController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  RxList<Map<String, dynamic>> transactions = <Map<String, dynamic>>[].obs;
  RxDouble totalReturnAmount = 0.0.obs;
  RxInt totalReturnCount = 0.obs; // New count variable
  RxBool isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    final now = DateTime.now();

    fetchReturnReports(
      fromDate: DateTime(now.year, now.month, now.day, 0, 0, 0),
      toDate: DateTime(now.year, now.month, now.day, 23, 59, 59),
    );
  }

  Future<void> fetchReturnReports({
    required DateTime fromDate,
    required DateTime toDate,
  }) async {
    try {
      isLoading.value = true;
      transactions.clear();
      totalReturnAmount.value = 0.0;
      totalReturnCount.value = 0;

      // Get current user ID
      final currentUser = _auth.currentUser;
      if (currentUser == null) {
        print('No user logged in');
        return;
      }

      final userId = currentUser.uid;

      // Only fetch returns for the current user
      final returnsSnapshot = await _firestore
          .collection('users')
          .doc(userId)  // Use current user's ID
          .collection('returns')
          .where('createdAt', isGreaterThanOrEqualTo: fromDate)
          .where('createdAt', isLessThanOrEqualTo: toDate)
          .get();

      totalReturnCount.value = returnsSnapshot.docs.length;

      for (final returnDoc in returnsSnapshot.docs) {
        final data = returnDoc.data();
        final totalAmount = (data['totalAmount'] ?? 0) is num
            ? (data['totalAmount'] as num).toDouble()
            : 0.0;

        totalReturnAmount.value += totalAmount;

        final List<dynamic> items = data['items'] ?? [];
        for (final item in items) {
          transactions.add({
            'product': item['title'] ?? 'Unknown',
            'amount': (item['price'] ?? 0) is num
                ? (item['price'] as num).toDouble()
                : 0.0,
            'quantity': (item['quantity'] ?? 0) is num
                ? (item['quantity'] as num).toInt()
                : 0,
          });
        }
      }
    } catch (e) {
      print('Error fetching return reports: $e');
    } finally {
      isLoading.value = false;
    }
  }
}