
import 'package:flutter/material.dart';
import 'package:shoporbit/app/themes/colors.dart';
import 'package:shoporbit/app/themes/styles.dart';
import 'package:shoporbit/app/ui/widgets/Amountcard.dart';
import 'package:shoporbit/app/ui/widgets/appbar.dart';
import 'package:shoporbit/app/ui/widgets/datepicker.dart';
import 'package:shoporbit/app/ui/widgets/transactionlist.dart';

class OfflineReport extends StatefulWidget {
  const OfflineReport({super.key});

  @override
  State<OfflineReport> createState() => _OnlineReportScreenState();
}

final ScrollController _transactionScrollController = ScrollController();

class _OnlineReportScreenState extends State<OfflineReport> {
  DateTime? fromDate = DateTime.now();
  DateTime? toDate = DateTime.now();

  // Dummy transaction data
  final List<Map<String, dynamic>> transactions = List.generate(
    20,
    (index) => {'product': 'Product no ${index + 1}', 'amount': 112},
  );

  // Dummy totals (replace with your logic)
  int get totalIncome =>
      transactions.fold(0, (sum, item) => sum + (item['amount'] as int));
  int get totalProfit => transactions.fold(
    0,
    (sum, item) => sum + (item['amount'] as int),
  ); // Example

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: CustomAppbar(
        title: 'Offline Report',
        backgroundColor: AppColors.primary,
      ),

      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(
          horizontal: screenWidth * 0.06,
          vertical: screenHeight * 0.02,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Title
            Center(
              child: Text(
                'Offline Income & Profit Report',
                style: AppTextStyles.title.copyWith(
                  fontWeight: FontWeight.bold,
                  fontSize: screenWidth * 0.055,
                ),
              ),
            ),
            SizedBox(height: screenHeight * 0.025),

            // Date pickers
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.only(bottom: screenHeight * 0.01),
                    child: ConstrainedBox(
                      constraints: BoxConstraints(
                        minHeight: 56, // Minimum height for mobile
                        maxHeight: 80, // Maximum height for web/large screens
                      ),
                      child: CustomDatePicker(
                        label: 'FROM DATE',
                        initialDate: fromDate,
                        onDateSelected: (date) =>
                            setState(() => fromDate = date),
                      ),
                    ),
                  ),
                ),
                SizedBox(width: screenWidth * 0.04),
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.only(bottom: screenHeight * 0.01),
                    child: ConstrainedBox(
                      constraints: BoxConstraints(minHeight: 56, maxHeight: 80),
                      child: CustomDatePicker(
                        label: 'TO DATE',
                        initialDate: toDate,
                        onDateSelected: (date) => setState(() => toDate = date),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: screenHeight * 0.025),

            // Income & Profit cards
            Row(
              children: [
                Expanded(
                  child: CenteredAmountCard(
                    title: 'Total Income\nOnline',
                    subtitle: '₹ $totalIncome',
                  ),
                ),
                SizedBox(width: screenWidth * 0.04),
                Expanded(
                  child: CenteredAmountCard(
                    title: 'Total Profit\nOnline',
                    subtitle: '₹ $totalProfit',
                  ),
                ),
              ],
            ),
            SizedBox(height: screenHeight * 0.03),

            // Transactions Card
            Container(
              width: double.infinity,
              constraints: BoxConstraints(
                minHeight: 200,
                maxHeight:
                    screenHeight *
                    0.6, // or a value that works for both web/mobile
              ),
              decoration: BoxDecoration(
                border: Border.all(color: AppColors.primary, width: 1.2),
                borderRadius: BorderRadius.circular(10),
              ),
              padding: EdgeInsets.symmetric(
                horizontal: screenWidth * 0.04,
                vertical: screenHeight * 0.018,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Transactions',
                    style: AppTextStyles.title.copyWith(
                      fontWeight: FontWeight.bold,
                      fontSize: screenWidth * 0.048,
                    ),
                  ),
                  Divider(height: 1, color: Colors.grey[400]),
                  SizedBox(height: screenHeight * 0.012),
                  // Use Flexible for the list
                  Flexible(
                    child: Scrollbar(
                      controller: _transactionScrollController,
                      thumbVisibility: true,
                      child: ListView.separated(
                        controller: _transactionScrollController,
                        itemCount: transactions.length,
                        separatorBuilder: (_, __) =>
                            SizedBox(height: screenHeight * 0.012),
                        itemBuilder: (context, index) {
                          final item = transactions[index];
                          return TransactionTextRow(
                            product: item['product'] as String,
                            amount: item['amount'],
                          );
                        },
                      ),
                    ),
                  ),
                  SizedBox(height: screenHeight * 0.01),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
