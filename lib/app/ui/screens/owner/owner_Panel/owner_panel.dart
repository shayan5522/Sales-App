import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../controllers/shop_nav_controller.dart';
import '../../../../themes/colors.dart';
import '../dashboard/owner_dashboard.dart';
import '../dashboard/products/products.dart';
import '../Reports/report_page.dart';
import '../settings/setting.dart';

class OwnerPanel extends StatelessWidget {
  final controller = Get.put(ShopNavController());

  final pages = [
    OwnerDashboard(), // Home
    ReportsMainPage(), // Reports
    ProductScreen(), // Products
    SettingsScreen(), // Settings
  ];

  OwnerPanel({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() => Scaffold(
      body: pages[controller.selectedIndex.value],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: controller.selectedIndex.value,
        onTap: controller.changeTabIndex,
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.grey[200],
        selectedItemColor: AppColors.primary,
        unselectedItemColor: Colors.grey[600],
        selectedLabelStyle: const TextStyle(
          fontWeight: FontWeight.bold,
        ),
        unselectedLabelStyle: const TextStyle(
          fontWeight: FontWeight.normal,
        ),
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: "Home",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.bar_chart),
            label: "Reports",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_bag),
            label: "Products",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: "Setting",
          ),
        ],
      ),
    ));
  }
}
