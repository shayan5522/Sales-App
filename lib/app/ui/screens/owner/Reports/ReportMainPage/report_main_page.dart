import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:salesapp/app/themes/colors.dart';
import 'package:salesapp/app/themes/styles.dart';
import 'package:salesapp/app/ui/screens/owner/Reports/ReportMainPage/reports_main_page_controller.dart';
import 'package:salesapp/app/ui/screens/owner/Reports/ReturnReport/returnreport.dart';
import 'package:salesapp/app/ui/screens/owner/Reports/SalesReport/sales_report_page.dart';
import 'package:salesapp/app/ui/screens/owner/Reports/StockReport/stock_report.dart';
import 'package:salesapp/app/ui/widgets/Admindashboard/dashboard_main-container.dart';
import 'package:salesapp/app/ui/widgets/appbar.dart';
import 'package:salesapp/app/ui/widgets/summarycard.dart';
import '../../../../widgets/datepicker.dart';
import '../Credit_Debit_Page.dart';
import '../ExpenseReport/expense_report_page.dart';
import '../IntakeReport/intake_report.dart';

class ReportsMainPage extends StatelessWidget {
  ReportsMainPage({super.key}) {
    Get.put(ReportsController());
  }

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<ReportsController>();

    Future<void> _refreshData() async {
      await controller.fetchAllTotals();
    }

    return Scaffold(
      backgroundColor: const Color(0xFFF6F6F9),
      appBar: const CustomAppbar(
        title: 'Reports',
        centerTitle: true,
        showBackButton: false,
        leading: null,
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        return RefreshIndicator(
          onRefresh: _refreshData,
          color: AppColors.primary,
          backgroundColor: Colors.white,
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Total Summary Heading
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(
                      width: 140,
                      child: CustomDatePicker(
                        label: 'Starting Date',
                        initialDate: controller.selectedStartDate.value,
                        onDateSelected: (newDate) {
                          controller.selectedStartDate.value = newDate;
                          controller.fetchAllTotals();
                        },
                      ),
                    ),
                    SizedBox(
                      width: 140,
                      child: CustomDatePicker(
                        label: 'Ending Date',
                        initialDate: controller.selectedEndDate.value,
                        onDateSelected: (newDate) {
                          controller.selectedEndDate.value = newDate;
                          controller.fetchAllTotals();
                        },
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 10),
                Text("Total Summary", style: AppTextStyles.heading),
                const SizedBox(height: 10),

                // Summary Cards Row
                Row(
                  children: [
                    Expanded(
                      child: SummaryCard(
                        amount: controller.formatCurrency(controller.salesAmount.value),
                        label: "Sale Amount",
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: SummaryCard(
                        amount: controller.formatCurrency(controller.intakeAmount.value),
                        label: "Intake Amount",
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: SummaryCard(
                        amount: controller.formatCurrency(controller.expenseAmount.value),
                        label: "Expense Amount",
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // Total Profit Box
                Container(
                  height: 80,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  margin: const EdgeInsets.symmetric(vertical: 12),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.2),
                        spreadRadius: 2,
                        blurRadius: 8,
                        offset: const Offset(0, 4),
                      )
                    ],
                    border: Border.all(color: Colors.grey.shade300),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Left colored bar + icon + label
                      Row(
                        children: [
                          // Left vertical bar (blue rounded left edge)
                          Container(
                            width: 26,
                            height: 58,
                            decoration: BoxDecoration(
                              color: Colors.blue[800],
                              borderRadius: const BorderRadius.only(
                                topLeft: Radius.circular(10),
                                bottomLeft: Radius.circular(10),
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          // Icon and Label
                          Row(
                            children: [
                              const Icon(Icons.monetization_on_rounded,
                                  color: Colors.green, size: 28),
                              const SizedBox(width: 8),
                              Text(
                                'Total Profit',
                                style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 16,
                                  color: Colors.black87,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      // Right end bar with amount
                      Row(
                        children: [
                          Text(
                            controller.formatCurrency(controller.profitAmount.value),
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.deepPurple,
                            ),
                          ),
                          const SizedBox(width: 10),
                          // Right vertical bar (blue rounded right edge)
                          Container(
                            width: 26,
                            height: 58,
                            decoration: BoxDecoration(
                              color: Colors.blue[400],
                              borderRadius: const BorderRadius.only(
                                topRight: Radius.circular(10),
                                bottomRight: Radius.circular(10),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),

                // Profit Breakdown Row
                Row(
                  children: [
                    _profitBox("Profit Amount in Cash", controller.cashProfit.value),
                    const SizedBox(width: 12),
                    _profitBox("Profit Amount Online", controller.onlineProfit.value),
                  ],
                ),
                const SizedBox(height: 32),

                // Quick Actions Section
                Text("Quick Actions", style: AppTextStyles.heading),
                const SizedBox(height: 16),

                GridView.count(
                  crossAxisCount: 2,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                  childAspectRatio: 1,
                  children: [
                    MainContainer(
                      imagePath: "assets/images/stock.png",
                      label: "Stock",
                      onTap: () => Get.to(() => const StockReportPage()),
                    ),
                    MainContainer(
                      imagePath: "assets/images/intake.png",
                      label: "Intake",
                      onTap: () => Get.to(() => IntakeReportPage()),
                    ),
                    MainContainer(
                      imagePath: "assets/images/sales1111.png",
                      label: "Sales",
                      onTap: () => Get.to(() => SalesReportPage()),
                    ),
                    MainContainer(
                      imagePath: "assets/images/Expense.png",
                      label: "Expense",
                      onTap: () => Get.to(() => const ExpenseReportPage()),
                    ),
                    MainContainer(
                      imagePath: "assets/images/return_report.png",
                      label: "Return Report",
                      onTap: () => Get.to(() => const ReturnReport()),
                    ),
                    MainContainer(
                      imagePath: "assets/images/CD_report.png",
                      label: "Loan & Due Report",
                      onTap: () => Get.to(() => const CreditDebitPage()),
                    ),
                  ],
                ),
                const SizedBox(height: 30),
              ],
            ),
          ),
        );
      }),
    );
  }

  Widget _profitBox(String label, double amount) {
    final controller = Get.find<ReportsController>();
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: AppColors.secondary,
          borderRadius: BorderRadius.circular(12),
          boxShadow: const [
            BoxShadow(color: Colors.black12, blurRadius: 4, offset: Offset(0, 2)),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label, style: AppTextStyles.description.copyWith(fontSize: 13)),
            const SizedBox(height: 8),
            Row(
              children: [
                const Icon(Icons.currency_rupee, size: 18, color: AppColors.primary),
                Text(
                  controller.formatCurrency(amount),
                  style: AppTextStyles.heading.copyWith(fontSize: 18),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}