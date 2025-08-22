import 'package:flutter/material.dart';
import 'chart_formatter.dart';

class ResponsiveBarChart extends StatelessWidget {
  final List<BarData> data;
  final double maxYValue;
  final List<double> yAxisSteps;
  final bool useLogarithmicScale;

  const ResponsiveBarChart({
    super.key,
    required this.data,
    required this.maxYValue,
    required this.yAxisSteps,
    this.useLogarithmicScale = false,
  });

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1.6,
      child: LayoutBuilder(
        builder: (context, constraints) {
          double fullHeight = constraints.maxHeight;
          double chartHeight = fullHeight - 50;
          final bool useCompactFormatting = maxYValue > 1000;
          final String valueScale = ChartFormatter.determineValueScale(maxYValue);

          return Padding(
            padding: const EdgeInsets.only(left: 8, right: 8),
            child: Stack(
              children: [
                // Y-Axis Grid Lines + Labels
                Positioned(
                  top: 0,
                  left: 0,
                  right: 0,
                  height: chartHeight,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: yAxisSteps.reversed.map((step) {
                      final label = _formatYAxisLabel(step, useCompactFormatting, valueScale);
                      return Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SizedBox(
                            width: valueScale.isNotEmpty ? 42 : 36,
                            child: Text(
                              label,
                              style: const TextStyle(
                                fontSize: 10,
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

                // Scale indicator (e.g., "Values in Millions")
                if (valueScale.isNotEmpty)
                  Positioned(
                    top: 0,
                    left: 0,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade200,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        'Values in ${valueScale == 'K' ? 'Thousands' : valueScale == 'M' ? 'Millions' : valueScale == 'B' ? 'Billions' : 'Trillions'}',
                        style: const TextStyle(
                          fontSize: 9,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),

                // Bars with horizontal scroll
                Positioned(
                  bottom: 22,
                  left: valueScale.isNotEmpty ? 46 : 40,
                  right: 0,
                  height: chartHeight,
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: data.map((bar) {
                        double scaledValue = ChartFormatter.scaleValue(bar.value, valueScale);
                        double scaledMaxValue = ChartFormatter.scaleValue(maxYValue, valueScale);

                        double barHeight = scaledMaxValue == 0
                            ? 0
                            : ((scaledValue < 0 ? 0 : scaledValue) / scaledMaxValue) *
                            chartHeight;

                        // Calculate available height for bar after accounting for labels
                        double maxBarHeight = chartHeight - 40;

                        return Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: SizedBox(
                            height: chartHeight,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                // Bar value label on top (only show if there's enough space)
                                if (bar.value > 0 && barHeight < maxBarHeight - 20)
                                  Padding(
                                    padding: const EdgeInsets.only(bottom: 4.0),
                                    child: Text(
                                      _formatYAxisLabel(bar.value, useCompactFormatting, valueScale),
                                      style: const TextStyle(
                                        fontSize: 9,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),

                                // Bar itself with constrained height
                                AnimatedContainer(
                                  duration: const Duration(milliseconds: 500),
                                  height: barHeight.clamp(0.0, maxBarHeight),
                                  width: 30,
                                  decoration: BoxDecoration(
                                    color: Colors.blue,
                                    borderRadius: const BorderRadius.only(
                                      topLeft: Radius.circular(6),
                                      topRight: Radius.circular(6),
                                    ),
                                    gradient: LinearGradient(
                                      begin: Alignment.bottomCenter,
                                      end: Alignment.topCenter,
                                      colors: [
                                        Colors.blue.shade700,
                                        Colors.blue.shade400,
                                      ],
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 4),

                                // Bar label with constrained height
                                SizedBox(
                                  width: 50,
                                  height: 32,
                                  child: Text(
                                    bar.label,
                                    style: const TextStyle(
                                      fontSize: 10,
                                      fontWeight: FontWeight.bold,
                                    ),
                                    textAlign: TextAlign.center,
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 2,
                                  ),
                                ),
                              ],
                            ),
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

  String _formatYAxisLabel(double value, bool useCompactFormatting, String scale) {
    // Use the ChartFormatter utility for consistent formatting
    return ChartFormatter.formatValue(value, forceCompact: useCompactFormatting);
  }
}

class BarData {
  final String label;
  final double value;

  BarData({required this.label, required this.value});
}