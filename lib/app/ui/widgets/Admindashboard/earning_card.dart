import 'package:flutter/material.dart';
import 'package:salesapp/app/themes/colors.dart';
import 'package:salesapp/app/themes/styles.dart';

class EarningsCard extends StatelessWidget {
  final String label;
  final String income;   // ✅ changed to String
  final String profit;   // ✅ changed to String
  final String imagePath;
  final VoidCallback onSeeAll;

  const EarningsCard({
    super.key,
    required this.label,
    required this.income,
    required this.profit,
    required this.imagePath,
    required this.onSeeAll,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final double padding = screenWidth * 0.04;
    final double imageSize = screenWidth * 0.28;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(padding),
      decoration: BoxDecoration(
        color: AppColors.secondary,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(color: Colors.black12, blurRadius: 4, offset: const Offset(0, 2)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Card Label
          Text(
            label,
            style: AppTextStyles.heading.copyWith(fontSize: 16),
          ),
          const SizedBox(height: 0),

          // Icon/Image
          Center(
            child: Image.asset(
              imagePath,
              width: imageSize,
              height: imageSize,
              fit: BoxFit.contain,
            ),
          ),
          const SizedBox(height: 5),

          // Income
          _buildEarningRow(label: 'Total Income', amount: income),
          const SizedBox(height: 5),

          // Profit
          _buildEarningRow(label: 'Total Profit', amount: profit),
          const SizedBox(height: 10),

          // See all
          Center(
            child: GestureDetector(
              onTap: onSeeAll,
              child: Text(
                'See All',
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

  Widget _buildEarningRow({required String label, required String amount}) {
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
            // const Icon(
            //   Icons.currency_rupee,
            //   color: AppColors.primary,
            //   size: 18,
            // ),
            Text(
              amount, // ✅ already formatted
              style: AppTextStyles.subtitle,
            ),
          ],
        ),
      ],
    );
  }
}
