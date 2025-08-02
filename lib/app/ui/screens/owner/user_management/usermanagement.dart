import 'package:flutter/material.dart';
import 'package:salesapp/app/themes/colors.dart';
import 'package:salesapp/app/themes/styles.dart';
import 'package:salesapp/app/ui/widgets/appbar.dart';
import 'package:salesapp/app/ui/widgets/buttons.dart';

class UserManagementScreen extends StatelessWidget {
  const UserManagementScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    // Dummy data for labours
    final List<Map<String, dynamic>> labours = List.generate(
      3,
      (index) => {
        'name': 'Labour No: ${index + 1}',
        'image': 'assets/images/laboursignin.png', // Replace with your asset
      },
    );

    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: CustomAppbar(
        title: 'User Management',
        backgroundColor: AppColors.primary,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(
          horizontal: screenWidth * 0.06,
          vertical: screenHeight * 0.03,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Title
            Text(
              'Labours Information:',
              style: AppTextStyles.title.copyWith(
                fontWeight: FontWeight.bold,
                fontSize: screenWidth * 0.05,
              ),
            ),
            SizedBox(height: screenHeight * 0.02),

            // Labour Cards
            ...labours.map(
              (labour) => Container(
                width: double.infinity,
                margin: EdgeInsets.only(bottom: screenHeight * 0.025),
                padding: EdgeInsets.symmetric(
                  horizontal: screenWidth * 0.04,
                  vertical: screenHeight * 0.025,
                ),
                decoration: BoxDecoration(
                  color: AppColors.secondary,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Column(
                  children: [
                    Row(
                      children: [
                        // Labour image
                        ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.asset(
                            labour['image'],
                            width: screenWidth * 0.16,
                            height: screenWidth * 0.16,
                            fit: BoxFit.cover,
                          ),
                        ),
                        SizedBox(width: screenWidth * 0.05),
                        // Labour name
                        Expanded(
                          child: Text(
                            labour['name'],
                            style: AppTextStyles.title.copyWith(
                              fontWeight: FontWeight.bold,
                              fontSize: screenWidth * 0.045,
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: screenHeight * 0.018),
                    Row(
                      children: [
                        // Reset Invite Code Button
                        Expanded(
                          child: PrimaryButton(
                            text: 'Reset Invite Code',
                            onPressed: () {
                              // Reset logic
                            },
                            widthFactor: 1.0,
                            heightFactor: 0.05,
                            borderRadius: 6,
                            textStyle: AppTextStyles.title.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: screenWidth * 0.038,
                            ),
                          ),
                        ),
                        SizedBox(width: screenWidth * 0.04),
                        // Remove Button
                        Expanded(
                          child: PrimaryButton(
                            text: 'Remove',
                            onPressed: () {
                              // Remove logic
                            },
                            widthFactor: 1.0,
                            heightFactor: 0.05,
                            borderRadius: 6,
                            textStyle: AppTextStyles.title.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: screenWidth * 0.038,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            SizedBox(height: screenHeight * 0.06),

            // Logout Button
            PrimaryButton(
              text: 'Logout',
              onPressed: () {
                // Logout logic
              },
              widthFactor: 1.0,
              heightFactor: 0.065,
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
