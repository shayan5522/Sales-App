import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/labour_nav_controller.dart';
import '../../themes/colors.dart';
import 'labour/labour_dashboard.dart';

class LaborPanel extends StatelessWidget {
  final controller = Get.put(LaborNavController());

  final pages = [
    LabourDashboard(),
    LabourDashboard(),
    LabourDashboard(),
    LabourDashboard(),
    // ReportPage(),
    // ProductPage(),
    // SettingPage(),
  ];

   LaborPanel({super.key});

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
