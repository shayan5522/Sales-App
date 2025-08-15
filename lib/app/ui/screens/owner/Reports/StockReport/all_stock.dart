import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:salesapp/app/themes/colors.dart';
import 'package:salesapp/app/themes/styles.dart';
import 'package:salesapp/app/ui/widgets/appbar.dart';
import 'package:salesapp/app/ui/widgets/datepicker.dart';

import 'stock_report_controller.dart';

class AllStockProductsPage extends StatelessWidget {
  const AllStockProductsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<StockReportController>();
    final totalValue = controller.stockList.fold<double>(
        0.0, (sum, product) => sum + (product['totalValue'] as double));

    return Scaffold(
      appBar: CustomAppbar(title: "All Stock Products"),
      backgroundColor: AppColors.backgroundColor,
      body: Obx(() {
        return SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// 🔹 DATE FILTERS
              Row(
                children: [
                  Expanded(
                    child: CustomDatePicker(
                      label: "From Date",
                      onDateSelected: controller.updateFromDate,
                      initialDate: controller.fromDate.value,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: CustomDatePicker(
                      label: "To Date",
                      onDateSelected: controller.updateToDate,
                      initialDate: controller.toDate.value,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              /// 🔹 SUMMARY
              // Container(
              //   padding: const EdgeInsets.all(16),
              //   decoration: BoxDecoration(
              //     color: AppColors.secondary,
              //     borderRadius: BorderRadius.circular(12),
              //   ),
              //   child: Row(
              //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //     children: [
              //       Column(
              //         crossAxisAlignment: CrossAxisAlignment.start,
              //         children: [
              //           const Text("Total Products", style: TextStyle(fontSize: 14)),
              //           Text("${controller.stockList.length}",
              //               style: AppTextStyles.title),
              //         ],
              //       ),
              //       Column(
              //         crossAxisAlignment: CrossAxisAlignment.end,
              //         children: [
              //           const Text("Total Stock Value", style: TextStyle(fontSize: 14)),
              //           Text("₹${totalValue.toStringAsFixed(2)}",
              //               style: AppTextStyles.title.copyWith(color: AppColors.primary)),
              //         ],
              //       ),
              //     ],
              //   ),
              // ),
              // const SizedBox(height: 16),

              /// 🔹 PRODUCT GRID
              if (controller.stockList.isEmpty)
                const Center(
                  child: Padding(
                    padding: EdgeInsets.all(32),
                    child: Text(
                      "No products found for the selected date range",
                      style: TextStyle(color: Colors.grey),
                    ),
                  ),
                ),
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: controller.stockList.length,
                itemBuilder: (context, index) {
                  final product = controller.stockList[index];
                  return Container(
                    margin: const EdgeInsets.only(bottom: 12),
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
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Image.asset(
                          product['imagePath'] ?? "assets/images/products.png",
                          height: 60,
                          width: 60,
                          fit: BoxFit.cover,
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                product['title'],
                                style: AppTextStyles.subtitleSmall.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text("Purchased: ${product['purchaseQty']}"),
                                      Text("Sold: ${product['soldQty']}"),
                                    ],
                                  ),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      Text("Stock: ${product['currentStock']}"),
                                      Text(
                                        "Value: ₹${(product['totalValue'] as double).toStringAsFixed(2)}",
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: AppColors.primary,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ],
          ),
        );
      }),
    );
  }
}