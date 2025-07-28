import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:salesapp/app/themes/styles.dart';
import 'package:salesapp/app/ui/screens/labour/labour_dashboard.dart';
import 'package:salesapp/app/ui/widgets/appbar.dart';
import 'package:salesapp/app/ui/widgets/buttons.dart';
import 'package:salesapp/app/ui/widgets/textfield.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class LabourSignUpScreen extends StatelessWidget {
  const LabourSignUpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final TextEditingController shopCodeController = TextEditingController();

    return Scaffold(
      appBar: CustomAppbar(title: "Labour SignUp"),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(height: 40),
                Center(child: Image.asset('assets/images/ownersignup.png', height: 160)),
                const SizedBox(height: 30),
                Text("Labour Registration", style: AppTextStyles.subheading),
                const SizedBox(height: 8),
                Text("Enter your unique invite code", style: AppTextStyles.subtitle.copyWith(color: Colors.black26)),
                const SizedBox(height: 32),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text("Invite Code", style: AppTextStyles.title),
                ),
                const SizedBox(height: 8),
                CustomTextField(
                  controller: shopCodeController,
                  labelText: 'Enter invite code',
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
                  text: "Register",
                  onPressed: () async {
                    final code = shopCodeController.text.trim().toUpperCase();
                    final user = FirebaseAuth.instance.currentUser;

                    if (code.isEmpty || user == null) {
                      Get.snackbar("Error", "Invite code required or user not logged in");
                      return;
                    }

                    final inviteDoc = await FirebaseFirestore.instance
                        .collection('invites')
                        .doc(code)
                        .get();

                    if (!inviteDoc.exists) {
                      Get.snackbar("Error", "Invalid invite code");
                      return;
                    }

                    final invite = inviteDoc.data()!;
                    final bool used = invite['used'] ?? false;

                    if (used) {
                      Get.snackbar("Error", "This invite code has already been used");
                      return;
                    }

                    final uid = user.uid;
                    final phone = user.phoneNumber ?? '';

                    // Register labour user
                    await FirebaseFirestore.instance.collection('users').doc(uid).set({
                      'uid': uid,
                      'phone': phone,
                      'role': 'labour',
                      'shopCode': code,
                      'ownerId': invite['ownerId'],
                    });

                    // Mark invite as used
                    await FirebaseFirestore.instance.collection('invites').doc(code).update({
                      'used': true,
                      'usedBy': uid,
                    });

                    Get.offAll(()=>LabourDashboard());
                  },
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
