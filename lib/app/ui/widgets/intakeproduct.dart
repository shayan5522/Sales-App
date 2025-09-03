import 'package:flutter/material.dart';
import 'package:shoporbit/app/themes/colors.dart';
import 'package:shoporbit/app/themes/styles.dart';

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
            child: Image.network(
              imagePath,
              width: 30,
              height: 30,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) => Image.asset(
                "assets/images/image_unavailable.png",
                height: 50,
                width: 50,
                fit: BoxFit.cover,
              ),
            ),
          ),
          const SizedBox(width: 12),
          // Wrap in Expanded to prevent overflow
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Top-right expense info if no stockCount
                if (stockCount == null)
                  Align(
                    alignment: Alignment.topRight,
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'INR:',
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
                Text(
                  stockCount == null
                      ? 'Total: $totalexpense'
                      : 'Stock Count: $stockCount',
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
                          'INR:',
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
