import 'dart:math';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shoporbit/app/ui/widgets/custom_snackbar.dart';
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
   // debugPrint('Initializing SalesReportController');
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
        // Get.snackbar('Error', 'User not authenticated');
        CustomSnackbar.show(title: 'Error', message: 'User not authenticated');
        return;
      }

      final userId = user.uid;
      debugPrint('Using user ID: $userId');

      // Query sales data
      final salesRef = _firestore
          .collection('users')
          .doc(userId)
          .collection('sales');

     // debugPrint('Querying sales from ${fromDate.value} to ${toDate.value}');

      final querySnapshot = await salesRef
          .where('createdAt', isGreaterThanOrEqualTo: fromDate.value)
          .where('createdAt', isLessThanOrEqualTo: toDate.value)
          .get();

     // debugPrint('Found ${querySnapshot.docs.length} sales records');

      for (var doc in querySnapshot.docs) {
        final data = doc.data();
        //debugPrint('Processing document ${doc.id} with data: $data');

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
    } catch (e) {
      //debugPrint('Error fetching sales: $e');
     // debugPrint('Stack trace: $stackTrace');
      // Get.snackbar('Error', 'Failed to load sales data');
      CustomSnackbar.show(title: "Error", message: "Failed to load sales data");
    } finally {
      isLoading(false);
    }
  }

  void updateFromDate(DateTime newDate) {
  //  debugPrint('Updating fromDate to $newDate');
    fromDate.value = newDate;
    fetchSalesData();
  }

  void updateToDate(DateTime newDate) {
  //  debugPrint('Updating toDate to $newDate');
    toDate.value = newDate;
    fetchSalesData();
  }

  // Helper to format date for display
  String formatDate(DateTime date) {
    return DateFormat('dd, MMMM yyyy').format(date);
  }

  // Get chart data for products
  List<BarData> getProductChartData() {
    //debugPrint('Generating chart data from ${salesData.length} sales');
    final productMap = <String, double>{};

    for (var sale in salesData) {
      try {
        final items = List<Map<String, dynamic>>.from(sale['items'] ?? []);
        //debugPrint('Processing ${items.length} items for chart');

        for (var item in items) {
          final productName = item['title'] ?? 'Unknown';
          final value = (item['price'] ?? 0).toDouble() * (item['quantity'] ?? 1);
          productMap[productName] = (productMap[productName] ?? 0) + value;
       //   debugPrint('Added $productName with value $value');
        }
      } catch (e) {
        debugPrint('Error processing sale for chart: $e');
      }
    }

    //debugPrint('Chart data generated with ${productMap.length} products');
    return productMap.entries
        .map((e) => BarData(label: e.key, value: e.value))
        .toList();
  }

  // Add this method to your SalesReportController
  List<double> getYAxisSteps() {
    final maxValue = getMaxChartValue();

    // If no data, return default steps
    if (maxValue <= 0) return [0, 2, 4, 6, 8];

    // Calculate appropriate number of steps (4-6 is ideal)
    int numberOfSteps = 5;
    double rawStepSize = maxValue / numberOfSteps;

    // Round to a "nice" interval
    double magnitude = pow(10, (log(rawStepSize) / ln10).floor()).toDouble();
    double residual = rawStepSize / magnitude;
    double stepSize;

    if (residual > 5) {
      stepSize = 10 * magnitude;
    } else if (residual > 2) {
      stepSize = 5 * magnitude;
    } else if (residual > 1) {
      stepSize = 2 * magnitude;
    } else {
      stepSize = magnitude;
    }

    // Generate steps
    final steps = <double>[];
    for (double value = 0; value <= maxValue * 1.05; value += stepSize) {
      steps.add(value);
    }

    return steps;
  }

// Update getMaxChartValue to ensure proper scaling
  double getMaxChartValue() {
    final chartData = getProductChartData();
    if (chartData.isEmpty) return 8;

    final maxDataValue = chartData.map((e) => e.value).reduce((a, b) => a > b ? a : b);

    // Handle very large values with logarithmic approach if needed
    if (maxDataValue > 1000000) {
      return (maxDataValue * 1.1); // Let the formatting handle the display
    }

    // Existing logic for smaller values
    double maxValue;
    if (maxDataValue <= 10) {
      maxValue = maxDataValue.ceilToDouble();
    } else if (maxDataValue <= 100) {
      maxValue = (maxDataValue / 10).ceilToDouble() * 10;
    } else if (maxDataValue <= 1000) {
      maxValue = (maxDataValue / 100).ceilToDouble() * 100;
    } else {
      maxValue = (maxDataValue / 1000).ceilToDouble() * 1000;
    }

    return maxValue * 1.1;
  }

  Map<String, Map<String, dynamic>> getProductSummaryData() {
    final productSummary = <String, Map<String, dynamic>>{};

    for (var sale in salesData) {
      final items = List<Map<String, dynamic>>.from(sale['items'] ?? []);

      for (var item in items) {
        final productName = item['title'] ?? 'Unknown';
        final imagePath = item['imagePath'] ?? 'assets/images/products.png';
        final quantity = (item['quantity'] ?? 0) as int;
        final price = (item['price'] ?? 0).toDouble(); // sale price per unit
        final intakePrice = (item['originalPrice'] ?? 0).toDouble(); // cost per unit

        final totalSaleAmount = price * quantity;
        final totalIntakeAmount = intakePrice * quantity;

        if (!productSummary.containsKey(productName)) {
          productSummary[productName] = {
            'imagePath': imagePath,
            'totalSales': 0.0,
            'totalQuantity': 0,
            'totalIntake': 0.0,
          };
        }

        productSummary[productName]!['totalSales'] += totalSaleAmount;
        productSummary[productName]!['totalQuantity'] += quantity;
        productSummary[productName]!['totalIntake'] += totalIntakeAmount;
      }
    }

    return productSummary;
  }

}