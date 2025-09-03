import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';
import '../../../../widgets/chart.dart';
import '../../../../widgets/custom_snackbar.dart';
import 'low_stock_controller.dart';

class StockReportController extends GetxController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  var isLoading = false.obs;
  var fromDate = DateTime.now().subtract(const Duration(days: 30)).obs;
  var toDate = DateTime.now().obs;

  var stockList = <Map<String, dynamic>>[].obs;
  var totalItems = 0.obs;
  var totalValue = 0.0.obs;

  @override
  void onInit() {
    super.onInit();
    loadStockData(); // Changed from fetchStockData() to loadStockData()
  }

  Future<void> fetchStockData() async {
    try {
      isLoading(true);
      stockList.clear();
      totalItems.value = 0;
      totalValue.value = 0.0;

      final user = _auth.currentUser;
      if (user == null) {
        CustomSnackbar.show(title: 'Error', message: 'User not authenticated');
        return;
      }
      final userId = user.uid;

      /// ---- Fetch Purchases (Intakes) ----
      final intakeSnapshot = await _firestore
          .collection('users')
          .doc(userId)
          .collection('intakes')
          .where('createdAt', isGreaterThanOrEqualTo: fromDate.value)
          .where('createdAt', isLessThanOrEqualTo: toDate.value)
          .get();

      final Map<String, Map<String, dynamic>> productMap = {};

      for (var doc in intakeSnapshot.docs) {
        final items = List<Map<String, dynamic>>.from(doc['items'] ?? []);
        for (var item in items) {
          final name = item['title'] ?? 'Unknown';
          if (!productMap.containsKey(name)) {
            productMap[name] = {
              'title': name,
              'imagePath': item['imagePath'] ?? '',
              'purchaseQty': 0,
              'soldQty': 0,
              'price': (item['price'] ?? 0).toDouble(),
            };
          }
          productMap[name]!['purchaseQty'] += (item['quantity'] ?? 0);
        }
      }

      /// ---- Fetch Sales ----
      final salesSnapshot = await _firestore
          .collection('users')
          .doc(userId)
          .collection('sales')
          .where('createdAt', isGreaterThanOrEqualTo: fromDate.value)
          .where('createdAt', isLessThanOrEqualTo: toDate.value)
          .get();

      for (var doc in salesSnapshot.docs) {
        final items = List<Map<String, dynamic>>.from(doc['items'] ?? []);
        for (var item in items) {
          final name = item['title'] ?? 'Unknown';
          if (!productMap.containsKey(name)) {
            productMap[name] = {
              'title': name,
              'imagePath': item['imagePath'] ?? '',
              'purchaseQty': 0,
              'soldQty': 0,
              'price': (item['originalPrice'] ?? item['price'] ?? 0).toDouble(),
            };
          }
          productMap[name]!['soldQty'] += (item['quantity'] ?? 0);
        }
      }

      /// ---- Calculate Stock ----
      final List<Map<String, dynamic>> tempStockList = [];
      int tempTotalItems = 0;
      double tempTotalValue = 0.0;

      for (var entry in productMap.values) {
        final currentStock = ((entry['purchaseQty'] ?? 0) as int) -
            ((entry['soldQty'] ?? 0) as int);
        final value = currentStock * ((entry['price'] ?? 0.0) as double);

        tempStockList.add({
          ...entry,
          'currentStock': currentStock,
          'totalValue': value,
        });

        tempTotalItems += currentStock;
        tempTotalValue += value;
      }

      tempStockList.sort((a, b) => b['currentStock'].compareTo(a['currentStock']));

      // Assign the values after all calculations
      stockList.assignAll(tempStockList);
      totalItems.value = tempTotalItems;
      totalValue.value = tempTotalValue;

    } catch (e) {
      CustomSnackbar.show(title: 'Error', message: e.toString());
    } finally {
      isLoading(false);
    }
  }

  void updateFromDate(DateTime date) {
    fromDate.value = date;
    loadStockData(); // Changed from fetchStockData() to loadStockData()
  }

  void updateToDate(DateTime date) {
    toDate.value = date;
    loadStockData(); // Changed from fetchStockData() to loadStockData()
  }

  String formatDate(DateTime date) {
    return DateFormat('dd MMM yyyy').format(date);
  }

  List<BarData> getProductChartData() {
    return stockList
        .map((p) => BarData(
      label: p['title'],
      value: (p['currentStock'] * (p['price'] ?? 0.0)).toDouble(),
    ))
        .toList();
  }

  double getMaxChartValue() {
    if (stockList.isEmpty) return 1000;
    return stockList
        .map((p) => (p['currentStock'] * (p['price'] ?? 0.0)).toDouble())
        .reduce((a, b) => a > b ? a : b) *
        1.2;
  }

  List<double> getYAxisSteps() {
    final maxValue = getMaxChartValue();
    if (maxValue <= 0) return [0, 200, 400, 600, 800];
    final step = maxValue / 4;
    return List.generate(5, (i) => step * i);
  }

  // Add this method to check for low stock
  void checkLowStock() {
    final lowStockController = Get.find<LowStockController>();
    final lowStockProducts = stockList.where((product) {
      return lowStockController.isLowStock(product['currentStock'] ?? 0);
    }).toList();

    if (lowStockProducts.isNotEmpty) {
      // Show notification only once when the page loads
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Get.snackbar(
          "Low Stock Alert",
          "${lowStockProducts.length} product(s) are below the threshold",
          backgroundColor: Colors.orange,
          colorText: Colors.white,
          duration: const Duration(seconds: 5),
          isDismissible: true,
          mainButton: TextButton(
            onPressed: () {
              Get.back(); // Close the snackbar
            },
            child: const Text("Dismiss", style: TextStyle(color: Colors.white)),
          ),
        );
      });
    }
  }

  // Modified loadStockData method
  Future<void> loadStockData() async {
    isLoading.value = true;
    try {
      // Call fetchStockData which handles the data loading
      await fetchStockData();

      // Check for low stock after loading
      checkLowStock();
    } catch (e) {
      CustomSnackbar.show(title: 'Error', message: 'Failed to load stock data: ${e.toString()}');
    } finally {
      isLoading.value = false;
    }
  }
}