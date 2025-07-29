import 'package:flutter/material.dart';
import 'package:salesapp/app/themes/colors.dart';
import 'package:salesapp/app/themes/styles.dart';

class TransactionTextRow extends StatelessWidget {
  final String product;
  final int amount;

  const TransactionTextRow({
    super.key,
    required this.product,
    required this.amount,
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
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Product name
          Text(product, style: AppTextStyles.subtitleSmall),
          // Amount with ₹
          Row(
            children: [
              const Icon(Icons.currency_rupee, size: 14, color: Colors.blue),
              Text(
                amount.toString(),
                style: AppTextStyles.subtitleSmall.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
