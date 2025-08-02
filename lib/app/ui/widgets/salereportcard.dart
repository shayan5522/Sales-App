import 'package:flutter/material.dart';
import 'package:salesapp/app/themes/colors.dart';
import 'package:salesapp/app/themes/styles.dart';

class Salereportcard extends StatelessWidget {
  final String imagePath;
  final String totalSold;
  final String income;
  final String profit;

  const Salereportcard({
    super.key,
    required this.imagePath,
    required this.totalSold,
    required this.income,
    required this.profit,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        // Use the cell's width, not the whole screen!
        final cellWidth = constraints.maxWidth;

        return Container(
          margin: EdgeInsets.all(cellWidth * 0.05), // 5% of cell width
          padding: EdgeInsets.symmetric(
            vertical: cellWidth * 0.08,
            horizontal: cellWidth * 0.05,
          ),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 4,
                offset: Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Event image
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.asset(
                  imagePath,
                  width: cellWidth * 0.28, // 28% of cell width
                  height: cellWidth * 0.28,
                  fit: BoxFit.contain,
                ),
              ),
              SizedBox(width: cellWidth * 0.05),
              // Text info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      totalSold,
                      style: AppTextStyles.title.copyWith(
                        fontWeight: FontWeight.bold,
                        fontSize: cellWidth * 0.13,
                      ),
                    ),
                    SizedBox(height: cellWidth * 0.03),
                    Text(
                      'Income: $income',
                      style: AppTextStyles.subtitleSmall.copyWith(
                        fontSize: cellWidth * 0.09,
                      ),
                    ),
                    Text(
                      'Profit: $profit',
                      style: AppTextStyles.subtitleSmall.copyWith(
                        fontSize: cellWidth * 0.09,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
