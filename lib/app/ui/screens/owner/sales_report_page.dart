import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:salesapp/app/themes/colors.dart';
import 'package:salesapp/app/themes/styles.dart';
import 'package:salesapp/app/ui/widgets/datepicker.dart';
import 'package:salesapp/app/ui/widgets/chart.dart';
import 'package:salesapp/app/ui/widgets/intakeproduct.dart';

import '../../widgets/appbar.dart';
import '../../widgets/sale/salereportlist.dart';

class SalesReportPage extends StatelessWidget {
  const SalesReportPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue[900],
        title: const Text("Sales Report", style: TextStyle(color: Colors.white)),
        centerTitle: true,
        leading: const BackButton(color: Colors.white),
      ),
      backgroundColor: const Color(0xFFF6F6F9),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// 🔹 DATE PICKERS
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                CustomDatePicker(
                  label: "From Date",
                  onDateSelected: (_) {},
                  initialDate: DateTime.now(),
                ),
                CustomDatePicker(
                  label: "To Date",
                  onDateSelected: (_) {},
                  initialDate: DateTime.now(),
                ),
              ],
            ),
            const SizedBox(height: 16),

            /// 🔹 CHART
            const Text("Total Intake Per Product", style: TextStyle(fontWeight: FontWeight.w600)),
            const SizedBox(height: 8),
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
                  BarData(label: 'Product 1', value: 4000),
                  BarData(label: 'Product 2', value: 7000),
                  BarData(label: 'Product 3', value: 5000),
                  BarData(label: 'Product 4', value: 6500),
                ],
              ),
            ),
            const SizedBox(height: 16),

            /// 🔹 SUMMARY CARDS GRID (Responsive)
            LayoutBuilder(
              builder: (context, constraints) {
                final isWide = constraints.maxWidth >= 400;
                final itemWidth = isWide
                    ? (constraints.maxWidth - 12) / 2
                    : constraints.maxWidth;

                return Wrap(
                  spacing: 12,
                  runSpacing: 12,
                  children: List.generate(4, (_) => saleSummaryCard(width: itemWidth)),
                );
              },
            ),

            const SizedBox(height: 24),

            /// 🔹 DATE SECTION HEADING
            Text(
              DateFormat("dd, MMMM yyyy").format(DateTime.now()),
              style: AppTextStyles.title.copyWith(fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 12),

            /// 🔹 PRODUCT HISTORY (List)
            const Salereportlist(
              imagePath: "assets/images/products.png",
              name: "Product A",
              Quantity: "1-100",
              amount: "2000",
            ),
            const Salereportlist(
              imagePath: "assets/images/products.png",
              name: "Product A",
              Quantity: "1-100",
              amount: "2000",
            ),
            const Salereportlist(
              imagePath: "assets/images/products.png",
              name: "Product A",
              Quantity: "1-100",
              amount: "2000",
            ),
          ],
        ),
      ),
    );
  }
}

/// 🔹 Responsive Summary Card Widget
Widget saleSummaryCard({required double width}) {
  return Container(
    width: width,
    padding: const EdgeInsets.all(12),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(12),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.03),
          blurRadius: 6,
          offset: const Offset(0, 3),
        )
      ],
    ),
    child: Row(
      children: [
        Image.asset("assets/images/report.png", height: 40),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Total: 30 sold", style: AppTextStyles.subtitleSmall),
              Text("Income: 3000", style: AppTextStyles.subtitleSmall),
              Text("Profit: 3000", style: AppTextStyles.subtitleSmall),
            ],
          ),
        ),
      ],
    ),
  );
}
