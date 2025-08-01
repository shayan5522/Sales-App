import 'package:flutter/material.dart';

class ResponsiveBarChart extends StatelessWidget {
  final List<BarData> data;
  final double maxYValue;
  final List<double> yAxisSteps;

  const ResponsiveBarChart({
    super.key,
    required this.data,
    required this.maxYValue,
    required this.yAxisSteps,
  });

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1.6,
      child: LayoutBuilder(
        builder: (context, constraints) {
          double fullHeight = constraints.maxHeight;
          double chartHeight = fullHeight - 40; // leave space for bottom labels

          return Padding(
            padding: const EdgeInsets.only(left: 8, right: 8),
            child: Stack(
              children: [
                // Y-Axis Grid Lines + Labels (Reversed)
                Positioned(
                  top: 0,
                  left: 0,
                  right: 0,
                  height: chartHeight,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: yAxisSteps.reversed.map((step) {
                      return Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SizedBox(
                            width: 30,
                            child: Text(
                              '${step.toInt()}k',
                              style: const TextStyle(
                                fontSize: 12,
                                color: Colors.grey,
                                fontWeight: FontWeight.bold,
                              ),
                              textAlign: TextAlign.right,
                            ),
                          ),
                          const SizedBox(width: 4),
                          Expanded(
                            child: Container(
                              height: 1,
                              color: Colors.grey.shade300,
                            ),
                          ),
                        ],
                      );
                    }).toList(),
                  ),
                ),

                // Bars with horizontal scroll
                Positioned(
                  bottom: 30,
                  left: 40,
                  right: 0,
                  height: chartHeight,
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: data.map((bar) {
                        double barHeight =
                            (bar.value / maxYValue) * chartHeight;

                        return Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Container(
                                height: barHeight,
                                width: 30,
                                decoration: BoxDecoration(
                                  color: Colors.blue,
                                  borderRadius: const BorderRadius.only(
                                    topLeft: Radius.circular(6),
                                    topRight: Radius.circular(6),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 4),
                              SizedBox(
                                width: 50,
                                child: Text(
                                  bar.label,
                                  style: const TextStyle(
                                    fontSize: 10,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ],
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class BarData {
  final String label;
  final double value;

  BarData({required this.label, required this.value});
}
