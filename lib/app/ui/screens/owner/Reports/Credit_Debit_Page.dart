import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:salesapp/app/themes/colors.dart';
import 'package:salesapp/app/themes/styles.dart';
import 'package:salesapp/app/ui/screens/owner/Reports/transaction_view_controller.dart';
import 'package:salesapp/app/ui/widgets/Expense/expensecard.dart';
import 'package:salesapp/app/ui/widgets/Expense/expenselist.dart';
import 'package:salesapp/app/ui/widgets/datepicker.dart';
import 'package:salesapp/app/ui/widgets/chart.dart';
import 'package:salesapp/app/ui/widgets/appbar.dart';

import '../../../widgets/Amountcard.dart';
import '../../../widgets/buttons.dart';

class CreditDebitPage extends StatefulWidget {
  const CreditDebitPage({super.key});

  @override
  State<CreditDebitPage> createState() => _CreditDebitPageState();
}

class _CreditDebitPageState extends State<CreditDebitPage> {
  final controller = Get.put(TransactionViewController());

  DateTime? _fromDate;
  DateTime? _toDate;
  String _selectedFilter = ''; // 'credit', 'debit', or ''

  @override
  void initState() {
    super.initState();
    controller.fetchTransactions();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppbar(title: 'Credit & Debit Report'),
      backgroundColor: AppColors.backgroundColor,
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(
            child: CircularProgressIndicator(color: AppColors.primary),
          );
        }
        return SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// 🔹 DATE PICKERS
              Row(
                children: [
                  Expanded(
                    child: CustomDatePicker(
                      label: "From Date",
                      initialDate: _fromDate ?? DateTime.now(),
                      onDateSelected: (date) {
                        setState(() => _fromDate = date);
                        controller.filterByDateRange(
                            from: _fromDate, to: _toDate);
                      },
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: CustomDatePicker(
                      label: "To Date",
                      initialDate: _toDate ?? DateTime.now(),
                      onDateSelected: (date) {
                        setState(() => _toDate = date);
                        controller.filterByDateRange(
                            from: _fromDate, to: _toDate);
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              /// 🔹 CREDIT + TOTAL VALUE CARDS
              Row(
                children: [
                  Expanded(
                    child: CenteredAmountCard(
                      title: "Credit Amount",
                      subtitle:
                      "INR ${controller.totalCredit.value.toStringAsFixed(0)}",
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: CenteredAmountCard(
                      title: "Total Value",
                      subtitle:
                      "INR ${(controller.totalCredit.value + controller.totalDebit.value).toStringAsFixed(0)}",
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 16),

              /// 🔹 FILTER BUTTONS WITH SELECT HIGHLIGHT
              Row(
                children: [
                  Expanded(
                    child: SecondaryButton(
                      text: 'Credited Only',
                      color: _selectedFilter == 'credit'
                          ? AppColors.primary
                          : Colors.white,
                      textColor: _selectedFilter == 'credit'
                          ? Colors.white
                          : Colors.black,
                      onPressed: () {
                        setState(() {
                          _selectedFilter = 'credit';
                        });
                        controller.filterTransactions(type: 'credit');
                      },
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: SecondaryButton(
                      text: 'Debited Only',
                      color: _selectedFilter == 'debit'
                          ? AppColors.primary
                          : Colors.white,
                      textColor: _selectedFilter == 'debit'
                          ? Colors.white
                          : Colors.black,
                      onPressed: () {
                        setState(() {
                          _selectedFilter = 'debit';
                        });
                        controller.filterTransactions(type: 'debit');
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              /// 🔹 RESET FILTER
              Center(
                child: TextButton(
                  onPressed: () {
                    setState(() {
                      _fromDate = null;
                      _toDate = null;
                      _selectedFilter = '';
                    });
                    controller.fromDate = null;
                    controller.toDate = null;
                    controller.filterTransactions(); // Show all
                  },
                  child: const Text('Show All'),
                ),
              ),
              const SizedBox(height: 12),

              /// 🔹 TRANSACTIONS
              const Text(
                "Transactions:",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primary,
                ),
              ),
              const SizedBox(height: 12),

              if (controller.filteredTransactions.isEmpty)
                const Text("No transactions found."),
              ...controller.filteredTransactions.map((tx) {
                return CustomExpenseListTile(
                  title: tx['name'],
                  description: tx['detail'],
                  price: (tx['price'] as double).toInt(),
                );
              }).toList(),
            ],
          ),
        );
      }),
    );
  }
}
