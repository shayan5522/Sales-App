import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:salesapp/app/ui/screens/owner/Reports/SalesReport/sales_report_controller.dart';
import 'package:salesapp/app/ui/widgets/appbar.dart';
import '../../../../widgets/datepicker.dart';

class AllProductsPage extends StatelessWidget {
  AllProductsPage({super.key,
    required Map<String, Map<String, dynamic>> productSummary});

  // Get the controller instance
  final SalesReportController controller = Get.find<SalesReportController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppbar(title: "All Sales"),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Obx(() => CustomDatePicker(
                  label: "From Date",
                  initialDate: controller.fromDate.value,
                  onDateSelected: (DateTime newDate) {
                    controller.updateFromDate(newDate);
                  },
                )),
                Obx(() => CustomDatePicker(
                  label: "To Date",
                  initialDate: controller.toDate.value,
                  onDateSelected: (DateTime newDate) {
                    controller.updateToDate(newDate);
                  },
                )),
              ],
            ),
            const SizedBox(height: 16),
            // 📦 Product Summary List
            Obx(() {
              final productSummary = controller.getProductSummaryData();

              return Expanded(
                child: controller.isLoading.value
                    ? const Center(child: CircularProgressIndicator())
                    : ListView(
                  children: productSummary.entries.map((entry) {
                    final data = entry.value;
                    final profit = (data['totalSales'] as double) -
                        (data['totalIntake'] as double);

                    return Card(
                      child: ListTile(
                        leading: Image.asset(
                          data['imagePath'],
                          height: 40,
                          width: 40,
                        ),
                        title: Text(entry.key),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Sales: ₹${(data['totalSales'] as double).toStringAsFixed(2)}",
                            ),
                            Text("Quantity: ${data['totalQuantity']} sold"),
                            Text(
                              "Profit: ₹${profit.toStringAsFixed(2)}",
                              style: TextStyle(
                                color: profit >= 0 ? Colors.green : Colors.red,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }).toList(),
                ),
              );
            }),
          ],
        ),
      ),
    );
  }
}