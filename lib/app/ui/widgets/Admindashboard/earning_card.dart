import 'package:flutter/material.dart';
import 'package:salesapp/app/themes/colors.dart';
import 'package:salesapp/app/themes/styles.dart';

class EarningsCard extends StatelessWidget {
  final int income;
  final int profit;
  final String imagePath;
  final VoidCallback onSeeAll;

  const EarningsCard({
    super.key,
    required this.income,
    required this.profit,
    required this.imagePath,
    required this.onSeeAll,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final double padding = screenWidth * 0.04;
    final double imageSize = screenWidth * 0.22;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(padding),
      decoration: BoxDecoration(
        color: AppColors.secondary,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(color: Colors.black12, blurRadius: 4, offset: Offset(0, 2)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Icon/Image
          Center(
            child: Image.asset(
              imagePath,
              width: imageSize,
              height: imageSize,
              fit: BoxFit.contain,
            ),
          ),
          const SizedBox(height: 16),

          // Income
          _buildEarningRow(label: 'Total Income online', amount: income),
          const SizedBox(height: 10),

          // Profit
          _buildEarningRow(label: 'Total Profit online', amount: profit),
          const SizedBox(height: 16),

          // See all
          Center(
            child: GestureDetector(
              onTap: onSeeAll,
              child: Text(
                'see all',
                style: AppTextStyles.subtitleSmall2.copyWith(
                  decoration: TextDecoration.underline,
                  fontWeight: FontWeight.w700,
                  fontSize: 12,
                  color: AppColors.primary,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEarningRow({required String label, required int amount}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Text(
            label,
            style: AppTextStyles.description,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        Row(
          children: [
            const Icon(
              Icons.currency_rupee,
              color: AppColors.primary,
              size: 18,
            ),
            Text(amount.toString(), style: AppTextStyles.subtitle),
          ],
        ),
      ],
    );
  }
}
