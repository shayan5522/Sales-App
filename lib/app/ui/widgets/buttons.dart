import 'package:flutter/material.dart';
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

  const PrimaryButton({
    super.key,
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

    // Calculate the button width and height based on the screen size
    final buttonWidth = screenWidth - 30;
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
                  style:
                      textStyle ??
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

class SecondaryButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final double widthFactor;
  final double heightFactor;
  final Color color;
  final Color textColor; // ✅ Added
  final double borderRadius;
  final TextStyle? textStyle;

  const SecondaryButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.widthFactor = 0.24,
    this.heightFactor = 0.035,
    this.color = AppColors.primary,
    this.textColor = Colors.white, // ✅ Default
    this.borderRadius = 6.0,
    this.textStyle,
  });

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;

    return SizedBox(
      width: screenSize.width * widthFactor,
      height: screenSize.height * heightFactor,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(borderRadius),
          ),
          padding: EdgeInsets.zero,
          elevation: 0,
        ),
        child: Text(
          text,
          style: textStyle ??
              AppTextStyles.title.copyWith(
                color: textColor, // ✅ Use dynamic text color
                fontSize: screenSize.width < 360 ? 11 : 13,
              ),
        ),
      ),
    );
  }
}
