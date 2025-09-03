import 'package:flutter/material.dart';
import 'package:shoporbit/app/themes/colors.dart';
import 'package:shoporbit/app/themes/styles.dart';

class SalesCard extends StatelessWidget {
  final String imagePath;
  final String label;
  final String value; // ✅ changed from int to String

  const SalesCard({
    super.key,
    required this.imagePath,
    required this.label,
    required this.value, // ✅ now a String
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 105,
      height: 160,
      margin: const EdgeInsets.symmetric(horizontal: 0),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
      decoration: BoxDecoration(
        color: AppColors.secondary,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(color: Colors.black12, blurRadius: 4, offset: Offset(0, 2)),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Image.asset(imagePath, width: 40, height: 40),
          Text(
            label,
            style: AppTextStyles.subtitleSmall,
            textAlign: TextAlign.center,
            overflow: TextOverflow.ellipsis,
            maxLines: 1,
          ),
          Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.currency_rupee, color: AppColors.primary, size: 18),
              Text(
                value, // ✅ already formatted string
                style: AppTextStyles.heading.copyWith(fontSize: 18),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

