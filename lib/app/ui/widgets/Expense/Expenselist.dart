import 'package:flutter/material.dart';
import 'package:salesapp/app/themes/colors.dart';
import 'package:salesapp/app/themes/styles.dart';

class CustomExpenseListTile extends StatelessWidget {
  final String title;
  final String description;
  final int price;

  const CustomExpenseListTile({
    super.key,
    required this.title,
    required this.description,
    required this.price,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 4),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ListTile(
            contentPadding: EdgeInsets.zero,
            title: Text(title, style: AppTextStyles.title),
            subtitle: Padding(
              padding: const EdgeInsets.only(top: 6),
              child: Text(
                description,
                style: AppTextStyles.subtitleSmall.copyWith(
                  color: AppColors.textseconadry,
                ),
              ),
            ),
          ),
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
                  '$price',
                  style: AppTextStyles.subtitleSmall.copyWith(
                    color: AppColors.primary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
