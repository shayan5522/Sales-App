import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../../../widgets/chart.dart';
import '../../../../widgets/chart_formatter.dart';
import '../../../../widgets/custom_snackbar.dart';

class IntakeReportController extends GetxController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Reactive variables
  var isLoading = false.obs;
  var intakeData = <Map<String, dynamic>>[].obs;
  var totalExpense = 0.0.obs;
  var totalItemsIntaken = 0.obs;

  // Date range for filtering
  var fromDate = DateTime.now().subtract(const Duration(days: 30)).obs;
  var toDate = DateTime.now().obs;

  @override
  void onInit() {
    super.onInit();
    debugPrint('Initializing IntakeReportController');
    fetchIntakeData();
  }

  Future<void> fetchIntakeData() async {
    try {
      isLoading(true);
      intakeData.clear();
      totalExpense.value = 0;
      totalItemsIntaken.value = 0;

      // Get current authenticated user
      final user = _auth.currentUser;
      if (user == null) {
        debugPrint('No authenticated user found');
        CustomSnackbar.show(title: 'Error', message: 'User not authenticated');
        return;
      }

      final userId = user.uid;
      debugPrint('Using user ID: $userId');

      // Query intake data
      final intakeRef = _firestore
          .collection('users')
          .doc(userId)
          .collection('intakes');

      debugPrint('Querying intakes from ${fromDate.value} to ${toDate.value}');

      final querySnapshot = await intakeRef
          .where('createdAt', isGreaterThanOrEqualTo: fromDate.value)
          .where('createdAt', isLessThanOrEqualTo: toDate.value)
          .get();

      debugPrint('Found ${querySnapshot.docs.length} intake records');

      for (var doc in querySnapshot.docs) {
        final data = doc.data();
        debugPrint('Processing intake document ${doc.id} with data: $data');

        if (data.containsKey('items') && data['items'] is List) {
          final items = List<Map<String, dynamic>>.from(data['items']);
          final total = (data['totalAmount'] ?? 0).toDouble();

          intakeData.add({
            'id': doc.id,
            'createdAt': (data['createdAt'] as Timestamp).toDate(),
            'items': items,
            'totalAmount': total,
          });

          totalExpense.value += total;
          totalItemsIntaken.value += items.fold<int>(0, (sum, item) =>
          sum + ((item['quantity'] as int?) ?? 0));
        }
      }

      intakeData.sort((a, b) => (b['createdAt'] as DateTime).compareTo(a['createdAt'] as DateTime));
    } catch (e, stackTrace) {
      debugPrint('Error fetching intakes: $e');
      debugPrint('Stack trace: $stackTrace');
      CustomSnackbar.show(title: 'Error', message: 'Failed to load intake data');
    } finally {
      isLoading(false);
    }
  }

  void updateFromDate(DateTime newDate) {
    fromDate.value = newDate;
    fetchIntakeData();
  }

  void updateToDate(DateTime newDate) {
    toDate.value = newDate;
    fetchIntakeData();
  }

  // Helper to format date for display
  String formatDate(DateTime date) {
    return DateFormat('dd, MMMM yyyy').format(date);
  }

  // Get chart data for products
  List<BarData> getProductChartData() {
    final productMap = <String, double>{};

    for (var intake in intakeData) {
      final items = List<Map<String, dynamic>>.from(intake['items'] ?? []);
      for (var item in items) {
        final productName = item['title'] ?? 'Unknown';
        final value = (item['price'] ?? 0).toDouble() * (item['quantity'] ?? 1);
        productMap[productName] = (productMap[productName] ?? 0) + value;
      }
    }

    return productMap.entries
        .map((e) => BarData(label: e.key, value: e.value))
        .toList();
  }

  // Get max Y value for chart
  double getMaxChartValue() {
    final chartData = getProductChartData();
    if (chartData.isEmpty) return 8; // default when no data

    // Get the maximum value from the chart data
    final maxDataValue = chartData.map((e) => e.value).reduce((a, b) => a > b ? a : b);

    // For extremely large values, use a different approach
    if (maxDataValue >= 1000000) {
      return maxDataValue * 1.1; // Just add 10% padding
    }

    // For smaller values, use the existing logic
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
  // Calculate Y-axis steps for the chart
  List<double> getYAxisSteps() {
    final maxValue = getMaxChartValue();
    return ChartFormatter.calculateYAxisSteps(maxValue);
  }



  Map<String, Map<String, dynamic>> getProductSummaryData() {
    final Map<String, Map<String, dynamic>> productMap = {};

    for (var intake in intakeData) {
      final items = List<Map<String, dynamic>>.from(intake['items'] ?? []);
      for (var item in items) {
        final name = item['title'] ?? 'Unknown Product';
        final quantity = (item['quantity'] ?? 0) as int;
        final price = (item['price'] ?? 0).toDouble();
        final imagePath = item['imagePath'] ?? "assets/images/products.png";

        if (!productMap.containsKey(name)) {
          productMap[name] = {
            'totalQuantity': 0,
            'totalPrice': 0.0,
            'imagePath': imagePath,
          };
        }

        productMap[name]!['totalQuantity'] += quantity;
        productMap[name]!['totalPrice'] += price * quantity;
      }
    }

    return productMap;
  }
}