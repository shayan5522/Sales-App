import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:salesapp/app/themes/colors.dart';
import 'package:salesapp/app/themes/styles.dart';
import 'package:salesapp/app/ui/screens/owner/Reports/ReturnReport/return_report_controller.dart';
import 'package:salesapp/app/ui/widgets/Amountcard.dart';
import 'package:salesapp/app/ui/widgets/appbar.dart';
import 'package:salesapp/app/ui/widgets/datepicker.dart';
import 'package:salesapp/app/ui/widgets/transactionlist.dart';

class ReturnReport extends StatefulWidget {
  const ReturnReport({super.key});

  @override
  State<ReturnReport> createState() => _ReturnReportState();
}

final ScrollController _transactionScrollController = ScrollController();

class _ReturnReportState extends State<ReturnReport> {
  final ReturnReportController controller = Get.put(ReturnReportController());

  DateTime? fromDate = DateTime.now();
  DateTime? toDate = DateTime.now();

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: CustomAppbar(
        title: 'Return Report',
        backgroundColor: AppColors.primary,
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return Center(
            child: CircularProgressIndicator(color: AppColors.primary),
          );
        }

        if (controller.transactions.isEmpty) {
          return Center(
            child: Text(
              'No transactions found for selected date range.',
              style: TextStyle(fontSize: 16, color: Colors.red),
            ),
          );
        }

        return SingleChildScrollView(
          padding: EdgeInsets.symmetric(
            horizontal: screenWidth * 0.06,
            vertical: screenHeight * 0.02,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: screenHeight * 0.025),

              /// Date pickers
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.only(bottom: screenHeight * 0.01),
                      child: ConstrainedBox(
                        constraints: BoxConstraints(minHeight: 56, maxHeight: 80),
                        child: CustomDatePicker(
                          label: 'From DATE',
                          initialDate: fromDate,
                          onDateSelected: (date) {
                            setState(() {
                              fromDate = DateTime(date.year, date.month, date.day, 0, 0, 0);
                            });
                            controller.fetchReturnReports(
                              fromDate: fromDate!,
                              toDate: toDate!,
                            );
                          },
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
                          onDateSelected: (date) {
                            setState(() {
                              toDate = DateTime(date.year, date.month, date.day, 23, 59, 59);
                            });
                            controller.fetchReturnReports(
                              fromDate: fromDate!,
                              toDate: toDate!,
                            );
                          },
                        ),
                      ),
                    ),
                  ),
                ],
              ),

              /// Income & Profit cards
              Row(
                children: [
                  Expanded(
                    child: CenteredAmountCard(
                      title: 'Total Income\nOnline',
                      subtitle: '₹ ${controller.totalIncome.value.toStringAsFixed(2)}',
                    ),
                  ),
                  SizedBox(width: screenWidth * 0.04),
                  Expanded(
                    child: CenteredAmountCard(
                      title: 'Total Profit\nOnline',
                      subtitle: '₹ ${controller.totalProfit.value.toStringAsFixed(2)}',
                    ),
                  ),
                ],
              ),

              SizedBox(height: screenHeight * 0.03),

              /// Transactions Card
              Container(
                width: double.infinity,
                constraints: BoxConstraints(
                  minHeight: 200,
                  maxHeight: screenHeight * 0.6,
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
                    Flexible(
                      child: Scrollbar(
                        controller: _transactionScrollController,
                        thumbVisibility: true,
                        child: ListView.separated(
                          controller: _transactionScrollController,
                          itemCount: controller.transactions.length,
                          separatorBuilder: (_, __) => SizedBox(height: screenHeight * 0.012),
                          itemBuilder: (context, index) {
                            final item = controller.transactions[index];
                            return TransactionTextRow(
                              product: item['product'],
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
        );
      }),
    );
  }
}
