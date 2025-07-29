import 'package:flutter/material.dart';
import 'package:salesapp/app/themes/colors.dart';
import 'package:salesapp/app/themes/styles.dart';

class GridCard extends StatelessWidget {
  final String imagePath;
  final String title;
  final int price;

  const GridCard({
    super.key,
    required this.imagePath,
    required this.title,
    required this.price,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final double cardWidth =
        (screenWidth - 64) / 3; // 3 cards with 16px margin between

    return Container(
      width: cardWidth,
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
      decoration: BoxDecoration(
        color: AppColors.secondary,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Image.asset(
            imagePath,
            width: cardWidth * 0.4,
            height: cardWidth * 0.4,
            fit: BoxFit.contain,
          ),
          const SizedBox(height: 12),
          Text(
            title,
            style: AppTextStyles.heading.copyWith(fontSize: 14),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 6),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.currency_rupee, size: 16, color: Colors.blue),
              Text(
                price.toString(),
                style: AppTextStyles.subtitle.copyWith(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
