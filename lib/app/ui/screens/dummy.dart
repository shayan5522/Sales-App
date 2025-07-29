import 'package:flutter/material.dart';
import 'package:salesapp/app/themes/colors.dart' show AppColors;
import 'package:salesapp/app/ui/widgets/Expense/expensecard.dart';
import 'package:salesapp/app/ui/widgets/chart.dart';
import 'package:salesapp/app/ui/widgets/intakeproduct.dart';
import 'package:salesapp/app/ui/widgets/transactionlist.dart';

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
              children: [Row(children: [
                    
                  ],
                )],
            ), // Capitalized here ✅
          ),

          const SizedBox(height: 8),
          Container(
            width: double.infinity,
            height: 200,
            child: ResponsiveBarChart(
              maxYValue: 8000,
              yAxisSteps: [0, 2, 4, 6, 8],
              data: [
                BarData(label: 'Product 1', value: 4000),
                BarData(label: 'Product 2', value: 7000),
                BarData(label: 'Product 3', value: 5000),
                BarData(label: 'Product 4', value: 1000),
                BarData(label: 'Product 4', value: 2000),
                BarData(label: 'Product 4', value: 3000),
                BarData(label: 'Product 4', value: 4000),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
