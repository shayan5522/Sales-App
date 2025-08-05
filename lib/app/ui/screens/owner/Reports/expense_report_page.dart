import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:salesapp/app/themes/colors.dart';
import 'package:salesapp/app/themes/styles.dart';
import 'package:salesapp/app/ui/screens/owner/Reports/expense_report_controller.dart';
import 'package:salesapp/app/ui/widgets/Expense/expensecard.dart';
import 'package:salesapp/app/ui/widgets/Expense/expenselist.dart';
import 'package:salesapp/app/ui/widgets/datepicker.dart';
import 'package:salesapp/app/ui/widgets/chart.dart';
import 'package:salesapp/app/ui/widgets/appbar.dart';

class ExpenseReportPage extends StatefulWidget {
  const ExpenseReportPage({super.key});

  @override
  State<ExpenseReportPage> createState() => _ExpenseReportPageState();
}

class _ExpenseReportPageState extends State<ExpenseReportPage> {
  final controller = Get.put(ExpenseReportController());

  DateTime? fromDate;
  DateTime? toDate;

  @override
  void initState() {
    super.initState();
    controller.fetchExpenses();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppbar(title: 'Expense Report'),
      backgroundColor: const Color(0xFFD8EAED),
      body: Obx(() {
        final chartData = controller.getCategoryTotals().entries.map((e) {
          return BarData(label: e.key, value: e.value.toDouble());
        }).toList();

        return SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// 🔹 DATE PICKERS
              Row(
                children: [
                  Expanded(
                    child: CustomDatePicker(
                      label: "From Date",
                      onDateSelected: (date) {
                        setState(() => fromDate = date);
                        controller.filterByDateRange(from: fromDate, to: toDate);
                      },
                      initialDate: fromDate ?? DateTime.now(),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: CustomDatePicker(
                      label: "To Date",
                      onDateSelected: (date) {
                        setState(() => toDate = date);
                        controller.filterByDateRange(from: fromDate, to: toDate);
                      },
                      initialDate: toDate ?? DateTime.now(),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              /// 🔹 CHART
              const Text(
                "Total Expense Per Category",
                style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
              ),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppColors.secondary,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: ResponsiveBarChart(
                  maxYValue: chartData.map((e) => e.value).fold<double>(0.0, (p, c) => c > p ? c : p),
                  yAxisSteps: [0, 2, 4, 6, 8],
                  data: chartData,
                ),
              ),
              const SizedBox(height: 16),

              /// 🔹 EXPENSE CARDS GRID
              LayoutBuilder(
                builder: (context, constraints) {
                  final isWideScreen = constraints.maxWidth > 600;
                  final grouped = controller.getCategorySummary();
                  return GridView.count(
                    crossAxisCount: isWideScreen ? 3 : 2,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    mainAxisSpacing: 12,
                    crossAxisSpacing: 12,
                    childAspectRatio: 0.95,
                    children: grouped.entries.map((e) {
                      final category = e.key;
                      final data = e.value;
                      return ExpenseCard(
                        title: category,
                        description: data['description'] ?? 'No description',
                        price: (data['amount'] as double).toInt(),
                      );
                    }).toList(),
                  );
                },
              ),
              const SizedBox(height: 20),

              /// 🔹 CURRENT DATE RANGE
              if (fromDate != null && toDate != null)
                Text(
                  "${DateFormat("dd MMM yyyy").format(fromDate!)} - ${DateFormat("dd MMM yyyy").format(toDate!)}",
                  style: AppTextStyles.title.copyWith(fontWeight: FontWeight.w600),
                ),

              const SizedBox(height: 12),

              /// 🔹 EXPENSE LIST
              if (controller.filteredExpenses.isEmpty)
                const Text("No expenses found."),
              ...controller.filteredExpenses.map((exp) {
                return CustomExpenseListTile(
                  title: exp['title'],
                  description: exp['description'],
                  price: (exp['amount'] as num).toInt(),
                );
              }).toList(),
            ],
          ),
        );
      }),
    );
  }
}
