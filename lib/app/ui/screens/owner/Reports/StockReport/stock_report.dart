import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:salesapp/app/themes/colors.dart';
import 'package:salesapp/app/ui/widgets/appbar.dart';
import 'package:salesapp/app/ui/widgets/datepicker.dart';
import 'package:salesapp/app/ui/widgets/chart.dart';
import 'package:salesapp/app/ui/widgets/Amountcard.dart';
import 'package:salesapp/app/ui/widgets/intakeproduct.dart';
import 'stock_report_controller.dart';

class StockReportPage extends StatelessWidget {
  const StockReportPage({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(StockReportController());

    return Scaffold(
      appBar: CustomAppbar(title: "Stock Report"),
      backgroundColor: AppColors.backgroundColor,
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
              const Text("Total Stock", style: TextStyle(fontWeight: FontWeight.w600)),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppColors.secondary,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: ResponsiveBarChart(
                  maxYValue: controller.getMaxChartValue(),
                  yAxisSteps: controller.getYAxisSteps(),
                  data: controller.getProductChartData(),
                ),
              ),
              const SizedBox(height: 16),

              /// 🔹 SUMMARY CARDS
              Row(
                children: [
                  Expanded(
                    child: CenteredAmountCard(
                      title: "Total Stock",
                      subtitle: "${controller.totalItems.value} pcs",
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: CenteredAmountCard(
                      title: "Total Value",
                      subtitle: "INR ${controller.totalValue.value.toStringAsFixed(2)}",
                    ),
                  ),
                ],
              ),

              /// 🔹 PRODUCT LIST
              const SizedBox(height: 16),
              Column(
                children: controller.stockList.map((product) {
                  return IntakeProduct(
                    imagePath: product['imagePath'] ?? "assets/images/products.png",
                    productName: product['title'] ?? 'Unknown',
                    intaken: product['purchaseQty'] ?? 0,
                    stockCount: product['currentStock'] ?? 0,
                    totalexpense: (product['totalValue'] ?? 0).toInt(),
                  );
                }).toList(),
              ),
            ],
          ),
        );
      }),
    );
  }
}
