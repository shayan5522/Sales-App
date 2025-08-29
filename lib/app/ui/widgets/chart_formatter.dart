import 'dart:math';

class ChartFormatter {
  static String formatValue(double value, {bool forceCompact = false}) {
    final bool useCompact = forceCompact || value.abs() >= 1000;

    if (useCompact) {
      final absValue = value.abs();

      if (absValue >= 1000000000000) { // Trillions
        return '${(value / 1000000000000).toStringAsFixed(2)}T';
      } else if (absValue >= 1000000000) { // Billions
        return '${(value / 1000000000).toStringAsFixed(2)}B';
      } else if (absValue >= 1000000) { // Millions
        return '${(value / 1000000).toStringAsFixed(2)}M';
      } else if (absValue >= 1000) { // Thousands
        return '${(value / 1000).toStringAsFixed(2)}K';
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

    // For extremely large values, use logarithmic scaling
    if (maxValue >= 1000000) {
      return _calculateLogarithmicSteps(maxValue, preferredSteps);
    }

    // For smaller values, use linear scaling
    return _calculateLinearSteps(maxValue, preferredSteps);
  }

  static List<double> _calculateLinearSteps(double maxValue, int preferredSteps) {
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

  static List<double> _calculateLogarithmicSteps(double maxValue, int preferredSteps) {
    // For very large values, use logarithmic scale
    final double logMax = log(maxValue) / ln10;
    final double stepLog = logMax / preferredSteps;
    final double stepValue = pow(10, stepLog).toDouble();

    // Round to nearest power of 10
    final double roundedStep = pow(10, (log(stepValue) / ln10).floor()).toDouble();

    final steps = <double>[];
    for (double value = 0; value <= maxValue * 1.1; value += roundedStep) {
      if (value == 0) {
        steps.add(0);
      } else {
        steps.add(value);
      }

      // Limit to reasonable number of steps
      if (steps.length >= preferredSteps + 2) break;
    }

    return steps;
  }

  // Determine the appropriate scale for the chart
  static String determineValueScale(double maxValue) {
    if (maxValue >= 1000000000000) return 'T'; // Trillions
    if (maxValue >= 1000000000) return 'B';    // Billions
    if (maxValue >= 1000000) return 'M';       // Millions
    if (maxValue >= 1000) return 'K';          // Thousands
    return '';                                 // No scaling
  }

  // Convert value to appropriate scale
  static double scaleValue(double value, String scale) {
    switch (scale) {
      case 'T': return value / 1000000000000;
      case 'B': return value / 1000000000;
      case 'M': return value / 1000000;
      case 'K': return value / 1000;
      default: return value;
    }
  }
}