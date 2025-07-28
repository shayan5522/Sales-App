import 'package:flutter/material.dart';
import 'package:salesapp/app/themes/colors.dart' show AppColors;
import 'package:salesapp/app/ui/widgets/salescard.dart' show SalesCard;

class DummyTestScreen extends StatelessWidget {
  const DummyTestScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: AppBar(title: const Text('Dummy Test Screen')),
      body: Column(
        children: [
          Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                SalesCard(
                  imagePath: 'assets/images/sales.png',
                  label: 'Total Sales',
                  value: 15000,
                ),
              ],
            ), // Capitalized here ✅
          ),
        ],
      ),
    );
  }
}
