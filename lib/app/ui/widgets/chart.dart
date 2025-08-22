import 'package:flutter/material.dart';
import 'dart:math';

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
          double chartHeight = fullHeight - 50; // Increased space for bottom labels
          final bool useCompactFormatting = maxYValue > 10000;

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
                      final label = _formatYAxisLabel(step, useCompactFormatting);
                      return Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SizedBox(
                            width: 36, // Slightly wider for larger numbers
                            child: Text(
                              label,
                              style: const TextStyle(
                                fontSize: 10, // Slightly smaller font
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
                  bottom: 40, // Increased bottom padding
                  left: 40, // Increased to accommodate wider Y-axis labels
                  right: 0,
                  height: chartHeight,
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: data.map((bar) {
                        double barHeight = maxYValue == 0
                            ? 0
                            : ((bar.value < 0 ? 0 : bar.value) / maxYValue) *
                            chartHeight;

                        // Calculate available height for bar after accounting for labels
                        double maxBarHeight = chartHeight - 40; // Reserve space for labels

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
                                      _formatYAxisLabel(bar.value, useCompactFormatting),
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
                                  height: 13, // Increased height for potential 2 lines
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

  String _formatYAxisLabel(double value, bool useCompactFormatting) {
    if (useCompactFormatting) {
      if (value >= 1000000) {
        return '${(value / 1000000).toStringAsFixed(1)}M';
      } else if (value >= 1000) {
        return '${(value / 1000).toStringAsFixed(1)}K';
      }
    }

    // For smaller values or when not using compact formatting
    if (value == value.truncateToDouble()) {
      return value.toInt().toString();
    } else if (value < 1) {
      return value.toStringAsFixed(2);
    } else {
      return value.toStringAsFixed(value < 10 ? 1 : 0);
    }
  }
}

class BarData {
  final String label;
  final double value;

  BarData({required this.label, required this.value});
}

// Utility class for consistent chart formatting across all reports
class ChartFormatter {
  static String formatValue(double value, {bool forceCompact = false}) {
    final bool useCompact = forceCompact || value.abs() >= 10000;

    if (useCompact) {
      if (value.abs() >= 1000000) {
        return '${(value / 1000000).toStringAsFixed(1)}M';
      } else if (value.abs() >= 1000) {
        return '${(value / 1000).toStringAsFixed(1)}K';
      }
    }

    if (value == value.truncateToDouble()) {
      return value.toInt().toString();
    } else if (value.abs() < 1) {
      return value.toStringAsFixed(2);
    } else {
      return value.toStringAsFixed(value.abs() < 10 ? 1 : 0);
    }
  }

  static List<double> calculateYAxisSteps(double maxValue, {int preferredSteps = 5}) {
    if (maxValue <= 0) return [0, 1, 2, 3, 4];

    // Calculate appropriate number of steps (4-6 is ideal)
    double rawStepSize = maxValue / preferredSteps;

    // Round to a "nice" interval
    double magnitude = pow(10, (log(rawStepSize) / ln10).floor()).toDouble();
    double residual = rawStepSize / magnitude;
    double stepSize;

    if (residual > 5) {
      stepSize = 10 * magnitude;
    } else if (residual > 2) {
      stepSize = 5 * magnitude;
    } else if (residual > 1) {
      stepSize = 2 * magnitude;
    } else {
      stepSize = magnitude;
    }

    // Generate steps
    final steps = <double>[];
    for (double value = 0; value <= maxValue * 1.05; value += stepSize) {
      steps.add(value);
    }

    return steps;
  }
}