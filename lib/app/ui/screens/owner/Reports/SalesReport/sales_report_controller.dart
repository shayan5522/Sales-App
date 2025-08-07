import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../../../widgets/chart.dart';

class SalesReportController extends GetxController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Reactive variables
  var isLoading = false.obs;
  var salesData = <Map<String, dynamic>>[].obs;
  var totalAmount = 0.0.obs;
  var totalItemsSold = 0.obs;

  // Date range for filtering
  var fromDate = DateTime.now().subtract(const Duration(days: 30)).obs;
  var toDate = DateTime.now().obs;

  @override
  void onInit() {
    super.onInit();
    debugPrint('Initializing SalesReportController');
    fetchSalesData();
  }

  Future<void> fetchSalesData() async {
    try {
      isLoading(true);
      salesData.clear();
      totalAmount.value = 0;
      totalItemsSold.value = 0;

      // Get current authenticated user
      final user = _auth.currentUser;
      if (user == null) {
        debugPrint('No authenticated user found');
        Get.snackbar('Error', 'User not authenticated');
        return;
      }

      final userId = user.uid;
      debugPrint('Using user ID: $userId');

      // Query sales data
      final salesRef = _firestore
          .collection('users')
          .doc(userId)
          .collection('sales');

      debugPrint('Querying sales from ${fromDate.value} to ${toDate.value}');

      final querySnapshot = await salesRef
          .where('createdAt', isGreaterThanOrEqualTo: fromDate.value)
          .where('createdAt', isLessThanOrEqualTo: toDate.value)
          .get();

      debugPrint('Found ${querySnapshot.docs.length} sales records');

      for (var doc in querySnapshot.docs) {
        final data = doc.data();
        debugPrint('Processing document ${doc.id} with data: $data');

        if (data.containsKey('items') && data['items'] is List) {
          final items = List<Map<String, dynamic>>.from(data['items']);
          final total = (data['totalAmount'] ?? 0).toDouble();

          salesData.add({
            'id': doc.id,
            'createdAt': (data['createdAt'] as Timestamp).toDate(),
            'items': items,
            'totalAmount': total,
          });

          totalAmount.value += total;
          totalItemsSold.value += items.fold<int>(0, (sum, item) =>
          sum + ((item['quantity'] as int?) ?? 0));
        }
      }

      salesData.sort((a, b) => (b['createdAt'] as DateTime).compareTo(a['createdAt'] as DateTime));
    } catch (e, stackTrace) {
      debugPrint('Error fetching sales: $e');
      debugPrint('Stack trace: $stackTrace');
      Get.snackbar('Error', 'Failed to load sales data');
    } finally {
      isLoading(false);
    }
  }

  void updateFromDate(DateTime newDate) {
    debugPrint('Updating fromDate to $newDate');
    fromDate.value = newDate;
    fetchSalesData();
  }

  void updateToDate(DateTime newDate) {
    debugPrint('Updating toDate to $newDate');
    toDate.value = newDate;
    fetchSalesData();
  }

  // Helper to format date for display
  String formatDate(DateTime date) {
    return DateFormat('dd, MMMM yyyy').format(date);
  }

  // Get chart data for products
  List<BarData> getProductChartData() {
    debugPrint('Generating chart data from ${salesData.length} sales');
    final productMap = <String, double>{};

    for (var sale in salesData) {
      try {
        final items = List<Map<String, dynamic>>.from(sale['items'] ?? []);
        debugPrint('Processing ${items.length} items for chart');

        for (var item in items) {
          final productName = item['title'] ?? 'Unknown';
          final value = (item['price'] ?? 0).toDouble() * (item['quantity'] ?? 1);
          productMap[productName] = (productMap[productName] ?? 0) + value;
          debugPrint('Added $productName with value $value');
        }
      } catch (e) {
        debugPrint('Error processing sale for chart: $e');
      }
    }

    debugPrint('Chart data generated with ${productMap.length} products');
    return productMap.entries
        .map((e) => BarData(label: e.key, value: e.value))
        .toList();
  }

  // Get max Y value for chart
  double getMaxChartValue() {
    final chartData = getProductChartData();
    if (chartData.isEmpty) {
      debugPrint('No chart data, returning default max value');
      return 8000; // default
    }
    final maxValue = chartData.map((e) => e.value).reduce((a, b) => a > b ? a : b) * 1.2;
    debugPrint('Calculated max chart value: $maxValue');
    return maxValue;
  }
}