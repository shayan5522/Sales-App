import 'package:flutter/material.dart';
import 'package:salesapp/app/themes/colors.dart' show AppColors;
import 'package:salesapp/app/ui/screens/owner/Reports/offlinereport.dart';
import 'package:salesapp/app/ui/screens/owner/Reports/onlinereport.dart';
import 'package:salesapp/app/ui/screens/owner/Reports/returnreport.dart';
import 'package:salesapp/app/ui/screens/owner/addintake.dart';
import 'package:salesapp/app/ui/screens/owner/amountcrediet.dart';
import 'package:salesapp/app/ui/screens/owner/expense.dart';

import 'package:salesapp/app/ui/screens/owner/return.dart';
import 'package:salesapp/app/ui/screens/owner/sales.dart';
import 'package:salesapp/app/ui/screens/owner/setting.dart';
import 'package:salesapp/app/ui/screens/owner/usermanagement.dart';
import 'package:salesapp/app/ui/widgets/buttons.dart';
import 'package:get/get.dart';
import 'package:salesapp/app/ui/widgets/intakeproduct.dart';
import 'package:salesapp/app/ui/widgets/sale/salereportlist.dart';
import 'package:salesapp/app/ui/widgets/sale/salesstat.dart';

class DummyTestScreen extends StatelessWidget {
  const DummyTestScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: AppBar(title: const Text('Dummy Test Screen')),
      body: Column(
        children: [
          PrimaryButton(
            text: 'intake',
            onPressed: () {
              Get.to(() => AddIntake());
            },
          ),
          const SizedBox(height: 8),
          PrimaryButton(
            text: 'Sales',
            onPressed: () {
              Get.to(() => Sales());
            },
          ),
          const SizedBox(height: 8),
          PrimaryButton(
            text: 'Product Return',
            onPressed: () {
              Get.to(() => ReturnProduct());
            },
          ),
          SizedBox(height: 8),
          PrimaryButton(
            text: 'ADD EXPENSE',
            onPressed: () {
              Get.to(() => AddExpenseScreen());
            },
          ),
          PrimaryButton(
            text: 'online report',
            onPressed: () {
              Get.to(() => OnlineReportScreen());
            },
          ),
          PrimaryButton(
            text: 'Offline report',
            onPressed: () {
              Get.to(() => OfflineReport());
            },
          ),
          PrimaryButton(
            text: 'return report',
            onPressed: () {
              Get.to(() => RetunReport());
            },
          ),
          PrimaryButton(
            text: 'return report',
            onPressed: () {
              Get.to(() => SettingsScreen());
            },
          ),
          const SizedBox(height: 8),
          PrimaryButton(
            text: 'Amount Credit',
            onPressed: () {
              Get.to(() => AmountCreditScreen());
            },
          ),
          const SizedBox(height: 8),
          PrimaryButton(
            text: 'User Management',
            onPressed: () {
              Get.to(() => UserManagementScreen());
            },
          ),
        ],
      ),
    );
  }
}
