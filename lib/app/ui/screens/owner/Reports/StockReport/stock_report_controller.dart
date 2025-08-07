import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class IntakeItem {
  final String title;
  final String imagePath;
  final int quantity;
  final double price;

  IntakeItem({
    required this.title,
    required this.imagePath,
    required this.quantity,
    required this.price,
  });

  double get total => quantity * price;
}

class StockReportController extends GetxController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Rx<DateTime> fromDate = DateTime.now().subtract(Duration(days: 7)).obs;
  Rx<DateTime> toDate = DateTime.now().obs;

  RxList<IntakeItem> intakeItems = <IntakeItem>[].obs;
  RxDouble totalValue = 0.0.obs;
  RxInt totalQuantity = 0.obs;
  RxBool isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    fetchStockData(); // ✅ This is the missing call
  }

  void setFromDate(DateTime date) {
    fromDate.value = date;
    fetchStockData();
  }

  void setToDate(DateTime date) {
    toDate.value = date;
    fetchStockData();
  }

  Future<void> fetchStockData() async {
    print("Fetching data...");
    isLoading.value = true;

    try {
      intakeItems.clear();
      totalValue.value = 0.0;
      totalQuantity.value = 0;

      final snapshot = await _firestore.collection('intakes').get();

      for (final doc in snapshot.docs) {
        final data = doc.data();
        final Timestamp createdAt = data['createdAt'];
        final DateTime createdDate = createdAt.toDate();

        if (createdDate.isBefore(fromDate.value) || createdDate.isAfter(toDate.value)) {
          continue;
        }

        print("Fetched Data: $data");

        final items = List<Map<String, dynamic>>.from(data['items'] ?? []);
        for (final item in items) {
          final intakeItem = IntakeItem(
            title: item['title'] ?? 'Unknown',
            imagePath: item['imagePath'] ?? '',
            quantity: (item['quantity'] ?? 0) is int
                ? item['quantity']
                : int.tryParse(item['quantity'].toString()) ?? 0,
            price: (item['price'] ?? 0.0) is num
                ? (item['price'] as num).toDouble()
                : 0.0,
          );

          intakeItems.add(intakeItem);
          totalValue.value += intakeItem.total;
          totalQuantity.value += intakeItem.quantity;
        }
      }
    } catch (e) {
      print('Error fetching stock data: $e');
    } finally {
      isLoading.value = false;
    }
  }
}

