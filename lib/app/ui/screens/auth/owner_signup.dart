import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:salesapp/app/themes/styles.dart';
import 'package:salesapp/app/ui/screens/owner/owner_dashboard.dart';
import 'package:salesapp/app/ui/widgets/appbar.dart';
import 'package:salesapp/app/ui/widgets/buttons.dart';
import 'package:salesapp/app/ui/widgets/textfield.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../themes/colors.dart';

class OwnerSignUpScreen extends StatefulWidget {
  const OwnerSignUpScreen({super.key});

  @override
  State<OwnerSignUpScreen> createState() => _OwnerSignUpScreenState();
}
List<String> generateInviteCodes(int count) {
  const chars = 'ABCDEFGHJKLMNPQRSTUVWXYZ23456789';
  return List.generate(count, (_) {
    return List.generate(6, (i) => chars[(DateTime.now().microsecondsSinceEpoch + i) % chars.length]).join();
  });
}


class _OwnerSignUpScreenState extends State<OwnerSignUpScreen> {
  @override
  Widget build(BuildContext context) {
    final TextEditingController shopNameController = TextEditingController();

    return Scaffold(
      appBar: CustomAppbar(title: "Owner SignUp"),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(height: 40),
              Center(
                child: Image.asset('assets/images/ownersignup.png', height: 160),
              ),
              const SizedBox(height: 30),
              Text("Owner Registration", style: AppTextStyles.subheading),
              const SizedBox(height: 8),
              Text("Create an account and enjoy the App", style: AppTextStyles.subtitle.copyWith(color: Colors.black26)),
              const SizedBox(height: 32),
              Align(
                alignment: Alignment.centerLeft,
                child: Text("Shop Name", style: AppTextStyles.title),
              ),
              const SizedBox(height: 8),
              CustomTextField(
                controller: shopNameController,
                labelText: 'Enter shop name',
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  Checkbox(value: true, onChanged: (value) {}, visualDensity: VisualDensity.compact),
                  Expanded(child: Text("I agree to terms and conditions", style: AppTextStyles.subtitleSmall)),
                ],
              ),
              const SizedBox(height: 16),
              PrimaryButton(
                text: "Sign Up",
                onPressed: () async {
                  final shopName = shopNameController.text.trim();
                  final user = FirebaseAuth.instance.currentUser;

                  if (shopName.isEmpty || user == null) {
                    Get.snackbar("Error", "Shop name required or user not logged in");
                    return;
                  }

                  final uid = user.uid;
                  final phone = user.phoneNumber ?? '';
                  final shopCode = uid.substring(0, 6).toUpperCase();

                  // Save owner user
                  await FirebaseFirestore.instance.collection('users').doc(uid).set({
                    'uid': uid,
                    'phone': phone,
                    'role': 'owner',
                    'shopName': shopName,
                    'shopCode': shopCode,
                  });

                  // Generate 3 unique invite codes
                  final inviteCodes = generateInviteCodes(3);

                  for (String code in inviteCodes) {
                    await FirebaseFirestore.instance.collection('invites').doc(code).set({
                      'code': code,
                      'ownerId': uid,
                      'used': false,
                      'usedBy': null,
                      'createdAt': FieldValue.serverTimestamp(),
                    });
                  }

                  Get.offAll(() => OwnerDashboard());
                },

              ),
              // const Spacer(),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Already have an account? ", style: AppTextStyles.subtitle),
                  GestureDetector(
                    onTap: () {}, // Optional: link to login screen
                    child: Text("Sign In", style: TextStyle(fontWeight: FontWeight.bold, color: AppColors.primary)),
                  ),
                ],
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
