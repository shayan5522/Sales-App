import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

class ReturnReportController extends GetxController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  RxList<Map<String, dynamic>> transactions = <Map<String, dynamic>>[].obs;
  RxDouble totalIncome = 0.0.obs;
  RxDouble totalProfit = 0.0.obs;
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
      totalIncome.value = 0.0;
      totalProfit.value = 0.0;

      final usersSnapshot = await _firestore.collection('users').get();

      for (final userDoc in usersSnapshot.docs) {
        final returnsSnapshot = await _firestore
            .collection('users')
            .doc(userDoc.id)
            .collection('returns')
            .get();

        for (final returnDoc in returnsSnapshot.docs) {
          final data = returnDoc.data();
          final Timestamp? timestamp = data['createdAt'];

          if (timestamp == null) continue;

          final DateTime returnDate = timestamp.toDate();

          if (returnDate.isBefore(fromDate) || returnDate.isAfter(toDate)) {
            continue;
          }

          final List<dynamic> items = data['items'] ?? [];
          for (final item in items) {
            final String productTitle = item['title'] ?? 'Unknown';
            final double price = (item['price'] ?? 0) is num
                ? (item['price'] as num).toDouble()
                : 0.0;

            transactions.add({
              'product': productTitle,
              'amount': price,
            });

            totalIncome.value += price;
            totalProfit.value += price;
          }
        }
      }
    } catch (e) {
      print('Error fetching return reports: $e');
    } finally {
      isLoading.value = false;
    }
  }

}


