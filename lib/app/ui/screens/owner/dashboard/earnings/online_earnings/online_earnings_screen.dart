import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:salesapp/app/themes/colors.dart';
import 'package:salesapp/app/themes/styles.dart';
import '../../../../../widgets/amount_card.dart';
import '../../../../../widgets/appbar.dart';
import '../../../../../widgets/transaction_list_item.dart';
import 'online_earnings_controller.dart';

class OnlineEarningsScreen extends StatelessWidget {
  OnlineEarningsScreen({super.key}) {
    Get.put(OnlineEarningsController());
  }

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<OnlineEarningsController>();
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: CustomAppbar(title: 'Online Earnings'),
      backgroundColor: AppColors.backgroundColor,
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        return SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              // Summary Cards
              Row(
                children: [
                  Expanded(
                    child: AmountCard(
                      title: 'Total Sales',
                      amount: controller.totalSales.value,
                      color: Colors.blue,
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
              Text('Recent Transactions', style: AppTextStyles.heading),
              const SizedBox(height: 12),
              ...controller.transactions.map((transaction) => TransactionListItem(
                title: 'Online Sale',
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