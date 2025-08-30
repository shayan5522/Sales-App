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
import '../../../widgets/number_formatter.dart';
import '../Reports/ReportMainPage/report_main_page.dart';
import '../Reports/ReportMainPage/reports_main_page_controller.dart';
import '../user_management/usermanagement.dart';
import 'Add_Sales/sales.dart';
import 'add_category/add_category_page.dart';
import 'credit_amount _due/amountcrediet.dart';
import 'earnings/cash_earnings/offline_earnings_screen.dart';
import 'earnings/online_earnings/online_earnings_screen.dart';
import 'expenses/expense.dart';
import 'intake/addintake.dart';

class OwnerDashboard extends StatelessWidget {
  OwnerDashboard({super.key}) {
    Get.put(DashboardController());
  }

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<DashboardController>();
    final user = controller.auth.currentUser;
    final date = controller.selectedDate.value;
    final startOfDay = DateTime(date.year, date.month, date.day);
    final endOfDay = DateTime(date.year, date.month, date.day, 23, 59, 59);

    Future<void> _refreshData() async {
      await controller.fetchDashboardData();
    }

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

        if (user == null) {
          return const Center(child: Text("User not authenticated"));
        }

        return RefreshIndicator(
          onRefresh: _refreshData,
          color: Colors.blue,
          backgroundColor: Colors.white,
          child: SingleChildScrollView(
            physics:
                const AlwaysScrollableScrollPhysics(), // Required for pull-to-refresh
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
                    SalesCard(
                      imagePath: "assets/images/totalsales.png",
                      label: "Total Sales",
                      value: NumberFormatter.compact(
                        controller.totalSales.value.toDouble(),
                      ),
                    ),
                    const SizedBox(width: 0),
                    SalesCard(
                      imagePath: "assets/images/totalintake.png",
                      label: "Total Intake",
                      value: NumberFormatter.compact(
                        controller.totalIntake.value.toDouble(),
                      ),
                    ),
                    const SizedBox(width: 0),
                    SalesCard(
                      imagePath: "assets/images/earningss.png",
                      label: "Total Profit",
                      value: NumberFormatter.compact(
                        controller.totalProfit.value.toDouble(),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 16),

                // Payment Breakdown Row
                Row(
                  children: [
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.1),
                              spreadRadius: 1,
                              blurRadius: 5,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Column(
                          children: [
                            Text(
                              "Cash Sales",
                              style: AppTextStyles.description,
                            ),
                            Text(
                              NumberFormatter.currency(
                                controller.cashSales.value,
                              ), // ✅ updated
                              style: AppTextStyles.heading.copyWith(
                                fontSize: 18,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.1),
                              spreadRadius: 1,
                              blurRadius: 5,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Column(
                          children: [
                            Text(
                              "Online Sales",
                              style: AppTextStyles.description,
                            ),
                            Text(
                              NumberFormatter.currency(
                                controller.onlineSales.value,
                              ), // ✅ updated
                              style: AppTextStyles.heading.copyWith(
                                fontSize: 18,
                              ),
                            ),
                          ],
                        ),
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
                        income: controller.formatCurrency(
                          controller.cashSales.value,
                        ),
                        profit: controller.formatCurrency(
                          controller.cashProfit.value,
                        ),
                        imagePath: "assets/images/cash_earning.png",
                        onSeeAll: () => Get.to(() => OfflineEarningsScreen()),
                        label: "Cash Earnings",
                      ),
                    ),
                    const SizedBox(width: 12),
                    Flexible(
                      child: EarningsCard(
                        income: controller.formatCurrency(
                          controller.onlineSales.value,
                        ),
                        profit: controller.formatCurrency(
                          controller.onlineProfit.value,
                        ),
                        imagePath: "assets/images/online_earning.png",
                        onSeeAll: () => Get.to(() => OnlineEarningsScreen()),
                        label: "Online Earnings",
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
                    if (constraints.maxWidth >= 800) {
                      crossAxisCount = 4;
                    } else if (constraints.maxWidth >= 600)
                      // ignore: curly_braces_in_flow_control_structures
                      crossAxisCount = 3;

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
                            "icon": "assets/images/addproduct.png",
                            "screen": const ProductScreen(),
                          },
                          {
                            "label": "Add Intake",
                            "icon": "assets/images/intakeadd.png",
                            "screen": AddIntake(),
                          },
                          {
                            "label": "Add Sale",
                            "icon": "assets/images/Addsalee.png",
                            "screen": Sales(),
                          },
                          {
                            "label": "Add Expense",
                            "icon": "assets/images/AddExpensee.png",
                            "screen": const AddExpenseScreen(),
                          },
                          {
                            "label": "Return",
                            "icon": "assets/images/return.png",
                            "screen": const ReturnProduct(),
                          },
                          {
                            "label": "Add Expense Category",
                            "icon": "assets/images/Category.png",
                            "screen": AddCategoryPage(),
                          },
                          {
                            "label": "Loan & amount due",
                            "icon": "assets/images/loanamountdue.png",
                            "screen": AmountCreditScreen(),
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
                  onTap: () => Get.to(() => ReportsMainPage()),
                ),
                const SizedBox(height: 30),
              ],
            ),
          ),
        );
      }),
    );
  }
}
