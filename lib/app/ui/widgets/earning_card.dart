import 'package:flutter/material.dart';
import 'package:salesapp/app/themes/colors.dart';
import 'package:salesapp/app/themes/styles.dart';

class EarningsCard extends StatefulWidget {
  const EarningsCard({super.key});

  @override
  State<EarningsCard> createState() => _EarningsCardState();
}

class _EarningsCardState extends State<EarningsCard> {
  int income = 112;
  int profit = 112;

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final double padding = screenWidth * 0.05;
    final double imageSize = screenWidth * 0.2;

    return Container(
      padding: EdgeInsets.all(padding),
      decoration: BoxDecoration(
        color: AppColors.secondary,
        borderRadius: BorderRadius.circular(3),
        
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Image.asset(
              'assets/images/earning.png',
              width: imageSize,
              height: imageSize,
              fit: BoxFit.contain,
            ),
          ),
          const SizedBox(height: 12),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  'Total Income online',
                  style: AppTextStyles.description,
                ),
              ),
              Row(
                children: [
                  const Icon(Icons.currency_rupee, color: AppColors.primary, size: 18),
                  Text(
                    income.toString(),
                    style: AppTextStyles.subtitle,
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 8),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  'Total Profit online',
                  style: AppTextStyles.description,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Row(
                children: [
                  const Icon(Icons.currency_rupee, color: AppColors.primary, size: 18),
                  Text(
                    profit.toString(),
                    style: AppTextStyles.subtitle,
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 12),

          Center(
            child: GestureDetector(
              onTap: () {
                debugPrint('See all tapped');
              },
              child: Text(
                'see all',
                style: AppTextStyles.subtitleSmall2.copyWith(
                  decoration: TextDecoration.underline,
                  fontWeight: FontWeight.w900, fontSize: 12,
                  color: AppColors.primary  ,
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
