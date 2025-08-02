import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:salesapp/app/themes/colors.dart';
import 'package:salesapp/app/themes/styles.dart';
import 'package:salesapp/app/ui/widgets/datepicker.dart';
import 'package:salesapp/app/ui/widgets/buttons.dart';
import '../../../widgets/Admindashboard/dashboard_main-container.dart';
import '../../../widgets/Admindashboard/earning_card.dart';
import '../../../widgets/Admindashboard/gradient_action_card.dart';
import '../../../widgets/Admindashboard/salescard.dart';
import '../../../widgets/custom_dashboard_appbar.dart'; // ✅ Import SalesCard widget

class OwnerDashboard extends StatefulWidget {
  const OwnerDashboard({super.key});
  @override
  State<OwnerDashboard> createState() => _OwnerDashboardState();
}

class _OwnerDashboardState extends State<OwnerDashboard> {
  DateTime selectedDate = DateTime.now();

  @override
  Widget build(BuildContext context) {
    final screen = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: const Color(0xFFF6F6F9),
      appBar: const CustomDashboardAppBar(
        title: "Sportify",
        logoPath: "assets/images/Add_Sales.png", // Replace with your logo
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Total Summary and Date Picker
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Total Summary", style: AppTextStyles.heading),
                SizedBox(
                  width: 150,
                  child: CustomDatePicker(
                    label: '',
                    initialDate: selectedDate,
                    onDateSelected: (date) {
                      setState(() => selectedDate = date);
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            // ✅ Sales Cards Grid
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: const [
                Flexible(
                  child: SalesCard(
                    imagePath: "assets/images/Add_Sales.png",
                    label: "Total Sales",
                    value: 112,
                  ),
                ),
                SizedBox(width: 8),
                Flexible(
                  child: SalesCard(
                    imagePath: "assets/images/Add_Sales.png",
                    label: "Total Income",
                    value: 112,
                  ),
                ),
                SizedBox(width: 8),
                Flexible(
                  child: SalesCard(
                    imagePath: "assets/images/Add_Sales.png",
                    label: "Total Profit",
                    value: 112,
                  ),
                ),
              ],
            ),


            const SizedBox(height: 16),
// ✅ Earnings Cards Row
            Row(
              children: [
                Flexible(
                  child: EarningsCard(
                    income: 112,
                    profit: 112,
                    imagePath: "assets/images/earnings.jpeg",
                    onSeeAll: () {},
                  ),
                ),
                const SizedBox(width: 12),
                Flexible(
                  child: EarningsCard(
                    income: 130,
                    profit: 85,
                    imagePath: "assets/images/earnings.jpeg",
                    onSeeAll: () {},
                  ),
                ),
              ],
            ),

            const SizedBox(height: 16),
            //Quick Action Section
            Text("Quick Actions", style: AppTextStyles.heading),
            const SizedBox(height: 16),

            LayoutBuilder(
              builder: (context, constraints) {
                int crossAxisCount = 2;
                if (constraints.maxWidth >= 800) {
                  crossAxisCount = 4;
                } else if (constraints.maxWidth >= 600) {
                  crossAxisCount = 3;
                }

                return GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: 7,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: crossAxisCount,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                    childAspectRatio: 1,
                  ),
                  itemBuilder: (context, index) {
                    final items = [
                      {"label": "Products", "icon": "assets/images/products.png"},
                      {"label": "Add Intake", "icon": "assets/images/products.png"},
                      {"label": "Add Sale", "icon": "assets/images/products.png"},
                      {"label": "Add Expense", "icon": "assets/images/products.png"},
                      {"label": "Return", "icon": "assets/images/products.png"},
                      {"label": "Add Category", "icon": "assets/images/products.png"},
                      {"label": "Credit & amount due", "icon": "assets/images/products.png"},
                    ];

                    final item = items[index];

                    return MainContainer(
                      imagePath: item["icon"]!,
                      label: item["label"]!,
                      onTap: () {}, // Add actions later if needed
                    );
                  },
                );
              },
            ),

            const SizedBox(height: 32),
            // Management Section
            Text("Management", style: AppTextStyles.heading),
            const SizedBox(height: 12),
            GradientActionCard(
              label: "Generate Report",
              iconPath: "assets/images/earning.png",
              onTap: () {
                // TODO: Navigate to report generation screen
              },
            ),

            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}
