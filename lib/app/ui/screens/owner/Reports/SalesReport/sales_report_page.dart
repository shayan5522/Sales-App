import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shoporbit/app/themes/colors.dart';
import 'package:shoporbit/app/themes/styles.dart';
import 'package:shoporbit/app/ui/screens/owner/Reports/SalesReport/sales_report_controller.dart';
import 'package:shoporbit/app/ui/widgets/appbar.dart';
import 'package:shoporbit/app/ui/widgets/datepicker.dart';
import 'package:shoporbit/app/ui/widgets/chart.dart';
import '../../../../widgets/sale/salereportlist.dart';
import 'all_products_page.dart';

class SalesReportPage extends StatelessWidget {
  SalesReportPage({super.key}) {
    Get.put(SalesReportController());
  }

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<SalesReportController>();

    return Scaffold(
      appBar: CustomAppbar(title: "Sales Report"),
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
                    restrictToToday: true,
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
              const Text("Total Sales Per Product", style: TextStyle(fontWeight: FontWeight.w600)),
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

              /// 🔹 SUMMARY CARDS GRID (Always 2 per row)
              LayoutBuilder(
                builder: (context, constraints) {
                  final itemWidth = (constraints.maxWidth - 12) / 2;
                  final productSummary = controller.getProductSummaryData();
                  final limitedSummary = productSummary.entries.take(4).toList();


                  return Wrap(
                    spacing: 12,
                    runSpacing: 12,
                    children: [
                      ...limitedSummary.map((entry) {
                        final data = entry.value;
                        final profit = (data['totalSales'] as double) - (data['totalIntake'] as double);

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
                              Center(child: Image.network(data['imagePath'], height: 50, width: 50, fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) => Image.asset(
                                  "assets/images/image_unavailable.png",
                                  height: 50,
                                  width: 50,
                                  fit: BoxFit.cover,
                                ),)),
                              const SizedBox(height: 8),
                              Text(entry.key, style: AppTextStyles.subtitleSmall.copyWith(fontWeight: FontWeight.bold)),
                              const SizedBox(height: 4),
                              Text("Sales: ₹${(data['totalSales'] as double).toStringAsFixed(2)}"),
                              Text("Quantity: ${data['totalQuantity']} sold"),
                              Text(
                                "Profit: ₹${profit.toStringAsFixed(2)}",
                                style: TextStyle(color: profit >= 0 ? Colors.green : Colors.red),
                              ),
                            ],
                          ),
                        );
                      }).toList(),

                      // "View All" Button
                      GestureDetector(
                        onTap: () {
                           Get.to(() => AllProductsPage(productSummary: productSummary));
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
              const SizedBox(height: 24),

              /// 🔹 SALES LIST
              ..._buildSalesList(controller),
            ],
          ),
        );
      }),
    );
  }

  List<Widget> _buildSalesList(SalesReportController controller) {
    if (controller.salesData.isEmpty) {
      return [
        const Center(
          child: Text("No sales data available for selected date range"),
        ),
      ];
    }

    // Group sales by date
    final salesByDate = <DateTime, List<Map<String, dynamic>>>{};
    for (var sale in controller.salesData) {
      final saleDate = (sale['createdAt'] as DateTime);
      final dateKey = DateTime(saleDate.year, saleDate.month, saleDate.day);

      if (!salesByDate.containsKey(dateKey)) {
        salesByDate[dateKey] = [];
      }
      salesByDate[dateKey]!.add(sale);
    }

    // Build widgets for each date group
    return salesByDate.entries.map((entry) {
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
          ...entry.value.expand((sale) {
            final items = List<Map<String, dynamic>>.from(sale['items'] ?? []);
            return items.map((item) => Salereportlist(
              imagePath: item['imagePath'] ?? "assets/images/products.png",
              name: item['title'] ?? "Unknown Product",
              Quantity: "${item['quantity']}",
              amount: "${(item['price'] * item['quantity']).toStringAsFixed(2)}",
            ));
          }),
        ],
      );
    }).toList();
  }
}

/// 🔹 Responsive Summary Card Widget
Widget saleSummaryCard({
  required double width,
  required String title,
  required String value,
}) {
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
              Text(title, style: AppTextStyles.subtitleSmall.copyWith(fontWeight: FontWeight.bold)),
              const SizedBox(height: 4),
              Text(value, style: AppTextStyles.subtitleSmall.copyWith(
                fontSize: 16,
                color: Colors.blue[900],
                fontWeight: FontWeight.bold,
              )),
            ],
          ),
        ),
      ],
    ),
  );
}
