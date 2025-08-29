import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import '../../../../widgets/chart.dart';
import '../../../../widgets/chart_formatter.dart';
import '../../../../widgets/custom_snackbar.dart';

class ExpenseReportController extends GetxController {
  final _firestore = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;
  RxBool isLoading = true.obs;

  RxList<Map<String, dynamic>> allExpenses = <Map<String, dynamic>>[].obs;
  RxList<Map<String, dynamic>> filteredExpenses = <Map<String, dynamic>>[].obs;

  DateTime? fromDate;
  DateTime? toDate;

  @override
  void onInit() {
    super.onInit();
    fetchExpenses();
  }

  Future<void> fetchExpenses() async {
    try {
      isLoading.value = true;
      final uid = _auth.currentUser?.uid;
      if (uid == null) throw Exception("User not logged in");

      final snapshot = await _firestore
          .collection('users')
          .doc(uid)
          .collection('expenses')
          .orderBy('createdAt', descending: true)
          .get();

      final expenses = snapshot.docs.map((doc) {
        final data = doc.data();

        // Safely parse date
        DateTime date = DateTime.now(); // fallback date
        if (data['createdAt'] != null && data['createdAt'] is Timestamp) {
          date = (data['createdAt'] as Timestamp).toDate();
        }

        return {
          'id': doc.id,
          'title': data['name'] ?? 'No Title',
          'description': data['description'] ?? '',
          'amount': (data['amount'] ?? 0).toDouble(),
          'category': data['category'] ?? 'Uncategorized',
          'date': date,
        };
      }).toList();

      allExpenses.assignAll(expenses);
      filteredExpenses.assignAll(expenses);
    } catch (e) {
      CustomSnackbar.show(title: "Error", message: "Failed to fetch expenses: $e", isError: true);
      print(e);
    } finally {
      isLoading.value = false;
    }
  }

  void filterByDateRange({DateTime? from, DateTime? to}) {
    fromDate = from;
    toDate = to;

    if (fromDate == null && toDate == null) {
      filteredExpenses.assignAll(allExpenses);
      return;
    }

    filteredExpenses.assignAll(allExpenses.where((expense) {
      final expenseDate = expense['date'] as DateTime;
      final isAfterFrom = fromDate == null ||
          expenseDate.isAfter(fromDate!.subtract(const Duration(days: 1)));
      final isBeforeTo = toDate == null ||
          expenseDate.isBefore(toDate!.add(const Duration(days: 1)));
      return isAfterFrom && isBeforeTo;
    }));
  }

  Map<String, Map<String, dynamic>> getCategorySummary() {
    final summary = <String, Map<String, dynamic>>{};

    for (var exp in filteredExpenses) {
      final category = exp['category'];
      final amount = (exp['amount'] as num).toDouble();
      final description = exp['description'] ?? '';

      if (summary.containsKey(category)) {
        summary[category]!['amount'] += amount;
      } else {
        summary[category] = {
          'amount': amount,
          'description': description,
        };
      }
    }

    return summary;
  }

  Map<String, double> getCategoryTotals() {
    final totals = <String, double>{};
    for (var exp in filteredExpenses) {
      final category = exp['category'];
      final price = (exp['amount'] as num).toDouble();
      totals[category] = (totals[category] ?? 0) + price;
    }
    return totals;
  }

  Map<String, Map<String, dynamic>> getCategorySummaryFromAll() {
    final summary = <String, Map<String, dynamic>>{};
    for (var exp in allExpenses) {
      final category = exp['category'];
      final amount = (exp['amount'] as num).toDouble();
      final description = exp['description'] ?? '';

      if (summary.containsKey(category)) {
        summary[category]!['amount'] += amount;
      } else {
        summary[category] = {
          'amount': amount,
          'description': description,
        };
      }
    }
    return summary;
  }

  // Get max Y value for chart
  double getMaxChartValue() {
    final chartData = getCategoryTotals().entries.map((e) {
      return BarData(label: e.key, value: e.value);
    }).toList();

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
}