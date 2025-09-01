import 'package:flutter/material.dart';
import 'package:shoporbit/app/themes/styles.dart';

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
        final cellWidth = constraints.maxWidth;
        final cellHeight = constraints.maxHeight;

        return Container(
          margin: EdgeInsets.all(cellWidth * 0.03),
          padding: EdgeInsets.symmetric(
            vertical: cellHeight * 0.08,
            horizontal: cellWidth * 0.02,
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
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      totalSold,
                      style: AppTextStyles.title.copyWith(
                        fontWeight: FontWeight.bold,
                        fontSize: cellWidth * 0.11,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: cellHeight * 0.02),
                    Text(
                      'Income: $income',
                      style: AppTextStyles.subtitleSmall.copyWith(
                        fontSize: cellWidth * 0.08,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      'Profit: $profit',
                      style: AppTextStyles.subtitleSmall.copyWith(
                        fontSize: cellWidth * 0.08,
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
