import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:salesapp/app/themes/styles.dart';
import 'package:salesapp/app/ui/screens/owner/dashboard/return_screen/return.dart';
import 'package:salesapp/app/ui/widgets/datepicker.dart';
import '../../../widgets/Admindashboard/dashboard_main-container.dart';
import '../../../widgets/Admindashboard/earning_card.dart';
import '../../../widgets/Admindashboard/gradient_action_card.dart';
import '../../../widgets/Admindashboard/salescard.dart';
import '../../../widgets/custom_dashboard_appbar.dart';
import 'package:salesapp/app/ui/screens/owner/dashboard/products/products.dart';
import '../Reports/report_main_page.dart';
import '../user_management/usermanagement.dart';
import 'Add_Sales/sales.dart';
import 'add_category/add_category_page.dart';
import 'credit_amount _due/amountcrediet.dart';
import 'expenses/expense.dart';
import 'intake/addintake.dart';
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
      appBar:  CustomDashboardAppBar(
        title: "Owner Pannel",
        logoPath: "assets/images/sales.png",
        onProfileTap: (){Get.to(()=>UserManagementScreen());},

      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Total Summary", style: AppTextStyles.heading),
                SizedBox(
                  width: 140,
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
                    imagePath: "assets/images/sales.png",
                    label: "Total Sales",
                    value: 112,
                  ),
                ),
                SizedBox(width: 8),
                Flexible(
                  child: SalesCard(
                    imagePath: "assets/images/sales1111.png",
                    label: "Total Income",
                    value: 112,
                  ),
                ),
                SizedBox(width: 8),
                Flexible(
                  child: SalesCard(
                    imagePath: "assets/images/earning.png",
                    label: "Total Profit",
                    value: 112,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 16),
// ✅ Earnings Cards Row Here
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
            //Quick Action Section Heree...
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
                      {
                        "label": "Products",
                        "icon": "assets/images/products.png",
                        "screen":ProductScreen(),
                      },
                      {
                        "label": "Add Intake",
                        "icon": "assets/images/products.png",
                        "screen":AddIntake(),
                      },
                      {
                        "label": "Add Sale",
                        "icon": "assets/images/products.png",
                        "screen":Sales(),
                      },
                      {
                        "label": "Add Expense",
                        "icon": "assets/images/products.png",
                        "screen":AddExpenseScreen(),
                      },
                      {
                        "label": "Return",
                        "icon": "assets/images/products.png",
                        "screen":ReturnProduct(),
                      },
                      {
                        "label": "Add Expense Category",
                        "icon": "assets/images/products.png",
                        "screen": AddCategoryPage(),
                      },
                      {
                        "label": "Credit & amount due",
                        "icon": "assets/images/products.png",
                        "screen":AmountCreditScreen(),
                      },
                    ];
                    final item = items[index];
                    return MainContainer(
                      imagePath: item["icon"] as String,
                      label: item["label"] as String,
                      onTap: () => Get.to(() => item["screen"] as Widget),
                    );
                  },

                );
              },
            ),

            const SizedBox(height: 32),
            // Management Section Heree
            Text("Management", style: AppTextStyles.heading),
            const SizedBox(height: 12),
            GradientActionCard(
              label: "Generate Report",
              iconPath: "assets/images/earning.png",
              onTap: () {
                Get.to(() => const ReportsMainPage());
              },

            ),

            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}
