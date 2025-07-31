import 'package:flutter/material.dart';
import 'package:salesapp/app/themes/colors.dart' show AppColors;
import 'package:salesapp/app/ui/screens/owner/addintake.dart';

import 'package:salesapp/app/ui/screens/owner/products.dart';
import 'package:salesapp/app/ui/widgets/Admindashboard/earning_card.dart';
import 'package:salesapp/app/ui/widgets/buttons.dart';
import 'package:get/get.dart';

class DummyTestScreen extends StatelessWidget {
  const DummyTestScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: AppBar(title: const Text('Dummy Test Screen')),
      body: Column(
        children: [
          PrimaryButton(
            text: 'Intake',
            onPressed: () {
              Get.to(() => Intake());
            },
          ),
          Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [Row(children: [
                    
                  ],
                )],
            ), // Capitalized here ✅
          ),

          const SizedBox(height: 8),
          Container(
            width: double.infinity,
            height: 200,
            child: PrimaryButton(
              text: 'Products',
              onPressed: () {
                Get.to(() => ProductScreen());
              },
            ),
          ),
          const SizedBox(height: 16),
          EarningsCard(
            income: 5000,
            profit: 2000,
            imagePath: 'assets/images/earning.png',
            onSeeAll: () {
              // Handle see all action
            },
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}
