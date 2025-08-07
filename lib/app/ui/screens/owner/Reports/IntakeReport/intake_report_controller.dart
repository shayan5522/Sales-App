import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../../../widgets/chart.dart';

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
        Get.snackbar('Error', 'User not authenticated');
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
      Get.snackbar('Error', 'Failed to load intake data');
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
    if (chartData.isEmpty) return 8000; // default
    return chartData.map((e) => e.value).reduce((a, b) => a > b ? a : b) * 1.2;
  }
}