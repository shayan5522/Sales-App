import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:salesapp/app/themes/colors.dart';
import 'package:salesapp/app/themes/styles.dart';
import 'package:salesapp/app/ui/widgets/Expense/expensecard.dart';
import 'package:salesapp/app/ui/widgets/Expense/expenselist.dart';
import 'package:salesapp/app/ui/widgets/datepicker.dart';
import 'package:salesapp/app/ui/widgets/chart.dart';
import 'package:salesapp/app/ui/widgets/appbar.dart';

import '../../../widgets/Amountcard.dart';
import '../../../widgets/buttons.dart';

class CreditDebitPage extends StatelessWidget {
  const CreditDebitPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppbar(title: 'Credit & Debit Report'),
      backgroundColor: const Color(0xFFD8EAED),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// 🔹 DATE PICKERS
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: CustomDatePicker(
                    label: "From Date",
                    onDateSelected: (_) {},
                    initialDate: DateTime.now(),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: CustomDatePicker(
                    label: "To Date",
                    onDateSelected: (_) {},
                    initialDate: DateTime.now(),
                  ),
                ),
              ],
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
            const SizedBox(height: 16),
            /// 🔹 ACTION BUTTONS BELOW CREDIT/TOTAL CARDS
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Expanded(
                  child: SecondaryButton(
                    text: 'Credited Only',
                    onPressed: () {
                      // TODO: Implement download functionality
                    },
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: SecondaryButton(
                    text: 'Debited Only',
                    onPressed: () {
                      // TODO: Implement share functionality
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            /// 🔹 TRANSACTION SECTION HEADER Rizu G
            const Text(
              "Transactions:",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppColors.primary,
              ),
            ),
            const SizedBox(height: 12),
            /// 🔹 EXPENSE LIST (DETAILED)
            const CustomExpenseListTile(
              title: 'Fuel Charges',
              description: 'Vehicle refueling',
              price: 2200,
            ),
            const CustomExpenseListTile(
              title: 'Tea & Coffee',
              description: 'Team break beverages',
              price: 1300,
            ),
            const CustomExpenseListTile(
              title: 'Team Dinner',
              description: 'Monthly meetup expense',
              price: 2000,
            ),
          ],
        ),
      ),
    );
  }
}
