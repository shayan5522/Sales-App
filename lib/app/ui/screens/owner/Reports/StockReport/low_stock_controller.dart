import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LowStockController extends GetxController {
  RxInt lowStockThreshold = 5.obs;

  @override
  void onInit() {
    super.onInit();
    loadLowStockThreshold();
  }

  Future<void> loadLowStockThreshold() async {
    final prefs = await SharedPreferences.getInstance();
    lowStockThreshold.value = prefs.getInt('lowStockThreshold') ?? 5;
  }

  Future<void> setLowStockThreshold(int threshold) async {
    lowStockThreshold.value = threshold;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('lowStockThreshold', threshold);
  }

  bool isLowStock(int currentStock) {
    return currentStock <= lowStockThreshold.value;
  }
}