import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:salesapp/app/themes/colors.dart';
import 'package:salesapp/app/themes/styles.dart';
import 'package:salesapp/app/ui/screens/owner/Reports/transaction_view_controller.dart';
import 'package:salesapp/app/ui/widgets/Expense/expenselist.dart';
import 'package:salesapp/app/ui/widgets/datepicker.dart';
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
  String _selectedFilter = 'credit'; // 'credit', 'debit', or ''

  @override
  void initState() {
    super.initState();
    controller.fetchTransactions();
    controller.filterTransactions(type: 'credit');
  }

  List<Widget> _buildGroupedTransactions() {
    // Group transactions by date
    final transactionsByDate = <DateTime, List<dynamic>>{};

    for (var tx in controller.filteredTransactions) {
      DateTime txDate;

      try {
        // Handle different possible date formats
        if (tx['date'] is DateTime) {
          txDate = tx['date'];
        } else if (tx['date'] is String) {
          // Try parsing ISO format first
          txDate = DateTime.tryParse(tx['date']) ?? DateTime.now();
        } else if (tx['createdAt'] is DateTime) {
          txDate = tx['createdAt'];
        } else if (tx['createdAt'] is String) {
          txDate = DateTime.tryParse(tx['createdAt']) ?? DateTime.now();
        } else {
          txDate = DateTime.now();
        }

        // Normalize to date-only (remove time component)
        final dateKey = DateTime(txDate.year, txDate.month, txDate.day);

        if (!transactionsByDate.containsKey(dateKey)) {
          transactionsByDate[dateKey] = [];
        }
        transactionsByDate[dateKey]!.add(tx);
      } catch (e) {
        // Fallback to current date if parsing fails
        final dateKey = DateTime.now();
        if (!transactionsByDate.containsKey(dateKey)) {
          transactionsByDate[dateKey] = [];
        }
        transactionsByDate[dateKey]!.add(tx);
      }
    }

    // Sort dates in descending order (newest first)
    final sortedDates = transactionsByDate.keys.toList()
      ..sort((a, b) => b.compareTo(a));

    return sortedDates.map((date) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// Date Header
          Padding(
            padding: const EdgeInsets.only(top: 16.0, bottom: 8.0),
            child: Text(
              DateFormat('dd-MMM-yyyy').format(date), // Formats as "12-Aug-2025"
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
          ),

          /// Transactions for this date
          ...transactionsByDate[date]!.map((tx) {
            return CustomExpenseListTile(
              title: tx['name'] ?? 'No Name',
              description: tx['detail'] ?? 'No Details',
              price: (tx['price'] as num?)?.toInt() ?? 0,
            );
          }).toList(),
        ],
      );
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppbar(title: 'Loan & Debit Report'),
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
                      title: "Loan Amount",
                      subtitle:
                      "INR ${controller.totalCredit.value.toStringAsFixed(0)}",
                      subtitleColor: Colors.red,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: CenteredAmountCard(
                      title: "Debit Amount",
                      subtitle:
                      "INR ${controller.totalDebit.value.toStringAsFixed(0)}",
                      subtitleColor: Colors.red,
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
                      heightFactor: 0.04,
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
                      heightFactor: 0.04,
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
              /// 🔹 GROUPED TRANSACTIONS BY DATE
              if (controller.filteredTransactions.isEmpty)
                const Text("No transactions found."),
              ..._buildGroupedTransactions(),
            ],
          ),
        );
      }),
    );
  }
}