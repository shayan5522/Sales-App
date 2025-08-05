import 'package:flutter/material.dart';
import 'package:salesapp/app/themes/colors.dart';
import 'package:salesapp/app/themes/styles.dart';

class SummaryCard extends StatelessWidget {
  final String amount;
  final String label;

  const SummaryCard({super.key, required this.amount, required this.label});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Container(
      // Removed width: screenWidth * 0.25
      padding: EdgeInsets.symmetric(
        vertical: screenWidth * 0.04,
        horizontal: screenWidth * 0.03,
      ),
      decoration: BoxDecoration(
        color: AppColors.secondary,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          FittedBox(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.currency_rupee,
                  color: AppColors.primary,
                  size: screenWidth * 0.06,
                ),
                Text(
                  amount,
                  style: AppTextStyles.title.copyWith(
                    fontWeight: FontWeight.bold,
                    fontSize: screenWidth * 0.055,
                    color: Colors.black,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: screenWidth * 0.02),
          Text(
            label,
            style: AppTextStyles.subtitleSmall.copyWith(
              fontSize: screenWidth * 0.035,
              color: AppColors.textPrimary,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

