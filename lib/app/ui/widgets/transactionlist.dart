import 'package:flutter/material.dart';
import 'package:shoporbit/app/themes/colors.dart';
import 'package:shoporbit/app/themes/styles.dart';

class TransactionTextRow extends StatelessWidget {
  final String product;
  final double amount;
  final int? quantity;

  const TransactionTextRow({
    super.key,
    required this.product,
    required this.amount,
     this.quantity,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 6),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.blueAccent),
        borderRadius: BorderRadius.circular(8),
        color: AppColors.secondary,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Main product row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Product name
              Text(product, style: AppTextStyles.subtitle),
              // Amount with ₹
              Row(
                children: [
                  const Icon(Icons.currency_rupee, size: 14, color: Colors.blue),
                  Text(
                    amount.toStringAsFixed(2),
                    style: AppTextStyles.subtitle.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ],
          ),
          // Quantity subtitle
          Padding(
            padding: const EdgeInsets.only(top: 4),
            child: Text(
              'Quantity: $quantity',
              style: AppTextStyles.subtitleSmall.copyWith(
                color: Colors.grey[600],
              ),
            ),
          ),
        ],
      ),
    );
  }
}