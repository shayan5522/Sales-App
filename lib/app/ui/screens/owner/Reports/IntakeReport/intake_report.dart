import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:salesapp/app/themes/colors.dart';
import 'package:salesapp/app/themes/styles.dart';
import 'package:salesapp/app/ui/widgets/appbar.dart';
import 'package:salesapp/app/ui/widgets/chart.dart';
import 'package:salesapp/app/ui/widgets/datepicker.dart';
import 'package:salesapp/app/ui/widgets/intakeproduct.dart';
import 'package:salesapp/app/ui/widgets/sale/salereportlist.dart';

import 'intake_report_controller.dart';

class IntakeReportPage extends StatelessWidget {
  IntakeReportPage({super.key}) {
    Get.put(IntakeReportController());
  }

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<IntakeReportController>();

    return Scaffold(
      appBar: const CustomAppbar(title: "Intake Report"),
      backgroundColor: const Color(0xFFF6F6F9),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        return SingleChildScrollView(
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
                    onDateSelected: controller.updateFromDate,
                    initialDate: controller.fromDate.value,
                  ),
                  CustomDatePicker(
                    label: "To Date",
                    onDateSelected: controller.updateToDate,
                    initialDate: controller.toDate.value,
                  ),
                ],
              ),
              const SizedBox(height: 16),

              /// 🔹 CHART
              const Text("Total Intake Per Product",
                  style: TextStyle(fontWeight: FontWeight.w600)),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppColors.secondary,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: ResponsiveBarChart(
                  maxYValue: controller.getMaxChartValue(),
                  yAxisSteps: [0, 2, 4, 6, 8],
                  data: controller.getProductChartData(),
                ),
              ),
              const SizedBox(height: 16),

              /// 🔹 SUMMARY CARDS
              _buildSummaryCards(controller),

              const SizedBox(height: 24),

              /// 🔹 INTAKE HISTORY LIST
              ..._buildIntakeHistoryList(controller),
            ],
          ),
        );
      }),
    );
  }

  Widget _buildSummaryCards(IntakeReportController controller) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: 2, // Only two boxes now
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 1.5, // Adjusted for better text display
      ),
      itemBuilder: (context, index) {
        return Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 6,
                offset: const Offset(0, 3),
              )
            ],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                index == 0 ? 'Total Intaken' : 'Total Expense',
                style: AppTextStyles.subtitleSmall.copyWith(
                  fontWeight: FontWeight.w600,
                  color: AppColors.textseconadry,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                index == 0
                    ? '${controller.totalItemsIntaken.value}'
                    : '${controller.totalExpense.value.toStringAsFixed(2)}',
                style: AppTextStyles.title.copyWith(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primary,
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  List<Widget> _buildIntakeHistoryList(IntakeReportController controller) {
    if (controller.intakeData.isEmpty) {
      return [
        const Center(
          child: Text("No intake data available for selected date range"),
        ),
      ];
    }

    // Group intakes by date
    final intakesByDate = <DateTime, List<Map<String, dynamic>>>{};
    for (var intake in controller.intakeData) {
      final intakeDate = (intake['createdAt'] as DateTime);
      final dateKey = DateTime(intakeDate.year, intakeDate.month, intakeDate.day);

      if (!intakesByDate.containsKey(dateKey)) {
        intakesByDate[dateKey] = [];
      }
      intakesByDate[dateKey]!.add(intake);
    }

    return intakesByDate.entries.map((entry) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// 🔹 DATE SECTION HEADING
          Text(
            controller.formatDate(entry.key),
            style: AppTextStyles.title.copyWith(fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 12),

          /// 🔹 PRODUCT HISTORY (List)
          ...entry.value.expand((intake) {
            final items = List<Map<String, dynamic>>.from(intake['items'] ?? []);
            return items.map((item) => Salereportlist(
              imagePath: item['imagePath'] ?? "assets/images/products.png",
              name: item['title'] ?? "Unknown Product",
              Quantity: "${item['quantity']}",
              amount: "\$${(item['price'] * item['quantity']).toStringAsFixed(2)}",
            ));
          }),
        ],
      );
    }).toList();
  }
}