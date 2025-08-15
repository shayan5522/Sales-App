import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:salesapp/app/themes/colors.dart';
import 'package:salesapp/app/themes/styles.dart';
import 'package:salesapp/app/ui/widgets/appbar.dart';
import 'package:salesapp/app/ui/widgets/datepicker.dart';
import 'package:salesapp/app/ui/widgets/chart.dart';
import 'package:salesapp/app/ui/widgets/Amountcard.dart';
import 'package:salesapp/app/ui/widgets/intakeproduct.dart';
import 'all_stock.dart';
import 'stock_report_controller.dart';

class StockReportPage extends StatelessWidget {
  const StockReportPage({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(StockReportController());

    // Helper method to group stock items by date
    List<Widget> _buildGroupedStockList() {
      final stockByDate = <DateTime, List<dynamic>>{};

      for (var product in controller.stockList) {
        DateTime productDate;

        try {
          // Handle different possible date formats
          if (product['date'] is DateTime) {
            productDate = product['date'];
          } else if (product['date'] is String) {
            productDate = DateTime.tryParse(product['date']) ?? DateTime.now();
          } else if (product['createdAt'] is DateTime) {
            productDate = product['createdAt'];
          } else if (product['createdAt'] is String) {
            productDate = DateTime.tryParse(product['createdAt']) ?? DateTime.now();
          } else {
            productDate = DateTime.now();
          }

          final dateKey = DateTime(productDate.year, productDate.month, productDate.day);

          if (!stockByDate.containsKey(dateKey)) {
            stockByDate[dateKey] = [];
          }
          stockByDate[dateKey]!.add(product);
        } catch (e) {
          final dateKey = DateTime.now();
          if (!stockByDate.containsKey(dateKey)) {
            stockByDate[dateKey] = [];
          }
          stockByDate[dateKey]!.add(product);
        }
      }

      // Sort dates in descending order
      final sortedDates = stockByDate.keys.toList()
        ..sort((a, b) => b.compareTo(a));

      return sortedDates.map((date) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Date header
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

            // Products for this date
            ...stockByDate[date]!.map((product) {
              return IntakeProduct(
                imagePath: product['imagePath'] ?? "assets/images/products.png",
                productName: product['title'] ?? 'Unknown',
                intaken: product['purchaseQty'] ?? 0,
                stockCount: product['currentStock'] ?? 0,
                totalexpense: (product['totalValue'] ?? 0).toInt(),
              );
            }).toList(),
          ],
        );
      }).toList();
    }

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
                    lastDate: controller.toDate.value,
                    restrictToToday: true,
                  ),
                  CustomDatePicker(
                    label: "To Date",
                    onDateSelected: controller.updateToDate,
                    initialDate: controller.toDate.value,
                    firstDate: controller.fromDate.value, // Can't be before fromDate
                    lastDate: DateTime.now(), // Can't be after today
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

                      if (controller.stockList.length > 4)
                        SizedBox(
                          width: double.infinity,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              /// View All button
                              GestureDetector(
                                onTap: () => Get.to(() => const AllStockProductsPage()),
                                child: Container(
                                  padding: const EdgeInsets.all(12),
                                  decoration: BoxDecoration(
                                    color: Colors.blue.shade50,
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Text(
                                    "View All",
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.blue,
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 8),

                              /// Settings Icon button
                              GestureDetector(
                                onTap: () {
                                  // TODO: Open settings page
                                },
                                child: IconButton(
                                  icon: Icon(Icons.settings,color: AppColors.primary,),
                                  onPressed: () {  },
                                ),
                              ),
                            ],
                          ),
                        ),


                    ],
                  );
                },
              ),

              /// 🔹 PRODUCT LIST GROUPED BY DATE
              if (controller.stockList.isEmpty)
                const Text("No stock items found."),
              ..._buildGroupedStockList(),
            ],
          ),
        );
      }),
    );
  }
}