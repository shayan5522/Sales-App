import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import '../../themes/colors.dart';
import '../../themes/styles.dart';

class PrimaryButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final double widthFactor;
  final double heightFactor;
  final Color color;
  final double borderRadius;
  final TextStyle? textStyle;
  final bool isLoading;

  const PrimaryButton({super.key,
    required this.text,
    required this.onPressed,
    this.widthFactor = 0.8,
    this.heightFactor = 0.07,
    this.color = AppColors.primary,
    this.borderRadius = 10.0,
    this.textStyle,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final buttonWidth = screenWidth-30;
    final buttonHeight = screenHeight * heightFactor;
    return GestureDetector(
      onTap: isLoading ? null : onPressed,
      child: Container(
        width: buttonWidth,
        height: buttonHeight,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(borderRadius),
        ),
        child: Center(
          child: isLoading
              ? const SizedBox(
            width: 20,
            height: 20,
            child: CircularProgressIndicator(
              color: Colors.white,
              strokeWidth: 2,
            ),
          )
              : Text(
            text,
            style: textStyle ??
                AppTextStyles.subheading.copyWith(
                  color: AppColors.secondary,
                  fontWeight: FontWeight.w100,
                ),
          ),
        ),

      ),
    );
  }
}