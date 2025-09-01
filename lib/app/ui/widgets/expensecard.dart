import 'package:flutter/material.dart';
import 'package:shoporbit/app/themes/colors.dart';
import 'package:shoporbit/app/themes/styles.dart';

class ProductExpenseCard extends StatelessWidget {
  final String imagePath;
  final String productName;
  final String inTaken;
  final String totalExpense;
  final String amount;

  const ProductExpenseCard({
    super.key,
    required this.imagePath,
    required this.productName,
    required this.inTaken,
    required this.totalExpense,
    required this.amount,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final cellWidth = constraints.maxWidth;
        final cellHeight = constraints.maxHeight;

        return Container(
          margin: EdgeInsets.all(cellWidth * 0.03),
          padding: EdgeInsets.symmetric(
            vertical: cellHeight * 0.08,
            horizontal: cellWidth * 0.03,
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
                  width: cellWidth * 0.22,
                  height: cellWidth * 0.22,
                  fit: BoxFit.contain,
                ),
              ),
              SizedBox(width: cellWidth * 0.04),
              // Text info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Top row: product name and amount
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Text(
                            productName,
                            style: AppTextStyles.title.copyWith(
                              fontWeight: FontWeight.bold,
                              fontSize: cellWidth * 0.11,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        SizedBox(width: 4),
                        Text(
                          'INR. $amount',
                          style: AppTextStyles.subtitleSmall.copyWith(
                            fontSize: cellWidth * 0.09,
                            color: AppColors.primary,
                            fontWeight: FontWeight.bold,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                    SizedBox(height: cellHeight * 0.02),
                    Text(
                      'In-taken: $inTaken',
                      style: AppTextStyles.subtitleSmall.copyWith(
                        fontSize: cellWidth * 0.08,
                        color: Colors.black87,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      'Total Expense:$totalExpense',
                      style: AppTextStyles.subtitleSmall.copyWith(
                        fontSize: cellWidth * 0.08,
                        color: Colors.black87,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
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
