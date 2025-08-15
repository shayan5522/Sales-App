import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:salesapp/app/themes/colors.dart';
import 'package:salesapp/app/themes/styles.dart';
import 'package:salesapp/app/ui/widgets/Expense/expenselist.dart';
import 'package:salesapp/app/ui/widgets/appbar.dart';
import 'package:salesapp/app/ui/widgets/datepicker.dart';

import '../ExpenseReport/expense_report_controller.dart';

class AllExpensesPage extends StatelessWidget {
  const AllExpensesPage({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<ExpenseReportController>();

    return Scaffold(
      appBar: CustomAppbar(title: "All Expenses"),
      backgroundColor: AppColors.backgroundColor,
      body: Obx(() {
        return SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// 🔹 DATE FILTERS
              Row(
                children: [
                  Expanded(
                    child: CustomDatePicker(
                      label: "From Date",
                      onDateSelected: (date) {
                        controller.filterByDateRange(from: date, to: controller.toDate);
                      },
                      initialDate: controller.fromDate ?? DateTime.now(),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: CustomDatePicker(
                      label: "To Date",
                      onDateSelected: (date) {
                        controller.filterByDateRange(from: controller.fromDate, to: date);
                      },
                      initialDate: controller.toDate ?? DateTime.now(),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              /// 🔹 TOTAL EXPENSE SUMMARY
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.secondary,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "Total Expense:",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      "₹${controller.filteredExpenses.fold<double>(0.0, (sum, expense) => sum + (expense['amount'] as num).toDouble()).toStringAsFixed(2)}",
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: AppColors.primary,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              /// 🔹 DATE RANGE DISPLAY
              if (controller.fromDate != null || controller.toDate != null)
                Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: Text(
                    "${controller.fromDate != null ? DateFormat("dd MMM yyyy").format(controller.fromDate!) : "Start"} - ${controller.toDate != null ? DateFormat("dd MMM yyyy").format(controller.toDate!) : "End"}",
                    style: AppTextStyles.title.copyWith(fontWeight: FontWeight.w600),
                  ),
                ),

              /// 🔹 EXPENSE LIST
              if (controller.filteredExpenses.isEmpty)
                const Center(
                  child: Padding(
                    padding: EdgeInsets.all(32),
                    child: Text(
                      "No expenses found for the selected date range",
                      style: TextStyle(color: Colors.grey),
                    ),
                  ),
                ),
              ...controller.filteredExpenses.map((exp) {
                return CustomExpenseListTile(
                  title: exp['title'],
                  description: exp['description'],
                  price: (exp['amount'] as num).toInt(),
                  // date: DateFormat("dd MMM yyyy").format(exp['date'] as DateTime),
                );
              }).toList(),
            ],
          ),
        );
      }),
    );
  }
}