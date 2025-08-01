import 'package:flutter/material.dart';
import 'package:salesapp/app/themes/colors.dart';
import 'package:salesapp/app/themes/styles.dart';
import 'package:salesapp/app/ui/widgets/Admindashboard/salescard.dart';
import 'package:salesapp/app/ui/widgets/Admindashboard/dashboard_main-container.dart';
import 'package:salesapp/app/ui/widgets/appbar.dart';

class ReportsMainPage extends StatelessWidget {
  const ReportsMainPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F6F9),
      appBar: const CustomAppbar(
        title: 'Reports',
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Total Summary Heading
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Total Summary", style: AppTextStyles.heading),
                const Icon(Icons.tune, color: AppColors.primary),
              ],
            ),
            const SizedBox(height: 16),

            // Summary Cards Row
            Row(
              children: const [
                Expanded(
                  child: SalesCard(
                    imagePath: "assets/images/sales.png",
                    label: "Sale Amount",
                    value: 112,
                  ),
                ),
                SizedBox(width: 8),
                Expanded(
                  child: SalesCard(
                    imagePath: "assets/images/sales.png",
                    label: "Intake Amount",
                    value: 100,
                  ),
                ),
                SizedBox(width: 8),
                Expanded(
                  child: SalesCard(
                    imagePath: "assets/images/sales.png",
                    label: "Expense Amount",
                    value: 112,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Total Profit Box (Custom design)
            Container(
              height: 80,
              padding: EdgeInsets.symmetric(horizontal: 16),
              margin: EdgeInsets.symmetric(vertical: 12),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.2),
                    spreadRadius: 2,
                    blurRadius: 8,
                    offset: Offset(0, 4),
                  ),
                ],
                border: Border.all(color: Colors.grey.shade300),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Left colored bar + icon + label
                  Row(
                    children: [
                      // Left vertical bar (blue rounded left edge)
                      Container(
                        width: 36,
                        height: 58,
                        decoration: BoxDecoration(
                          color: Colors.blue[800],
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(10),
                            bottomLeft: Radius.circular(10),
                          ),
                        ),
                      ),
                      SizedBox(width: 12),

                      // Icon and Label
                      Row(
                        children: [
                          Icon(Icons.monetization_on_rounded, color: Colors.green, size: 28),
                          SizedBox(width: 8),
                          Text(
                            'Total Profit',
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 16,
                              color: Colors.black87,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),

                  // Right end bar with amount
                  Row(
                    children: [
                      Text(
                        '₹112',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.deepPurple,
                        ),
                      ),
                      SizedBox(width: 10),

                      // Right vertical bar (blue rounded right edge)
                      Container(
                        width: 36,
                        height: 68,
                        decoration: BoxDecoration(
                          color: Colors.blue[400],
                          borderRadius: BorderRadius.only(
                            topRight: Radius.circular(10),
                            bottomRight: Radius.circular(10),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // Profit Breakdown Row
            Row(
              children: [
                _profitBox("Profit Amount in Cash", 112),
                const SizedBox(width: 12),
                _profitBox("Profit Amount Online", 112),
              ],
            ),
            const SizedBox(height: 32),

            // Quick Actions Section
            Text("Quick Actions", style: AppTextStyles.heading),
            const SizedBox(height: 16),

            GridView.count(
              crossAxisCount: 2,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: 1,
              children: [
                MainContainer(imagePath: "assets/images/stock.png", label: "Stock", onTap: () {}),
                MainContainer(imagePath: "assets/images/intake.png", label: "Intake", onTap: () {}),
                MainContainer(imagePath: "assets/images/sales1111.png", label: "Sales", onTap: () {}),
                MainContainer(imagePath: "assets/images/Expense.png", label: "Expense", onTap: () {}),
                MainContainer(imagePath: "assets/images/return_report.png", label: "Return Report", onTap: () {}),
                MainContainer(imagePath: "assets/images/CD_report.png", label: "Credit & Due Report", onTap: () {}),
              ],
            ),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  Widget _profitBox(String label, int amount) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: AppColors.secondary,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(color: Colors.black12, blurRadius: 4, offset: Offset(0, 2)),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label, style: AppTextStyles.description.copyWith(fontSize: 13)),
            const SizedBox(height: 8),
            Row(
              children: [
                const Icon(Icons.currency_rupee, size: 18, color: AppColors.primary),
                Text(
                  amount.toString(),
                  style: AppTextStyles.heading.copyWith(fontSize: 18),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
