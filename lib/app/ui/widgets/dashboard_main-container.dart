import 'package:flutter/material.dart';
import 'package:salesapp/app/themes/colors.dart';
import 'package:salesapp/app/themes/styles.dart';

class MainContainer extends StatelessWidget {
  final String imagePath;
  final String label;
  final VoidCallback? onTap;

  const MainContainer({
    super.key,
    required this.imagePath,
    required this.label,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final imageSize = screenWidth.isFinite && screenWidth > 0
        ? screenWidth * 0.15
        : 100.0;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 155.0,
        height: 160.0,  
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: AppColors.secondary,
          borderRadius: BorderRadius.circular(6.79),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset(
              imagePath,
              width: imageSize,
              height: imageSize,
              fit: BoxFit.contain,
            ),
            const SizedBox(height: 16),
            Text(
              label,
              style: AppTextStyles.heading,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
