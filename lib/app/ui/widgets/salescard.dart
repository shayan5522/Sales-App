import 'package:flutter/material.dart';
import 'package:salesapp/app/themes/colors.dart';
import 'package:salesapp/app/themes/styles.dart';

class SalesCard extends StatelessWidget {
  final String imagePath;
  final String label;
  final int value;

  const SalesCard({
    super.key,
    required this.imagePath,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final double iconSize = screenWidth * 0.2;

    return Container(
      height: 160.0,
      width: 120.0,
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: AppColors.secondary,
        borderRadius: BorderRadius.circular(3),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(child: Image.asset(imagePath, fit: BoxFit.contain)),
          const SizedBox(height: 16),

          Text(
            label,
            style: AppTextStyles.heading,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),

          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.currency_rupee,
                color: AppColors.primary,
                size: 22,
              ),
              Text(value.toString(), style: AppTextStyles.heading),
            ],
          ),
        ],
      ),
    );
  }
}
