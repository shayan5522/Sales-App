import 'package:flutter/material.dart';
import 'package:shoporbit/app/themes/colors.dart';
import 'package:shoporbit/app/themes/styles.dart';

class CenteredAmountCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final Color? subtitleColor; // Optional subtitle color

  const CenteredAmountCard({
    super.key,
    required this.title,
    required this.subtitle,
    this.subtitleColor, // Constructor parameter
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(6.0),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            title,
            style: AppTextStyles.title.copyWith(
              fontWeight: FontWeight.bold,
              fontSize: 14,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 6),
          Text(
            subtitle,
            style: AppTextStyles.subtitleSmall.copyWith(
              fontSize: 12,
              color: subtitleColor ?? AppColors
                  .primary, // Use provided color or default
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
