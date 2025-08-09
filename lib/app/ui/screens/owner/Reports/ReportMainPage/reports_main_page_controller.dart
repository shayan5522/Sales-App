import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../../../widgets/custom_snackbar.dart';

class ReportsController extends GetxController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Reactive variables
  var isLoading = false.obs;
  var salesAmount = 0.0.obs;
  var intakeAmount = 0.0.obs;
  var expenseAmount = 0.0.obs;
  var profitAmount = 0.0.obs;
  var cashProfit = 0.0.obs;
  var onlineProfit = 0.0.obs;

  @override
  void onInit() {
    super.onInit();
    fetchAllTotals();
  }

  Future<void> fetchAllTotals() async {
    try {
      isLoading(true);

      // Get current user
      final user = _auth.currentUser;
      if (user == null) {
        CustomSnackbar.show(title: 'Error', message: 'User not authenticated');
        return;
      }

      final userId = user.uid;

      // Fetch all totals in parallel
      await Future.wait([
        _fetchSalesTotal(userId),
        _fetchIntakeTotal(userId),
        _fetchExpenseTotal(userId),
      ]);

      // Calculate profits
      profitAmount.value = salesAmount.value - (intakeAmount.value + expenseAmount.value);
      cashProfit.value = profitAmount.value * 0.7; // 70% cash (example)
      onlineProfit.value = profitAmount.value * 0.3; // 30% online (example)

    } catch (e) {
      CustomSnackbar.show(title: 'Error', message: 'Failed to fetch report data: ${e.toString()}', isError: true);
    } finally {
      isLoading(false);
    }
  }

  Future<void> _fetchSalesTotal(String userId) async {
    final querySnapshot = await _firestore
        .collection('users')
        .doc(userId)
        .collection('sales')
        .get();

    salesAmount.value = querySnapshot.docs.fold(0.0, (sum, doc) {
      return sum + (doc.data()['totalAmount'] ?? 0).toDouble();
    });
  }

  Future<void> _fetchIntakeTotal(String userId) async {
    final querySnapshot = await _firestore
        .collection('users')
        .doc(userId)
        .collection('intakes')
        .get();

    intakeAmount.value = querySnapshot.docs.fold(0.0, (sum, doc) {
      return sum + (doc.data()['totalAmount'] ?? 0).toDouble();
    });
  }

  Future<void> _fetchExpenseTotal(String userId) async {
    final querySnapshot = await _firestore
        .collection('users')
        .doc(userId)
        .collection('expenses')
        .get();

    expenseAmount.value = querySnapshot.docs.fold(0.0, (sum, doc) {
      return sum + (doc.data()['amount'] ?? 0).toDouble();
    });
  }

  // Format currency with Indian Rupee symbol
  String formatCurrency(double amount) {
    return '${amount.toStringAsFixed(2)}';
  }
}