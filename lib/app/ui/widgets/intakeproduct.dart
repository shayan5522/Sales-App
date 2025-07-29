import 'package:flutter/material.dart';
import 'package:salesapp/app/themes/colors.dart';
import 'package:salesapp/app/themes/styles.dart';

class IntakeProduct extends StatelessWidget {
  final String imagePath;
  final String productName;
  final int intaken;
  final int? totalexpense;
  final int? stockCount;

  const IntakeProduct({
    super.key,
    required this.imagePath,
    required this.productName,
    required this.intaken,
    this.totalexpense,
    this.stockCount,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      margin: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: AppColors.secondary,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.asset(
              imagePath,
              width: 50,
              height: 50,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (stockCount == null)
                  Align(
                    alignment: Alignment.topRight,
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'INR :',
                          style: AppTextStyles.subtitleSmall.copyWith(
                            color: AppColors.primary,
                          ),
                        ),
                        Text(
                          '$totalexpense',
                          style: AppTextStyles.subtitleSmall.copyWith(
                            color: AppColors.primary,
                          ),
                        ),
                      ],
                    ),
                  ),
                Text(productName, style: AppTextStyles.title),
                const SizedBox(height: 4),
                Text(
                  'Intaken: $intaken',
                  style: AppTextStyles.subtitleSmall.copyWith(
                    color: AppColors.textseconadry,
                  ),
                ),
                const SizedBox(height: 2),
                stockCount == null
                    ? Text(
                        'Total: $totalexpense',
                        style: AppTextStyles.subtitleSmall.copyWith(
                          color: AppColors.textseconadry,
                        ),
                      )
                    : Text(
                        'Stock Count: $stockCount',
                        style: AppTextStyles.subtitleSmall.copyWith(
                          color: AppColors.textseconadry,
                        ),
                      ),
                if (stockCount != null) ...[
                  const SizedBox(height: 6),
                  Align(
                    alignment: Alignment.bottomRight,
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'INR :',
                          style: AppTextStyles.subtitleSmall.copyWith(
                            color: AppColors.primary,
                          ),
                        ),
                        Text(
                          '$totalexpense',
                          style: AppTextStyles.subtitleSmall.copyWith(
                            color: AppColors.primary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}
