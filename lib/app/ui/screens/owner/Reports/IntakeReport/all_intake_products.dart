import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:salesapp/app/themes/colors.dart';
import 'package:salesapp/app/themes/styles.dart';
import 'package:salesapp/app/ui/screens/owner/Reports/IntakeReport/intake_report_controller.dart';
import 'package:salesapp/app/ui/widgets/appbar.dart';
import '../../../../widgets/datepicker.dart';

class AllIntakeProductsPage extends StatelessWidget {
  AllIntakeProductsPage({super.key, required this.productSummary});

  final Map<String, Map<String, dynamic>> productSummary;

  // Get the IntakeReportController instance
  final IntakeReportController controller = Get.find<IntakeReportController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: CustomAppbar(title: "All Intake"),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: [
            // 📅 Date Pickers
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

            // 📦 Intake Product Summary List
            Obx(() {
              final intakeSummary = controller.getProductSummaryData();

              return Expanded(
                child: controller.isLoading.value
                    ? const Center(child: CircularProgressIndicator())
                    : ListView(
                  children: intakeSummary.entries.map((entry) {
                    final data = entry.value;

                    return Card(
                      color: Colors.white,
                      elevation: 2,
                      child: ListTile(
                        tileColor: AppColors.white,
                        leading: Image.asset(
                          data['imagePath'] ?? "assets/images/products.png",
                          height: 40,
                          width: 40,
                          fit: BoxFit.cover,
                        ),
                        title: Text(
                          entry.key,
                          style: AppTextStyles.title,
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Total Intaken: ${data['totalQuantity']}",
                            ),
                            Text(
                              "Price: ₹${(data['totalPrice'] as double).toStringAsFixed(2)}",
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
