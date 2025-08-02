import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:salesapp/app/themes/colors.dart';
import 'package:salesapp/app/themes/styles.dart';
import 'package:salesapp/app/ui/widgets/Expense/expensecard.dart';
import 'package:salesapp/app/ui/widgets/Expense/expenselist.dart';
import 'package:salesapp/app/ui/widgets/datepicker.dart';
import 'package:salesapp/app/ui/widgets/chart.dart';
import 'package:salesapp/app/ui/widgets/appbar.dart';

class ExpenseReportPage extends StatelessWidget {
  const ExpenseReportPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppbar(title: 'Expense Report'),
      backgroundColor: const Color(0xFFD8EAED),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// 🔹 DATE PICKERS
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: CustomDatePicker(
                    label: "From Date",
                    onDateSelected: (_) {},
                    initialDate: DateTime.now(),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: CustomDatePicker(
                    label: "To Date",
                    onDateSelected: (_) {},
                    initialDate: DateTime.now(),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            /// 🔹 CHART TITLE
            const Text(
              "Total Expense Per Category",
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 8),

            /// 🔹 BAR CHART
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.secondary,
                borderRadius: BorderRadius.circular(12),
              ),
              child: ResponsiveBarChart(
                maxYValue: 8000,
                yAxisSteps: [0, 2, 4, 6, 8],
                data: [
                  BarData(label: 'Travel', value: 2500),
                  BarData(label: 'Supplies', value: 4000),
                  BarData(label: 'Meals', value: 3000),
                  BarData(label: 'Misc', value: 1500),
                ],
              ),
            ),
            const SizedBox(height: 16),

            /// 🔹 EXPENSE CARDS IN 2-COLUMN GRID
            LayoutBuilder(
              builder: (context, constraints) {
                final isWideScreen = constraints.maxWidth > 600;
                return GridView.count(
                  crossAxisCount: isWideScreen ? 3 : 2,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  mainAxisSpacing: 12,
                  crossAxisSpacing: 12,
                  childAspectRatio: 0.95,
                  children: const [
                    ExpenseCard(
                      title: 'Travel',
                      description: 'Trip to Karachi',
                      price: 2500,
                    ),
                    ExpenseCard(
                      title: 'Office Supplies',
                      description: 'Stationery items',
                      price: 1200,
                    ),
                    ExpenseCard(
                      title: 'Lunch Meeting',
                      description: 'Client discussion',
                      price: 1800,
                    ),
                    ExpenseCard(
                      title: 'Miscellaneous',
                      description: 'Snacks & Others',
                      price: 600,
                    ),
                  ],
                );
              },
            ),
            const SizedBox(height: 20),

            /// 🔹 DATE HEADER
            Text(
              DateFormat("dd, MMMM yyyy").format(DateTime.now()),
              style: AppTextStyles.title.copyWith(fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 12),

            /// 🔹 EXPENSE LIST (DETAILED)
            const CustomExpenseListTile(
              title: 'Fuel Charges',
              description: 'Vehicle refueling',
              price: 2200,
            ),
            const CustomExpenseListTile(
              title: 'Tea & Coffee',
              description: 'Team break beverages',
              price: 1300,
            ),
            const CustomExpenseListTile(
              title: 'Team Dinner',
              description: 'Monthly meetup expense',
              price: 2000,
            ),
          ],
        ),
      ),
    );
  }
}
