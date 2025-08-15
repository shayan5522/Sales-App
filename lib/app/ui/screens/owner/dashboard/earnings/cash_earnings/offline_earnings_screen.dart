import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:salesapp/app/themes/colors.dart';
import 'package:salesapp/app/themes/styles.dart';
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
          return const Center(child: CircularProgressIndicator());
        }

        return SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              //Custom Date picker
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  CustomDatePicker(
                    onDateSelected: (DateTime ) {  },
                    label: 'From Date',
                    restrictToToday: true,
                  ),
                  CustomDatePicker(
                    onDateSelected: (DateTime ) {  },
                    label: 'To Date',
                  ),
                ],
              ),
              SizedBox(height: 16,),
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

              // Transactions List
              Align(
                  alignment: Alignment.topLeft,
                  child: Text('Recent Transactions', style: AppTextStyles.subheading)),
              const SizedBox(height: 12),
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
}