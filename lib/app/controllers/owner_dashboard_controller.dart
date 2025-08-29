import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../ui/widgets/custom_snackbar.dart';

class DashboardController extends GetxController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth auth = FirebaseAuth.instance;

  // Reactive variables
  var isLoading = false.obs;
  var selectedDate = DateTime.now().obs;
  var totalSales = 0.0.obs;
  var totalIntake = 0.0.obs;
  var totalExpense = 0.0.obs;
  var totalProfit = 0.0.obs;
  var cashSales = 0.0.obs;
  var onlineSales = 0.0.obs;
  var cashProfit = 0.0.obs;
  var onlineProfit = 0.0.obs;

  @override
  void onInit() {
    super.onInit();
    fetchDashboardData();
    ever(selectedDate, (_) => fetchDashboardData());
  }

  void updateSelectedDate(DateTime newDate) {
    selectedDate.value = newDate;
  }

  Stream<double> getSalesStream(String userId, DateTime start, DateTime end) {
    return _firestore
        .collection('users')
        .doc(userId)
        .collection('sales')
        .where('createdAt', isGreaterThanOrEqualTo: start)
        .where('createdAt', isLessThanOrEqualTo: end)
        .snapshots()
        .map((querySnapshot) {
      double cashTotal = 0.0;
      double onlineTotal = 0.0;

      for (var doc in querySnapshot.docs) {
        final data = doc.data();
        final amount = (data['totalAmount'] ?? 0).toDouble();
        if (data['paymentType'] == 'Cash') {
          cashTotal += amount;
        } else {
          onlineTotal += amount;
        }
      }

      cashSales.value = cashTotal;
      onlineSales.value = onlineTotal;
      final total = cashTotal + onlineTotal;
      totalSales.value = total;
      _calculateRealProfits(); // Update profits when sales data changes
      return total;
    });
  }

  Stream<double> getIntakeStream(String userId, DateTime start, DateTime end) {
    return _firestore
        .collection('users')
        .doc(userId)
        .collection('intakes')
        .where('createdAt', isGreaterThanOrEqualTo: start)
        .where('createdAt', isLessThanOrEqualTo: end)
        .snapshots()
        .map((querySnapshot) {
      final total = querySnapshot.docs.fold(0.0, (sum, doc) {
        return sum + (doc.data()['totalAmount'] ?? 0).toDouble();
      });
      totalIntake.value = total;
      _calculateRealProfits(); // Update profits when intake data changes
      return total;
    });
  }

  Stream<double> getExpenseStream(String userId, DateTime start, DateTime end) {
    return _firestore
        .collection('users')
        .doc(userId)
        .collection('expenses')
        .where('createdAt', isGreaterThanOrEqualTo: start)
        .where('createdAt', isLessThanOrEqualTo: end)
        .snapshots()
        .map((querySnapshot) {
      final total = querySnapshot.docs.fold(0.0, (sum, doc) {
        return sum + (doc.data()['amount'] ?? 0).toDouble();
      });
      totalExpense.value = total;
      _calculateRealProfits(); // Update profits when expense data changes
      return total;
    });
  }

  Future<void> fetchDashboardData() async {
    try {
      isLoading(true);

      final user = auth.currentUser;
      if (user == null) {
        CustomSnackbar.show(title: 'Error', message: 'User not authenticated');
        return;
      }

      final userId = user.uid;
      final date = selectedDate.value;
      final startOfDay = DateTime(date.year, date.month, date.day);
      final endOfDay = DateTime(date.year, date.month, date.day, 23, 59, 59);

      await Future.wait([
        _fetchSalesData(userId, startOfDay, endOfDay),
        _fetchIntakeData(userId, startOfDay, endOfDay),
        _fetchExpenseData(userId, startOfDay, endOfDay),
      ]);

      _calculateRealProfits();

    } catch (e) {
      CustomSnackbar.show(
          title: 'Error',
          message: 'Failed to fetch dashboard data: ${e.toString()}',
          isError: true
      );
    } finally {
      isLoading(false);
    }
  }

  void _calculateRealProfits() {
    // Remove these lines - they're causing the discrepancy
     totalProfit.value = totalSales.value - (totalIntake.value + totalExpense.value);

    // Just ensure non-negative values if needed
    cashProfit.value = cashProfit.value < 0 ? 0 : cashProfit.value;
    onlineProfit.value = onlineProfit.value < 0 ? 0 : onlineProfit.value;
  }

  Future<void> _fetchSalesData(String userId, DateTime start, DateTime end) async {
    final querySnapshot = await _firestore
        .collection('users')
        .doc(userId)
        .collection('sales')
        .where('createdAt', isGreaterThanOrEqualTo: start)
        .where('createdAt', isLessThanOrEqualTo: end)
        .get();

    double cashTotal = 0.0;
    double onlineTotal = 0.0;
    double cashProfitTotal = 0.0;
    double onlineProfitTotal = 0.0;

    for (var doc in querySnapshot.docs) {
      final data = doc.data();
      final amount = (data['totalAmount'] ?? 0).toDouble();
      final items = data['items'] as List? ?? [];

      double saleProfit = 0.0;

      for (var item in items.cast<Map<String, dynamic>>()) {
        final originalPrice = (item['originalPrice'] ?? 0).toDouble();
        final salePrice = (item['price'] ?? 0).toDouble();
        final quantity = (item['quantity'] ?? 0).toInt();
        final discount = (item['discount'] ?? 0).toDouble();

        // Same calculation as in detailed screens
        saleProfit += ((salePrice - discount) - originalPrice) * quantity;
      }

      if (data['paymentType'] == 'Cash') {
        cashTotal += amount;
        cashProfitTotal += saleProfit;
      } else if (data['paymentType'] == 'Online') {
        onlineTotal += amount;
        onlineProfitTotal += saleProfit;
      }
    }

    cashSales.value = cashTotal;
    onlineSales.value = onlineTotal;
    cashProfit.value = cashProfitTotal;
    onlineProfit.value = onlineProfitTotal;
    totalSales.value = cashTotal + onlineTotal;
    totalProfit.value = cashProfitTotal + onlineProfitTotal;
  }

  Future<void> _fetchIntakeData(String userId, DateTime start, DateTime end) async {
    final querySnapshot = await _firestore
        .collection('users')
        .doc(userId)
        .collection('intakes')
        .where('createdAt', isGreaterThanOrEqualTo: start)
        .where('createdAt', isLessThanOrEqualTo: end)
        .get();

    totalIntake.value = querySnapshot.docs.fold(0.0, (sum, doc) {
      return sum + (doc.data()['totalAmount'] ?? 0).toDouble();
    });
  }

  Future<void> _fetchExpenseData(String userId, DateTime start, DateTime end) async {
    final querySnapshot = await _firestore
        .collection('users')
        .doc(userId)
        .collection('expenses')
        .where('createdAt', isGreaterThanOrEqualTo: start)
        .where('createdAt', isLessThanOrEqualTo: end)
        .get();

    totalExpense.value = querySnapshot.docs.fold(0.0, (sum, doc) {
      return sum + (doc.data()['amount'] ?? 0).toDouble();
    });
  }

  String formatCurrency(double amount) {
    return '₹${amount.toStringAsFixed(2)}';
  }
}