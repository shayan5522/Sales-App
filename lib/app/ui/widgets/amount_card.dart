import 'package:flutter/material.dart';
import 'package:shoporbit/app/themes/colors.dart';
import 'package:shoporbit/app/themes/styles.dart';

class AmountCard extends StatelessWidget {
  final String title;
  final double amount;
  final Color color;
  final bool showCurrency;

  const AmountCard({
    super.key,
    required this.title,
    required this.amount,
    this.color = AppColors.primary,
    this.showCurrency = true,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8.0),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: AppTextStyles.title.copyWith(
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              if (showCurrency)
                Padding(
                  padding: const EdgeInsets.only(bottom: 2),
                  child: Text(
                    '₹',
                    style: AppTextStyles.subtitle.copyWith(
                      color: color,
                      fontSize: 16,
                    ),
                  ),
                ),
              const SizedBox(width: 4),
              Text(
                amount.toStringAsFixed(2),
                style: AppTextStyles.subheading.copyWith(
                  color: color,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}