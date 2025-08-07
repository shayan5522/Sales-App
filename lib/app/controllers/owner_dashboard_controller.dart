import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';

class DashboardController extends GetxController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Reactive variables
  var isLoading = false.obs;
  var selectedDate = DateTime.now().obs;
  var totalSales = 0.0.obs;
  var totalIntake = 0.0.obs;
  var totalExpense = 0.0.obs;
  var totalProfit = 0.0.obs;

  @override
  void onInit() {
    super.onInit();
    fetchDashboardData();
  }

  void updateSelectedDate(DateTime newDate) {
    selectedDate.value = newDate;
    fetchDashboardData();
  }

  Future<void> fetchDashboardData() async {
    try {
      isLoading(true);

      final user = _auth.currentUser;
      if (user == null) {
        Get.snackbar('Error', 'User not authenticated');
        return;
      }

      final userId = user.uid;
      final date = selectedDate.value;
      final startOfDay = DateTime(date.year, date.month, date.day);
      final endOfDay = DateTime(date.year, date.month, date.day, 23, 59, 59);

      // Fetch all data in parallel
      await Future.wait([
        _fetchSalesData(userId, startOfDay, endOfDay),
        _fetchIntakeData(userId, startOfDay, endOfDay),
        _fetchExpenseData(userId, startOfDay, endOfDay),
      ]);

      // Correct profit calculation
      totalProfit.value = totalSales.value - (totalIntake.value + totalExpense.value);

    } catch (e) {
      Get.snackbar('Error', 'Failed to fetch dashboard data: ${e.toString()}');
    } finally {
      isLoading(false);
    }
  }

  Future<void> _fetchSalesData(String userId, DateTime start, DateTime end) async {
    final querySnapshot = await _firestore
        .collection('users')
        .doc(userId)
        .collection('sales')
        .where('createdAt', isGreaterThanOrEqualTo: start)
        .where('createdAt', isLessThanOrEqualTo: end)
        .get();

    totalSales.value = querySnapshot.docs.fold(0.0, (sum, doc) {
      return sum + (doc.data()['totalAmount'] ?? 0).toDouble();
    });
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

  // Format currency with Indian Rupee symbol
  String formatCurrency(double amount) {
    return '₹${amount.toStringAsFixed(2)}';
  }
}