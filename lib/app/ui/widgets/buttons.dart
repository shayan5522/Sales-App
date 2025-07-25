
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

  const PrimaryButton({super.key,
    required this.text,
    required this.onPressed,
    this.widthFactor = 0.8,
    this.heightFactor = 0.07,
    this.color = AppColors.primary,
    this.borderRadius = 10.0,
    this.textStyle,
  });

  @override
  Widget build(BuildContext context) {
    // Get the screen width and height
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    // Calculate the button width and height based on the screen size
    final buttonWidth = screenWidth-30;
    final buttonHeight = screenHeight * heightFactor;

    return GestureDetector(
      onTap: onPressed,
      child: Container(
        width: buttonWidth,
        height: buttonHeight,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(borderRadius),
        ),
        child: Center(
          child: Text(
            text,
            style: textStyle ??
                AppTextStyles.subheading
                    .copyWith(color: AppColors.secondary,fontWeight: FontWeight.w100),
          ),
        ),
      ),
    );
  }
}