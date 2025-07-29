import 'package:flutter/material.dart';
import 'package:salesapp/app/themes/colors.dart';
import 'package:salesapp/app/themes/styles.dart';

class Salereportlist extends StatelessWidget {
  final String imagePath;
  final String name;
  final String Quantity;
  final String amount;

  const Salereportlist({
    super.key,
    required this.imagePath,
    required this.name,
    required this.Quantity,
    required this.amount,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      decoration: const BoxDecoration(
        color: AppColors.secondary,

        border: Border(bottom: BorderSide(color: Colors.black12, width: 1)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Image.asset(imagePath, width: 50, height: 50, fit: BoxFit.contain),
          const SizedBox(width: 12),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(name, style: AppTextStyles.title),
                const SizedBox(height: 4),
                Text(Quantity, style: AppTextStyles.subtitle),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 14),
              Row(
                children: [
                  const Icon(
                    Icons.currency_rupee,
                    color: AppColors.primary,
                    size: 18,
                  ),

                  Text(
                    amount,
                    style: AppTextStyles.title.copyWith(
                      color: AppColors.primary,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
