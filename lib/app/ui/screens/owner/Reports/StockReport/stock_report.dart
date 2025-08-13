import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:salesapp/app/themes/colors.dart';
import 'package:salesapp/app/ui/widgets/appbar.dart';
import 'package:salesapp/app/ui/widgets/datepicker.dart';
import 'package:salesapp/app/ui/widgets/chart.dart';
import 'package:salesapp/app/ui/widgets/Amountcard.dart';
import 'package:salesapp/app/ui/widgets/intakeproduct.dart';
import '../../../../../themes/styles.dart';
import 'all_stock.dart';
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
              const SizedBox(height: 16),

              /// 🔹 TOP PRODUCTS GRID
              // const Text("Top Products", style: TextStyle(fontWeight: FontWeight.w600)),
              // const SizedBox(height: 8),
              LayoutBuilder(
                builder: (context, constraints) {
                  final topProducts = controller.stockList.take(4).toList();

                  return Wrap(
                    spacing: 12,
                    runSpacing: 12,
                    children: [
                      ...topProducts.map((product) {
                        return Container(
                          width: (MediaQuery.of(context).size.width - 48) / 2,
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
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Center(
                                child: Image.asset(
                                  product['imagePath'] ?? "assets/images/products.png",
                                  height: 50,
                                  width: 50,
                                  fit: BoxFit.cover,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(product['title'],
                                  style: AppTextStyles.subtitleSmall.copyWith(fontWeight: FontWeight.bold)),
                              const SizedBox(height: 4),
                              Text("Purchased: ${product['purchaseQty']}"),
                              Text("Sold: ${product['soldQty']}"),
                              Text("Stock: ${product['currentStock']}"),
                              Text("Value: ₹${(product['totalValue'] as double).toStringAsFixed(2)}"),
                            ],
                          ),
                        );
                      }).toList(),

                      /// View All Button
                      if (controller.stockList.length > 4)
                        GestureDetector(
                            onTap: () {
                              Get.to(() => const AllStockProductsPage());
                          },
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