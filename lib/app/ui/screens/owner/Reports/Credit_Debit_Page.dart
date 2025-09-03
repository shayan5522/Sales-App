import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:shoporbit/app/themes/colors.dart';
import 'package:shoporbit/app/ui/screens/owner/Reports/transaction_view_controller.dart';
import 'package:shoporbit/app/ui/widgets/datepicker.dart';
import 'package:shoporbit/app/ui/widgets/appbar.dart';
import '../../../widgets/Amountcard.dart';
import '../../../widgets/buttons.dart';
import '../../../widgets/custom_snackbar.dart';

class CreditDebitPage extends StatefulWidget {
  const CreditDebitPage({super.key});

  @override
  State<CreditDebitPage> createState() => _CreditDebitPageState();
}

class _CreditDebitPageState extends State<CreditDebitPage> {
  final controller = Get.put(TransactionViewController());
  DateTime? _fromDate;
  DateTime? _toDate;
  String _selectedFilter = 'credit';

  @override
  void initState() {
    super.initState();
    controller.fetchTransactions();
    controller.filterTransactions(type: 'credit');
  }

  void _showPaymentDialog(Map<String, dynamic> transaction) {
    final amountController = TextEditingController();
    final noteController = TextEditingController();
    final remaining = transaction['remainingAmount'] ?? 0.0;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        title: Row(
          children: const [
            Icon(Icons.payment, color: Colors.blue, size: 28),
            SizedBox(width: 8),
            Text(
              'Record Payment',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.blue.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                "Remaining Balance: ₹${remaining.toStringAsFixed(2)}",
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.blue,
                ),
              ),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: amountController,
              decoration: InputDecoration(
                labelText: 'Amount',
                prefixText: '₹ ',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 15),
            TextField(
              controller: noteController,
              decoration: InputDecoration(
                labelText: 'Note (optional)',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              maxLines: 2,
            ),
            SizedBox(height: 25,),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SecondaryButton(text: "Cancel", onPressed: () => Navigator.pop(context),),
                SecondaryButton(text: "Save", onPressed: () async {
                  final amount = double.tryParse(amountController.text) ?? 0;
                  if (amount <= 0) {
                    CustomSnackbar.show(
                      title: 'Error',
                      message: 'Please enter a valid amount',
                      isError: true,
                    );
                    return;
                  }
                  if (amount > remaining) {
                    CustomSnackbar.show(
                      title: 'Error',
                      message: 'Amount exceeds remaining balance',
                      isError: true,
                    );
                    return;
                  }

                  await controller.addPayment(
                    transaction['id'],
                    transaction['type'],
                    amount,
                    noteController.text,
                  );
                  Navigator.pop(context);
                },),
              ],
            )
          ],
        ),
        actionsPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 5),
        actions: [

        ],
      ),
    );
  }


  List<Widget> _buildGroupedTransactions() {
    final transactionsByDate = <DateTime, List<dynamic>>{};

    for (var tx in controller.filteredTransactions) {
      DateTime txDate;

      try {
        if (tx['date'] is DateTime) {
          txDate = tx['date'];
        } else if (tx['date'] is String) {
          txDate = DateTime.tryParse(tx['date']) ?? DateTime.now();
        } else if (tx['createdAt'] is DateTime) {
          txDate = tx['createdAt'];
        } else if (tx['createdAt'] is String) {
          txDate = DateTime.tryParse(tx['createdAt']) ?? DateTime.now();
        } else {
          txDate = DateTime.now();
        }

        final dateKey = DateTime(txDate.year, txDate.month, txDate.day);

        if (!transactionsByDate.containsKey(dateKey)) {
          transactionsByDate[dateKey] = [];
        }
        transactionsByDate[dateKey]!.add(tx);
      } catch (e) {
        final dateKey = DateTime.now();
        if (!transactionsByDate.containsKey(dateKey)) {
          transactionsByDate[dateKey] = [];
        }
        transactionsByDate[dateKey]!.add(tx);
      }
    }

    final sortedDates = transactionsByDate.keys.toList()
      ..sort((a, b) => b.compareTo(a));

    return sortedDates.map((date) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            DateFormat('dd-MMM-yyyy').format(date),
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 8),
          ...transactionsByDate[date]!.map((tx) {
            final isFullyPaid = tx['isFullyPaid'] ?? false;
            final remaining = tx['remainingAmount'] ?? 0.0;

            return Card(
              color: Colors.white,
              margin: const EdgeInsets.symmetric(vertical: 4),
              child: ListTile(
                tileColor: AppColors.white,
                title: Text(tx['name'] ?? 'No Name'),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(tx['detail'] ?? 'No Details'),
                    const SizedBox(height: 4),
                    Text(
                      'Original: ₹${(tx['originalAmount'] ?? 0).toStringAsFixed(2)}',
                      style: const TextStyle(fontSize: 12),
                    ),
                    Text(
                      'Paid: ₹${(tx['paidAmount'] ?? 0).toStringAsFixed(2)}',
                      style: const TextStyle(fontSize: 12),
                    ),
                    Text(
                      'Remaining: ₹${remaining.toStringAsFixed(2)}',
                      style: TextStyle(
                        fontSize: 12,
                        color: remaining > 0 ? Colors.red : Colors.green,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                trailing: !isFullyPaid ? IconButton(
                  icon: const Icon(Icons.payment, color: AppColors.primary),
                  onPressed: () => _showPaymentDialog(tx),
                ) : const Icon(Icons.check_circle, color: Colors.green),
                onLongPress: !isFullyPaid ? () {
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: const Text('Mark as Fully Paid'),
                      content: Text('Mark "${tx['name']}" as fully paid?'),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: const Text('Cancel'),
                        ),
                        ElevatedButton(
                          onPressed: () async {
                            await controller.markAsFullyPaid(tx['id'], tx['type']);
                            Navigator.pop(context);
                          },
                          child: const Text('Mark Paid'),
                        ),
                      ],
                    ),
                  );
                } : null,
              ),
            );
          }).toList(),
          const SizedBox(height: 16),
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
                        controller.filterByDateRange(from: _fromDate, to: _toDate);
                      },
                      restrictToToday: true,
                    ),
                  ),
                  const SizedBox(width: 12),
                  CustomDatePicker(
                    label: "To Date",
                    initialDate: _toDate ?? DateTime.now(),
                    onDateSelected: (date) {
                      setState(() => _toDate = date);
                      controller.filterByDateRange(from: _fromDate, to: _toDate);
                    },
                  ),
                ],
              ),
              const SizedBox(height: 16),

              /// 🔹 FINANCIAL OVERVIEW CARDS
              Row(
                children: [
                  Expanded(
                    child: CenteredAmountCard(
                      title: "Total Loan",
                      subtitle: "₹${controller.totalCredit.value.toStringAsFixed(0)}",
                      subtitleColor: Colors.red,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: CenteredAmountCard(
                      title: "Total Debit",
                      subtitle: "₹${controller.totalDebit.value.toStringAsFixed(0)}",
                      subtitleColor: AppColors.primary,
                    ),
                  ),
                ],
              ),
              // const SizedBox(height: 12),
              // CenteredAmountCard(
              //   title: "Pending Amount",
              //   subtitle: "₹${controller.totalPending.value.toStringAsFixed(0)}",
              //   subtitleColor: Colors.orange,
              // ),

              const SizedBox(height: 16),

              /// 🔹 FILTER BUTTONS
              Row(
                children: [
                  Expanded(
                    child: SecondaryButton(
                      heightFactor: 0.04,
                      text: 'Credited Only',
                      color: _selectedFilter == 'credit' ? AppColors.primary : Colors.white,
                      textColor: _selectedFilter == 'credit' ? Colors.white : Colors.black,
                      onPressed: () {
                        setState(() => _selectedFilter = 'credit');
                        controller.filterTransactions(type: 'credit');
                      },
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: SecondaryButton(
                      heightFactor: 0.04,
                      text: 'Debited Only',
                      color: _selectedFilter == 'debit' ? AppColors.primary : Colors.white,
                      textColor: _selectedFilter == 'debit' ? Colors.white : Colors.black,
                      onPressed: () {
                        setState(() => _selectedFilter = 'debit');
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
                    controller.filterTransactions();
                  },
                  child: const Text('Show All'),
                ),
              ),

              /// 🔹 TRANSACTIONS LIST
              if (controller.filteredTransactions.isEmpty)
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 16.0),
                  child: Center(child: Text("No transactions found.")),
                )
              else
                ..._buildGroupedTransactions(),
            ],
          ),
        );
      }),
    );
  }
}