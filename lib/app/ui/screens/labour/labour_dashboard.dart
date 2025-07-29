import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart' show Get;
import 'package:salesapp/app/ui/screens/auth/signup_as.dart';

import '../../widgets/buttons.dart';
class LabourDashboard extends StatelessWidget {
  const LabourDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
            child: Text("labour Dashboard"),
          ),
          PrimaryButton(
            text: 'Logout',
            onPressed: () {
              Get.offAll(()=>SignUpAsScreen());
            },),
        ],
      ),
    );
  }
}
