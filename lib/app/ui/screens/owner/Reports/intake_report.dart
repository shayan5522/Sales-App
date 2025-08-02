import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:salesapp/app/themes/colors.dart';
import 'package:salesapp/app/themes/styles.dart';
import 'package:salesapp/app/ui/widgets/chart.dart';
import 'package:salesapp/app/ui/widgets/datepicker.dart';
import 'package:salesapp/app/ui/widgets/intakeproduct.dart';
import 'package:salesapp/app/ui/widgets/sale/salereportlist.dart';

class IntakeReportPage extends StatelessWidget {
  const IntakeReportPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue[900],
        title: const Text("Intake Report", style: TextStyle(color: Colors.white)),
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
              child:  ResponsiveBarChart(
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
            /// 🔹 SUMMARY CARDS (2 per row)
            Padding(
              padding: const EdgeInsets.only(top: 8),
              child: GridView.count(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisCount: 2,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: 2.8,
                children: List.generate(4, (index) {
                  return IntakeProduct(
                    imagePath: "assets/images/products.png",
                    productName: "Product ${index + 1}",
                    intaken: 20,
                    totalexpense: 100,
                  );
                }),
              ),
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
