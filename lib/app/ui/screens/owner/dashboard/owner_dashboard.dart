import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:salesapp/app/themes/styles.dart';
import 'package:salesapp/app/ui/screens/owner/dashboard/return_screen/return.dart';
import 'package:salesapp/app/ui/widgets/datepicker.dart';
import '../../../../controllers/owner_dashboard_controller.dart';
import '../../../widgets/Admindashboard/dashboard_main-container.dart';
import '../../../widgets/Admindashboard/earning_card.dart';
import '../../../widgets/Admindashboard/gradient_action_card.dart';
import '../../../widgets/Admindashboard/salescard.dart';
import '../../../widgets/custom_dashboard_appbar.dart';
import 'package:salesapp/app/ui/screens/owner/dashboard/products/products.dart';
import '../Reports/ReportMainPage/report_main_page.dart';
import '../Reports/ReportMainPage/reports_main_page_controller.dart';
import '../user_management/usermanagement.dart';
import 'Add_Sales/sales.dart';
import 'add_category/add_category_page.dart';
import 'credit_amount _due/amountcrediet.dart';
import 'expenses/expense.dart';
import 'intake/addintake.dart';

class OwnerDashboard extends StatelessWidget {
  OwnerDashboard({super.key}) {
    Get.put(DashboardController());
  }

  @override
  Widget build(BuildContext context) {
    final screen = MediaQuery.of(context).size;
    final controller = Get.find<DashboardController>();

    return Scaffold(
      backgroundColor: const Color(0xFFF6F6F9),
      appBar: CustomDashboardAppBar(
        title: "Owner Panel",
        logoPath: "assets/images/sales.png",
        onProfileTap: () => Get.to(() => const UserManagementScreen()),
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        return SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Total Summary", style: AppTextStyles.heading),
                  SizedBox(
                    width: 140,
                    child: CustomDatePicker(
                      label: '',
                      initialDate: controller.selectedDate.value,
                      onDateSelected: controller.updateSelectedDate,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Sales Cards Grid
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Flexible(
                    child: SalesCard(
                      imagePath: "assets/images/sales.png",
                      label: "Total Sales",
                      value: controller.totalSales.value.toInt(),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Flexible(
                    child: SalesCard(
                      imagePath: "assets/images/sales1111.png",
                      label: "Total Income",
                      value: controller.totalIntake.value.toInt(),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Flexible(
                    child: SalesCard(
                      imagePath: "assets/images/earning.png",
                      label: "Total Profit",
                      value: controller.totalProfit.value.toInt(),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 16),

              // Earnings Cards Row
              Row(
                children: [
                  Flexible(
                    child: EarningsCard(
                      income: controller.totalIntake.value,
                      profit: controller.totalProfit.value,
                      imagePath: "assets/images/earnings.jpeg",
                      onSeeAll: () {},
                    ),
                  ),
                  const SizedBox(width: 12),
                  Flexible(
                    child: EarningsCard(
                      income: controller.totalIntake.value , // Example cash income
                      profit: controller.totalProfit.value , // Example cash profit
                      imagePath: "assets/images/earnings.jpeg",
                      onSeeAll: () {},
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 16),

              // Quick Actions Section
              Text("Quick Actions", style: AppTextStyles.heading),
              const SizedBox(height: 16),
              LayoutBuilder(
                builder: (context, constraints) {
                  int crossAxisCount = 2;
                  if (constraints.maxWidth >= 800) crossAxisCount = 4;
                  else if (constraints.maxWidth >= 600) crossAxisCount = 3;

                  return GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: 7,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: crossAxisCount,
                      crossAxisSpacing: 12,
                      mainAxisSpacing: 12,
                      childAspectRatio: 1,
                    ),
                    itemBuilder: (context, index) {
                      final items = [
                        {
                          "label": "Products",
                          "icon": "assets/images/products.png",
                          "screen": const ProductScreen(),
                        },
                        {
                          "label": "Add Intake",
                          "icon": "assets/images/products.png",
                          "screen": AddIntake(),
                        },
                        {
                          "label": "Add Sale",
                          "icon": "assets/images/products.png",
                          "screen": Sales(),
                        },
                        {
                          "label": "Add Expense",
                          "icon": "assets/images/products.png",
                          "screen": const AddExpenseScreen(),
                        },
                        {
                          "label": "Return",
                          "icon": "assets/images/products.png",
                          "screen": const ReturnProduct(),
                        },
                        {
                          "label": "Add Expense Category",
                          "icon": "assets/images/products.png",
                          "screen":  AddCategoryPage(),
                        },
                        {
                          "label": "Credit & amount due",
                          "icon": "assets/images/products.png",
                          "screen":  AmountCreditScreen(),
                        },
                      ];
                      final item = items[index];
                      return MainContainer(
                        imagePath: item["icon"] as String,
                        label: item["label"] as String,
                        onTap: () => Get.to(() => item["screen"] as Widget),
                      );
                    },
                  );
                },
              ),

              const SizedBox(height: 32),

              // Management Section
              Text("Management", style: AppTextStyles.heading),
              const SizedBox(height: 12),
              GradientActionCard(
                label: "Generate Report",
                iconPath: "assets/images/earning.png",
                onTap: () => Get.to(() =>  ReportsMainPage()),
              ),
              const SizedBox(height: 30),
            ],
          ),
        );
      }),
    );
  }
}