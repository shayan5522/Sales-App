import 'package:flutter/material.dart';
import 'package:salesapp/app/themes/colors.dart';
import 'package:salesapp/app/themes/styles.dart';
import 'package:salesapp/app/ui/widgets/datepicker.dart';
import 'package:salesapp/app/ui/widgets/chart.dart';
import 'package:salesapp/app/ui/widgets/Amountcard.dart';
import 'package:salesapp/app/ui/widgets/intakeproduct.dart';

class StockReportPage extends StatelessWidget {
  const StockReportPage({super.key});

  @override
  Widget build(BuildContext context) {
    final isWide = MediaQuery.of(context).size.width >= 600;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue[900],
        title: const Text('Stock Report', style: TextStyle(color: Colors.white)),
        centerTitle: true,
        leading: const BackButton(color: Colors.white),
      ),
      backgroundColor: Colors.white70,
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

            /// 🔹 CHART SECTION
            const Text("Total Stock by category", style: TextStyle(fontWeight: FontWeight.w600)),
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
            /// 🔹 CREDIT + TOTAL VALUE CARDS
            Row(
              children: const [
                Expanded(
                  child: CenteredAmountCard(title: "Credit Amount", subtitle: "5500pcs"),
                ),
                SizedBox(width: 12),
                Expanded(
                  child: CenteredAmountCard(title: "Total Value", subtitle: "INR. 10,200"),
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
            const IntakeProduct(
              imagePath: "assets/images/products.png",
              productName: "Product A",
              intaken: 200,
              stockCount: 10,
              totalexpense: 2000,
            ),
            const IntakeProduct(
              imagePath: "assets/images/products.png",
              productName: "Product A",
              intaken: 200,
              stockCount: 10,
              totalexpense: 2000,
            ),
            const IntakeProduct(
              imagePath: "assets/images/products.png",
              productName: "Product A",
              intaken: 200,
              stockCount: 5,
              totalexpense: 2000,
            ),
            const IntakeProduct(
              imagePath: "assets/images/products.png",
              productName: "Product A",
              intaken: 200,
              stockCount: 2,
              totalexpense: 2000,
            ),
            const IntakeProduct(
              imagePath: "assets/images/products.png",
              productName: "Product A",
              intaken: 200,
              stockCount: 10,
              totalexpense: 2000,
            ),
          ],
        ),
      ),
    );
  }
}
