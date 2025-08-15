import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:salesapp/app/themes/colors.dart';
import 'package:salesapp/app/themes/styles.dart';
import 'package:salesapp/app/ui/screens/owner/Reports/ExpenseReport/expense_report_controller.dart';
import 'package:salesapp/app/ui/widgets/Expense/expensecard.dart';
import 'package:salesapp/app/ui/widgets/Expense/expenselist.dart';
import 'package:salesapp/app/ui/widgets/datepicker.dart';
import 'package:salesapp/app/ui/widgets/chart.dart';
import 'package:salesapp/app/ui/widgets/appbar.dart';
import 'all_expenses.dart';

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

  List<Widget> _buildGroupedExpenses() {
    final expensesByDate = <DateTime, List<dynamic>>{};

    for (var exp in controller.filteredExpenses) {
      DateTime expDate;

      try {
        if (exp['date'] is DateTime) {
          expDate = exp['date'];
        } else if (exp['date'] is String) {
          expDate = DateTime.tryParse(exp['date']) ?? DateTime.now();
        } else if (exp['createdAt'] is DateTime) {
          expDate = exp['createdAt'];
        } else if (exp['createdAt'] is String) {
          expDate = DateTime.tryParse(exp['createdAt']) ?? DateTime.now();
        } else {
          expDate = DateTime.now();
        }

        final dateKey = DateTime(expDate.year, expDate.month, expDate.day);

        if (!expensesByDate.containsKey(dateKey)) {
          expensesByDate[dateKey] = [];
        }
        expensesByDate[dateKey]!.add(exp);
      } catch (e) {
        final dateKey = DateTime.now();
        if (!expensesByDate.containsKey(dateKey)) {
          expensesByDate[dateKey] = [];
        }
        expensesByDate[dateKey]!.add(exp);
      }
    }

    final sortedDates = expensesByDate.keys.toList()
      ..sort((a, b) => b.compareTo(a));

    return sortedDates.map((date) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 16.0, bottom: 8.0),
            child: Text(
              DateFormat('dd-MMM-yyyy').format(date),
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
          ),
          ...expensesByDate[date]!.map((exp) {
            return CustomExpenseListTile(
              title: exp['title'] ?? 'No Title',
              description: exp['description'] ?? 'No Description',
              price: (exp['amount'] as num?)?.toInt() ?? 0,
            );
          }).toList(),
        ],
      );
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppbar(title: 'Expense Report'),
      backgroundColor: AppColors.backgroundColor,
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator(color: AppColors.primary,));
        }

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
                      lastDate: toDate ?? DateTime.now(), // Prevent fromDate > toDate
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
                      firstDate: fromDate, // Prevent toDate < fromDate
                      lastDate: DateTime.now(), // Can't select future dates
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
                  final firstFour = grouped.entries.take(4).toList();

                  return Column(
                    children: [
                      GridView.count(
                        crossAxisCount: isWideScreen ? 3 : 2,
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        mainAxisSpacing: 12,
                        crossAxisSpacing: 12,
                        childAspectRatio: 0.95,
                        children: firstFour.map((e) {
                          final category = e.key;
                          final data = e.value;
                          return ExpenseCard(
                            title: category,
                            description: data['description'] ?? 'No description',
                            price: (data['amount'] as double).toInt(),
                          );
                        }).toList(),
                      ),
                      const SizedBox(height: 12),
                      GestureDetector(
                        onTap: () => Get.to(() => const AllExpensesPage()),
                        child: Center(
                          child: Container(
                            width: (MediaQuery.of(context).size.width - 48) / 2,
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: Colors.blue.shade50,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const Center(
                              child: Text(
                                "View All",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.blue,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  );
                },
              ),

              const SizedBox(height: 16),

              /// 🔹 EXPENSE LIST GROUPED BY DATE
              if (controller.filteredExpenses.isEmpty)
                const Text("No expenses found."),
              ..._buildGroupedExpenses(),
            ],
          ),
        );
      }),
    );
  }
}