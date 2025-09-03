import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../../widgets/custom_snackbar.dart';

class TransactionViewController extends GetxController {
  RxList<Map<String, dynamic>> allTransactions = <Map<String, dynamic>>[].obs;
  RxList<Map<String, dynamic>> filteredTransactions = <Map<String, dynamic>>[].obs;
  RxBool isLoading = true.obs;

  RxDouble totalCredit = 0.0.obs;
  RxDouble totalDebit = 0.0.obs;
  RxDouble totalPending = 0.0.obs;

  DateTime? fromDate;
  DateTime? toDate;

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> fetchTransactions() async {
    try {
      isLoading.value = true;
      final uid = _auth.currentUser!.uid;

      final creditSnap = await _firestore.collection('users').doc(uid).collection('credits').get();
      final debitSnap = await _firestore.collection('users').doc(uid).collection('debits').get();

      final creditList = creditSnap.docs.map((doc) {
        final data = doc.data();
        final originalAmount = (data['originalAmount'] ?? data['price'] ?? 0).toDouble();
        final paidAmount = (data['paidAmount'] ?? 0).toDouble();
        final remainingAmount = originalAmount - paidAmount;

        return {
          'id': doc.id,
          'type': 'credit',
          'name': data['name'],
          'detail': data['detail'],
          'originalAmount': originalAmount,
          'paidAmount': paidAmount,
          'remainingAmount': remainingAmount,
          'isFullyPaid': remainingAmount <= 0,
          'date': (data['date'] as Timestamp).toDate(),
          'createdAt': (data['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
        };
      }).toList();

      final debitList = debitSnap.docs.map((doc) {
        final data = doc.data();
        final originalAmount = (data['originalAmount'] ?? data['price'] ?? 0).toDouble();
        final paidAmount = (data['paidAmount'] ?? 0).toDouble();
        final remainingAmount = originalAmount - paidAmount;

        return {
          'id': doc.id,
          'type': 'debit',
          'name': data['name'],
          'detail': data['detail'],
          'originalAmount': originalAmount,
          'paidAmount': paidAmount,
          'remainingAmount': remainingAmount,
          'isFullyPaid': remainingAmount <= 0,
          'date': (data['date'] as Timestamp).toDate(),
          'createdAt': (data['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
        };
      }).toList();

      allTransactions.assignAll([...creditList, ...debitList]);
      filteredTransactions.assignAll(allTransactions);

      totalCredit.value = creditList.fold(0.0, (sum, item) => sum + (item['remainingAmount'] ?? 0));
      totalDebit.value = debitList.fold(0.0, (sum, item) => sum + (item['remainingAmount'] ?? 0));
      totalPending.value = creditList.fold(0.0, (sum, item) => sum + (item['remainingAmount'] ?? 0)) +
          debitList.fold(0.0, (sum, item) => sum + (item['remainingAmount'] ?? 0));
    } catch (e) {
      CustomSnackbar.show(title: 'Error', message: 'Failed to load transactions: $e');
    } finally {
      isLoading.value = false;
    }
  }

  void filterTransactions({String? type}) {
    final base = allTransactions;

    final filtered = base.where((t) {
      final matchesType = type == null || t['type'] == type;

      final date = t['date'] as DateTime?;
      final matchesFrom = fromDate == null || date!.isAfter(fromDate!.subtract(const Duration(days: 1)));
      final matchesTo = toDate == null || date!.isBefore(toDate!.add(const Duration(days: 1)));

      return matchesType && matchesFrom && matchesTo;
    }).toList();

    filteredTransactions.assignAll(filtered);
  }

  void filterByDateRange({DateTime? from, DateTime? to}) {
    fromDate = from;
    toDate = to;
    filterTransactions();
  }

  Future<void> addPayment(String transactionId, String type, double amount, String note) async {
    try {
      final uid = _auth.currentUser!.uid;
      final collection = type == 'credit' ? 'credits' : 'debits';

      // Get current transaction
      final doc = await _firestore.collection('users').doc(uid).collection(collection).doc(transactionId).get();
      if (!doc.exists) throw Exception('Transaction not found');

      final data = doc.data()!;
      final currentPaid = (data['paidAmount'] ?? 0).toDouble();
      final originalAmount = (data['originalAmount'] ?? data['price'] ?? 0).toDouble();
      final newPaid = currentPaid + amount;

      if (newPaid > originalAmount) {
        throw Exception('Payment amount exceeds remaining balance');
      }

      // Update transaction with new payment
      await _firestore.collection('users').doc(uid).collection(collection).doc(transactionId).update({
        'paidAmount': newPaid,
        'isFullyPaid': newPaid >= originalAmount,
        'lastPaymentDate': FieldValue.serverTimestamp(),
      });

      // Add payment record to subcollection
      await _firestore.collection('users').doc(uid).collection(collection).doc(transactionId)
          .collection('payments').add({
        'amount': amount,
        'note': note,
        'date': FieldValue.serverTimestamp(),
        'createdBy': uid,
      });

      // Refresh data
      await fetchTransactions();

      CustomSnackbar.show(title: 'Success', message: 'Payment of ₹${amount.toStringAsFixed(2)} recorded successfully');
    } catch (e) {
      CustomSnackbar.show(title: 'Error', message: 'Failed to record payment: $e', isError: true);
    }
  }

  Future<void> markAsFullyPaid(String transactionId, String type) async {
    try {
      final uid = _auth.currentUser!.uid;
      final collection = type == 'credit' ? 'credits' : 'debits';

      final doc = await _firestore.collection('users').doc(uid).collection(collection).doc(transactionId).get();
      if (!doc.exists) throw Exception('Transaction not found');

      final data = doc.data()!;
      final originalAmount = (data['originalAmount'] ?? data['price'] ?? 0).toDouble();

      await _firestore.collection('users').doc(uid).collection(collection).doc(transactionId).update({
        'paidAmount': originalAmount,
        'isFullyPaid': true,
        'completedDate': FieldValue.serverTimestamp(),
      });

      await fetchTransactions();

      CustomSnackbar.show(title: 'Success', message: 'Transaction marked as fully paid');
    } catch (e) {
      CustomSnackbar.show(title: 'Error', message: 'Failed to mark as paid: $e', isError: true);
    }
  }
}