import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:salesapp/app/themes/colors.dart';
import 'package:salesapp/app/themes/styles.dart';
import 'package:salesapp/app/ui/screens/owner/user_management/user_management_controller.dart';
import 'package:salesapp/app/ui/widgets/appbar.dart';
import 'package:salesapp/app/ui/widgets/buttons.dart';

class UserManagementScreen extends StatefulWidget {
  const UserManagementScreen({super.key});

  @override
  State<UserManagementScreen> createState() => _UserManagementScreenState();
}

class _UserManagementScreenState extends State<UserManagementScreen> {
  final controller = Get.put(UserManagementController());

  @override
  void initState() {
    super.initState();
    controller.fetchInvites();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: CustomAppbar(
        title: 'User Management',
        backgroundColor: AppColors.primary,
      ),
      body: Obx(
            () => controller.invites.isEmpty
            ? const Center(child: CircularProgressIndicator())
            : SingleChildScrollView(
          padding: EdgeInsets.symmetric(
            horizontal: screenWidth * 0.06,
            vertical: screenHeight * 0.03,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Labours Information:',
                style: AppTextStyles.title.copyWith(
                  fontWeight: FontWeight.bold,
                  fontSize: screenWidth * 0.05,
                ),
              ),
              SizedBox(height: screenHeight * 0.02),

              ...controller.invites.map(
                    (invite) => Container(
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
                          ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Image.asset(
                              'assets/images/laboursignin.png',
                              width: screenWidth * 0.16,
                              height: screenWidth * 0.16,
                              fit: BoxFit.cover,
                            ),
                          ),
                          SizedBox(width: screenWidth * 0.05),
                          Expanded(
                            child: Text(
                              'Code: ${invite['code']}\nStatus: ${invite['used'] ? 'Used' : 'Unused'}',
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
                          Expanded(
                            child: PrimaryButton(
                              text: 'Reset Invite Code',
                              onPressed: () {
                                controller.resetInviteCode(invite['id']);
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
                          // Expanded(
                          //   child: PrimaryButton(
                          //     text: 'Remove',
                          //     onPressed: () {
                          //       controller.deleteInvite(invite['id']);
                          //     },
                          //     widthFactor: 1.0,
                          //     heightFactor: 0.05,
                          //     borderRadius: 6,
                          //     textStyle: AppTextStyles.title.copyWith(
                          //       color: Colors.white,
                          //       fontWeight: FontWeight.bold,
                          //       fontSize: screenWidth * 0.038,
                          //     ),
                          //   ),
                          // ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),

              SizedBox(height: screenHeight * 0.06),
            ],
          ),
        ),
      ),
    );
  }
}