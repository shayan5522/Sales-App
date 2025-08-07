import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';

class TransactionViewController extends GetxController {
  RxList<Map<String, dynamic>> allTransactions = <Map<String, dynamic>>[].obs;
  RxList<Map<String, dynamic>> filteredTransactions = <Map<String, dynamic>>[].obs;
  RxBool isLoading = true.obs;

  RxDouble totalCredit = 0.0.obs;
  RxDouble totalDebit = 0.0.obs;

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
        return {
          'type': 'credit',
          'name': data['name'],
          'detail': data['detail'],
          'price': data['price'],
          'date': (data['date'] as Timestamp).toDate(),
        };
      }).toList();

      final debitList = debitSnap.docs.map((doc) {
        final data = doc.data();
        return {
          'type': 'debit',
          'name': data['name'],
          'detail': data['detail'],
          'price': data['price'],
          'date': (data['date'] as Timestamp).toDate(),
        };
      }).toList();

      allTransactions.assignAll([...creditList, ...debitList]);
      filteredTransactions.assignAll(allTransactions);

      totalCredit.value = creditList.fold(0.0, (sum, item) => sum + (item['price'] ?? 0));
      totalDebit.value = debitList.fold(0.0, (sum, item) => sum + (item['price'] ?? 0));
    } catch (e) {
      Get.snackbar('Error', 'Failed to load transactions: $e');
    }
    finally{
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
    filterTransactions(); // uses current type + new date range
  }
}
