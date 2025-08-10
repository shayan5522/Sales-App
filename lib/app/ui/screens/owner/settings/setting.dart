import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:salesapp/app/controllers/owner/owner_invite_controller.dart';
import 'package:salesapp/app/themes/colors.dart';
import 'package:salesapp/app/themes/styles.dart';
import 'package:salesapp/app/ui/widgets/appbar.dart';
import 'package:salesapp/app/ui/widgets/buttons.dart';
import 'package:salesapp/app/ui/widgets/custom_snackbar.dart';
import '../../../../controllers/auth/logout_helper.dart';
import '../../../../controllers/owner/owner_invite_controller.dart';
import '../../../widgets/logout_dialog.dart';

class SettingsScreen extends StatelessWidget {
  SettingsScreen({super.key});

  final OwnerInviteController inviteController = Get.put(OwnerInviteController());

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: CustomAppbar(
        title: 'Settings',
        backgroundColor: AppColors.primary,
        showBackButton: false,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(
          horizontal: screenWidth * 0.06,
          vertical: screenHeight * 0.03,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            /// 🔹 Labour Invite Card
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
              child: StreamBuilder<List<Map<String, dynamic>>>(
                stream: inviteController.inviteStream(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (snapshot.hasError) {
                    return const Text("Something went wrong");
                  }

                  final codes = snapshot.data ?? [];

                  if (codes.isEmpty) {
                    return const Text("No invite codes found");
                  }

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Labour Invite Codes',
                        style: AppTextStyles.title.copyWith(
                          fontWeight: FontWeight.bold,
                          fontSize: screenWidth * 0.045,
                        ),
                      ),
                      const SizedBox(height: 12),
                      ...codes.map((codeData) {
                        final code = codeData['code'];
                        final used = codeData['used'] == true;

                        return Container(
                          margin: const EdgeInsets.only(bottom: 10),
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: used ? Colors.grey[300] : Colors.white,
                            borderRadius: BorderRadius.circular(6),
                            border: Border.all(color: AppColors.primary, width: 1),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    code ?? 'Unknown',
                                    style: AppTextStyles.title.copyWith(
                                      fontWeight: FontWeight.bold,
                                      fontSize: screenWidth * 0.042,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    used ? 'Used' : 'Not Used',
                                    style: AppTextStyles.subtitle.copyWith(
                                      color: used ? Colors.red : Colors.green,
                                      fontSize: screenWidth * 0.035,
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  IconButton(
                                    icon: const Icon(Icons.copy),
                                    onPressed: () {
                                      Clipboard.setData(ClipboardData(text: code));
                                      CustomSnackbar.show(
                                        title: "Copied",
                                        message: "Invite code copied!",
                                        isError: false,
                                      );
                                    },
                                  ),
                                  IconButton(
                                    icon: const Icon(Icons.delete, color: Colors.red),
                                    onPressed: () {
                                      Get.defaultDialog(
                                        title: "",
                                        titlePadding: EdgeInsets.zero,
                                        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                                        backgroundColor: Colors.white,
                                        radius: 15,
                                        content: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            const Icon(Icons.delete_forever, color: Colors.red, size: 50),
                                            const SizedBox(height: 12),
                                            Text(
                                              "Delete Invite",
                                              style: TextStyle(
                                                fontSize: 20,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.red[700],
                                              ),
                                            ),
                                            const SizedBox(height: 8),
                                            const Text(
                                              "Are you sure you want to delete this code?",
                                              textAlign: TextAlign.center,
                                              style: TextStyle(fontSize: 16, color: Colors.black87),
                                            ),
                                            const SizedBox(height: 20),
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                              children: [
                                                ElevatedButton(
                                                  style: ElevatedButton.styleFrom(
                                                    backgroundColor: Colors.grey[300],
                                                    foregroundColor: Colors.black87,
                                                    shape: RoundedRectangleBorder(
                                                      borderRadius: BorderRadius.circular(8),
                                                    ),
                                                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                                                  ),
                                                  onPressed: () => Get.back(),
                                                  child: const Text("Cancel"),
                                                ),
                                                ElevatedButton(
                                                  style: ElevatedButton.styleFrom(
                                                    backgroundColor: Colors.red,
                                                    foregroundColor: Colors.white,
                                                    shape: RoundedRectangleBorder(
                                                      borderRadius: BorderRadius.circular(8),
                                                    ),
                                                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                                                  ),
                                                  onPressed: () async {
                                                    await inviteController.deleteInvite(codeData['id']);
                                                    Get.back();
                                                  },
                                                  child: const Text("Yes, Delete"),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      );

                                    },
                                  ),
                                ],
                              ),
                            ],
                          )

                        );
                      }).toList(),
                    ],
                  );
                },
              ),

            ),

            /// 🔹 Subscription Info Card
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

            /// 🔹 Logout Button
            SizedBox(height: screenHeight * 0.09),
            PrimaryButton(
              text: 'Logout',
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return LogoutDialog(
                      onConfirm: () async {
                        Get.back();
                        await logoutUser();
                      },
                      onCancel: () {
                        Get.back();
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
