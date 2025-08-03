import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:salesapp/app/themes/colors.dart';
import 'package:salesapp/app/themes/styles.dart';
import 'package:salesapp/app/ui/widgets/appbar.dart';
import 'package:salesapp/app/ui/widgets/buttons.dart';

import '../../../widgets/logout_dialog.dart';
import '../../auth/signup_as.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: CustomAppbar(
        title: 'Settings',
        backgroundColor: AppColors.primary,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(
          horizontal: screenWidth * 0.06,
          vertical: screenHeight * 0.03,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Invite Labour Card
            Container(
              width: double.infinity,
              margin: EdgeInsets.only(bottom: screenHeight * 0.02),
              padding: EdgeInsets.symmetric(
                horizontal: screenWidth * 0.04,
                vertical: screenHeight * 0.025,
              ),
              decoration: BoxDecoration(
                color: AppColors.secondary,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Invite Labour with Shop Code',
                    style: AppTextStyles.title.copyWith(
                      fontWeight: FontWeight.bold,
                      fontSize: screenWidth * 0.045,
                    ),
                  ),
                  SizedBox(height: screenHeight * 0.012),
                  Text(
                    'Your Code:',
                    style: AppTextStyles.subtitle.copyWith(
                      fontSize: screenWidth * 0.038,
                      color: Colors.grey[700],
                    ),
                  ),
                  SizedBox(height: screenHeight * 0.004),
                  Text(
                    '123456',
                    style: AppTextStyles.title.copyWith(
                      fontWeight: FontWeight.bold,
                      fontSize: screenWidth * 0.05,
                    ),
                  ),
                  SizedBox(height: screenHeight * 0.035),
                  SizedBox(
                    width: double.infinity,
                    height: screenHeight * 0.06,
                    child: PrimaryButton(
                      text: 'Copy Code',
                      onPressed: () {
                        // Copy code logic
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Code copied!')),
                        );
                      },
                      widthFactor: 1.0, // Full width
                      heightFactor: 0.055, // Responsive height
                      borderRadius: 8,
                      textStyle: AppTextStyles.title.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: screenWidth * 0.042,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: screenHeight * 0.01),

            // Subscription Info Card
            Container(
              width: double.infinity,
              margin: EdgeInsets.only(bottom: screenHeight * 0.04),
              padding: EdgeInsets.symmetric(
                horizontal: screenWidth * 0.04,
                vertical: screenHeight * 0.025,
              ),
              decoration: BoxDecoration(
                color: AppColors.secondary,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Subscription Info',
                    style: AppTextStyles.title.copyWith(
                      fontWeight: FontWeight.bold,
                      fontSize: screenWidth * 0.045,
                    ),
                  ),
                  SizedBox(height: screenHeight * 0.012),
                  Text(
                    'Valid Until: July 31, 2025',
                    style: AppTextStyles.subtitle.copyWith(
                      fontSize: screenWidth * 0.038,
                      color: Colors.grey[700],
                    ),
                  ),
                ],
              ),
            ),

            // Airplane icon (centered)
            // Padding(
            //   padding: EdgeInsets.symmetric(vertical: screenHeight * 0.04),
            //   child: Align(
            //     alignment: Alignment.centerRight,
            //     child: Icon(
            //       Icons.send_outlined,
            //       size: screenWidth * 0.08,
            //       color: AppColors.primary,
            //     ),
            //   ),
            // ),

            // Logout Button (use your custom button if you want)
            SizedBox(height: screenHeight * 0.09),
            PrimaryButton(
              text: 'Logout',
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return LogoutDialog(
                      onConfirm: () {
                        Get.back(); // Close the dialog
                        // TODO: Clear session/local storage if needed
                        Get.offAll(() => const SignUpAsScreen());
                      },
                      onCancel: () {
                        Get.back(); // Close the dialog
                      },
                    );
                  },
                );
              },
              widthFactor: 1.0,
              heightFactor: 0.06,
              borderRadius: 8,
              textStyle: AppTextStyles.title.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: screenWidth * 0.045,
              ),
            ),




          ],
        ),
      ),
    );
  }
}
