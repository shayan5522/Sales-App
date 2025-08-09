import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:salesapp/app/themes/colors.dart';
import 'package:salesapp/app/themes/styles.dart';
import 'package:salesapp/app/ui/widgets/appbar.dart';
import 'package:salesapp/app/ui/widgets/datepicker.dart';
import 'package:salesapp/app/ui/widgets/chart.dart';
import 'package:salesapp/app/ui/widgets/Amountcard.dart';
import 'package:salesapp/app/ui/widgets/intakeproduct.dart';
import 'stock_report_controller.dart'; // make sure to import the controller

class StockReportPage extends StatelessWidget {
  const StockReportPage({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(StockReportController());

    final isWide = MediaQuery.of(context).size.width >= 600;

    return Scaffold(
      appBar: CustomAppbar(title: "Stock report",),
      backgroundColor: Colors.white70,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Obx(() {
          if (controller.isLoading.value) {
            return Center(child: CircularProgressIndicator(color: AppColors.primary));
          }

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// 🔹 DATE PICKERS
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  CustomDatePicker(
                    label: "From Date",
                    onDateSelected: controller.setFromDate,
                    initialDate: controller.fromDate.value,
                  ),
                  CustomDatePicker(
                    label: "To Date",
                    onDateSelected: controller.setToDate,
                    initialDate: controller.toDate.value,
                  ),
                ],
              ),
              const SizedBox(height: 16),

              /// 🔹 CHART SECTION
              const Text("Total Stock by category", style: TextStyle(fontWeight: FontWeight.w600)),
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
                  data: controller.intakeItems
                      .map((item) => BarData(label: item.title, value: item.total))
                      .toList(),
                ),
              ),

              const SizedBox(height: 16),

              /// 🔹 CREDIT + TOTAL VALUE CARDS
              Row(
                children: [
                  Expanded(
                    child: CenteredAmountCard(
                      title: "Credit Amount",
                      subtitle: "${controller.totalQuantity.value} pcs",
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: CenteredAmountCard(
                      title: "Total Value",
                      subtitle: "INR. ${controller.totalValue.value.toStringAsFixed(2)}",
                    ),
                  ),
                ],
              ),

              /// 🔹 GEAR ICON
              const SizedBox(height: 2),
              Align(
                alignment: Alignment.centerRight,
                child: IconButton(
                  onPressed: () {},
                  icon: const Icon(Icons.settings, color: AppColors.primary),
                ),
              ),

              /// 🔹 PRODUCT LIST
              ...controller.intakeItems.map((item) => IntakeProduct(
                imagePath: item.imagePath,
                productName: item.title,
                intaken: item.quantity,
                stockCount: 0, // Optional: replace with actual stock count if available
                totalexpense: item.total.toInt(),
              )),
            ],
          );
        }),
      ),
    );
  }
}
