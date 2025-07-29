import 'package:flutter/material.dart';
import 'package:salesapp/app/themes/colors.dart';
import 'package:salesapp/app/themes/styles.dart';

class SalesStatsCard extends StatelessWidget {
  final String imagePath;
  final int totalSold;
  final int income;
  final int profit;

  const SalesStatsCard({
    super.key,
    required this.imagePath,
    required this.totalSold,
    required this.income,
    required this.profit,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
        color: AppColors.secondary,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.asset(
              imagePath,
              width: 48,
              height: 48,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(width: 12),

          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '$totalSold Sold',
                style: AppTextStyles.title.copyWith(fontSize: 16),
              ),
              const SizedBox(height: 4),
              Row(
                children: [
                  Text('Income: ', style: AppTextStyles.subtitle),
                  const Icon(
                    Icons.currency_rupee,
                    size: 14,
                    color: AppColors.textPrimary,
                  ),
                  Text('$income', style: AppTextStyles.subtitle),
                ],
              ),

              Row(
                children: [
                  Text('Profit: ', style: AppTextStyles.subtitle),
                  const Icon(
                    Icons.currency_rupee,
                    size: 14,
                    color: AppColors.textPrimary,
                  ),
                  Text('$profit', style: AppTextStyles.subtitle),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
