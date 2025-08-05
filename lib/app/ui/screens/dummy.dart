import 'package:flutter/material.dart';
import 'package:salesapp/app/themes/colors.dart' show AppColors;
import 'package:salesapp/app/ui/screens/owner/Reports/offlinereport.dart';
import 'package:salesapp/app/ui/screens/owner/Reports/onlinereport.dart';
import 'package:salesapp/app/ui/screens/owner/Reports/returnreport.dart';
import 'package:salesapp/app/ui/screens/owner/dashboard/Add_Sales/sales.dart';
import 'package:salesapp/app/ui/screens/owner/dashboard/credit_amount%20_due/amountcrediet.dart';
import 'package:salesapp/app/ui/screens/owner/dashboard/expenses/expense.dart';
import 'package:salesapp/app/ui/screens/owner/dashboard/intake/addintake.dart';
import 'package:salesapp/app/ui/screens/owner/dashboard/return_screen/return.dart';
import 'package:salesapp/app/ui/screens/owner/settings/setting.dart';
import 'package:salesapp/app/ui/screens/owner/user_management/usermanagement.dart';

import 'package:salesapp/app/ui/widgets/buttons.dart';
import 'package:get/get.dart';
import 'package:salesapp/app/ui/widgets/expensecard.dart';
import 'package:salesapp/app/ui/widgets/salereportcard.dart';
import 'package:salesapp/app/ui/widgets/summarycard.dart';

class DummyTestScreen extends StatelessWidget {
  const DummyTestScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final buttonSpacing = screenHeight * 0.018;
    final horizontalPadding = screenWidth * 0.08;

    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: AppBar(title: const Text('Dummy Test Screen'), centerTitle: true),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(
          horizontal: horizontalPadding,
          vertical: screenHeight * 0.04,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,

          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SummaryCard(amount: '1000', label: 'Total Sales'),
                SummaryCard(amount: '500', label: 'Total Returns'),
                SummaryCard(amount: '700', label: 'Total Profit'),
              ],
            ),
            SizedBox(height: screenHeight * 0.02),
            GridView.count(
              crossAxisCount: 2,
              padding: EdgeInsets.symmetric(horizontal: 12, vertical: 12),
              childAspectRatio: 1.4, // Try 1.2, 1.3, 1.4, etc.
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              children: List.generate(
                4,
                (index) => Salereportcard(
                  imagePath: 'assets/images/Apple.jpg',
                  totalSold: '30 sold',
                  income: '3000',
                  profit: '3000',
                ),
              ),
            ),
            GridView.count(
              crossAxisCount: 2,
              padding: EdgeInsets.symmetric(horizontal: 12, vertical: 12),
              childAspectRatio: 1.4, // Try 1.2, 1.3, 1.4, etc.
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              children: List.generate(
                4,
                (index) => ProductExpenseCard(
                  imagePath: 'assets/images/Apple.jpg',
                  productName: 'Apple',
                  inTaken: '20',
                  totalExpense: '100',
                  amount: '100',
                ),
              ),
            ),
            PrimaryButton(
              text: 'Intake',
              onPressed: () {
                Get.to(() => AddIntake());
              },
            ),
            SizedBox(height: buttonSpacing),
            PrimaryButton(
              text: 'Sales',
              onPressed: () {
                Get.to(() => Sales());
              },
            ),
            SizedBox(height: buttonSpacing),
            PrimaryButton(
              text: 'Product Return',
              onPressed: () {
                Get.to(() => ReturnProduct());
              },
            ),
            SizedBox(height: buttonSpacing),
            PrimaryButton(
              text: 'Add Expense',
              onPressed: () {
                Get.to(() => AddExpenseScreen());
              },
            ),
            SizedBox(height: buttonSpacing),
            PrimaryButton(
              text: 'Online Report',
              onPressed: () {
                Get.to(() => OnlineReportScreen());
              },
            ),
            SizedBox(height: buttonSpacing),
            PrimaryButton(
              text: 'Offline Report',
              onPressed: () {
                Get.to(() => OfflineReport());
              },
            ),
            SizedBox(height: buttonSpacing),
            PrimaryButton(
              text: 'Return Report',
              onPressed: () {
                Get.to(() => RetunReport());
              },
            ),
            SizedBox(height: buttonSpacing),
            PrimaryButton(
              text: 'Settings',
              onPressed: () {
                Get.to(() => SettingsScreen());
              },
            ),
            SizedBox(height: buttonSpacing),
            PrimaryButton(
              text: 'Amount Credit',
              onPressed: () {
                Get.to(() => AmountCreditScreen());
              },
            ),
            SizedBox(height: buttonSpacing),
            PrimaryButton(
              text: 'User Management',
              onPressed: () {
                Get.to(() => UserManagementScreen());
              },
            ),
          ],
        ),
      ),
    );
  }
}
