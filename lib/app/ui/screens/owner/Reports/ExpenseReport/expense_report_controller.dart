import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

class ExpenseReportController extends GetxController {
  final _firestore = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;
  RxBool isLoading = true.obs;

  RxList<Map<String, dynamic>> allExpenses = <Map<String, dynamic>>[].obs;
  RxList<Map<String, dynamic>> filteredExpenses = <Map<String, dynamic>>[].obs;

  DateTime? fromDate;
  DateTime? toDate;

  Future<void> fetchExpenses() async {
    try {
      isLoading.value = true;
      final uid = _auth.currentUser?.uid;
      if (uid == null) throw Exception("User not logged in");

      final snapshot = await _firestore
          .collection('users')
          .doc(uid)
          .collection('expenses')
          .get();

      final expenses = snapshot.docs.map((doc) {
        final data = doc.data();

        // Safely parse date
        DateTime date = DateTime.now(); // fallback date
        if (data['createdAt'] != null && data['createdAt'] is Timestamp) {
          date = (data['createdAt'] as Timestamp).toDate();
        }

        return {
          'title': data['name'] ?? 'No Title',
          'description': data['description'] ?? '',
          'amount': data['amount'] ?? 0,
          'category': data['category'] ?? 'Uncategorized',
          'date': date,
        };
      }).toList();

      allExpenses.assignAll(expenses);
      filteredExpenses.assignAll(expenses);
    } catch (e) {
      Get.snackbar("Error", "Failed to fetch expenses: $e");
      print(e);
    }
    finally{
      isLoading.value=false;
    }
  }

  void filterByDateRange({DateTime? from, DateTime? to}) {
    fromDate = from;
    toDate = to;

    filteredExpenses.assignAll(allExpenses.where((expense) {
      final expenseDate = expense['date'] as DateTime;
      final isAfterFrom = fromDate == null || expenseDate.isAfter(fromDate!.subtract(const Duration(days: 1)));
      final isBeforeTo = toDate == null || expenseDate.isBefore(toDate!.add(const Duration(days: 1)));
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
}
