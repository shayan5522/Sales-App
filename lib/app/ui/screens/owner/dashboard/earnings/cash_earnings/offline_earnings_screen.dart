import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shoporbit/app/themes/colors.dart';
import 'package:shoporbit/app/themes/styles.dart';
import '../../../../../widgets/amount_card.dart';
import '../../../../../widgets/appbar.dart';
import '../../../../../widgets/datepicker.dart';
import '../../../../../widgets/transaction_list_item.dart';
import 'offline_earnings_controller.dart';

class OfflineEarningsScreen extends StatelessWidget {
  OfflineEarningsScreen({super.key}) {
    Get.put(OfflineEarningsController());
  }

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<OfflineEarningsController>();
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: CustomAppbar(title: 'Cash Earnings'),
      backgroundColor: AppColors.backgroundColor,
      body: Obx(() {
        if (controller.isLoading.value) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircularProgressIndicator(),
                SizedBox(height: 16),
                Text('Loading transactions...'),
              ],
            ),
          );
        }

        return SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              // Date pickers
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  CustomDatePicker(
                    onDateSelected: (date) {
                      final newFromDate = DateTime(date.year, date.month, date.day);
                      controller.updateDateRange(
                        newFromDate,
                        controller.toDate.value,
                      );
                    },
                    label: 'From Date',
                    initialDate: controller.fromDate.value,
                    restrictToToday: true,
                  ),
                  CustomDatePicker(
                    onDateSelected: (date) {
                      final newToDate = DateTime(date.year, date.month, date.day, 23, 59, 59);
                      controller.updateDateRange(
                        controller.fromDate.value,
                        newToDate,
                      );
                    },
                    label: 'To Date',
                    initialDate: controller.toDate.value,
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Summary Cards
              Row(
                children: [
                  Expanded(
                    child: AmountCard(
                      title: 'Total Sales',
                      amount: controller.totalSales.value,
                      color: AppColors.primary,
                    ),
                  ),
                  SizedBox(width: screenWidth * 0.04),
                  Expanded(
                    child: AmountCard(
                      title: 'Total Profit',
                      amount: controller.totalProfit.value,
                      color: Colors.green,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // Transactions List with date range header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Transactions (${_formatDate(controller.fromDate.value)} - ${_formatDate(controller.toDate.value)})',
                    style: AppTextStyles.title,
                  ),
                  // Text(
                  //   '${controller.transactions.length} items',
                  //   style: AppTextStyles.subtitle,
                  // ),
                ],
              ),
              const SizedBox(height: 12),

              if (controller.transactions.isEmpty)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 32),
                  child: Text(
                    'No transactions found for selected date range',
                    style: AppTextStyles.subtitle.copyWith(color: Colors.grey),
                  ),
                )
              else
                ...controller.transactions.map((transaction) => TransactionListItem(
                  title: 'Cash Sale',
                  amount: transaction['amount'],
                  date: (transaction['createdAt'] as Timestamp).toDate(),
                  items: (transaction['items'] as List).length,
                )),
            ],
          ),
        );
      }),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }
}