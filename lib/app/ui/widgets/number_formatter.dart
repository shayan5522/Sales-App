import 'package:intl/intl.dart';

class NumberFormatter {
  static final _currencyFormat = NumberFormat.currency(
    locale: 'en_IN', // 🇮🇳 use Indian numbering system (Lakhs, Crores)
    symbol: '₹',
    decimalDigits: 2,
  );

  static final _decimalFormat = NumberFormat.decimalPattern('en_IN');
  static final _compactFormat = NumberFormat.compact();

  /// Format as normal currency (₹1,23,456.78)
  static String currency(num value) {
    return _currencyFormat.format(value);
  }

  /// Format as compact number (1.2K, 3.4M, 2.1B, etc.)
  static String compact(num value) {
    return _compactFormat.format(value);
  }

  /// Format as decimal with commas (1,23,456)
  static String decimal(num value) {
    return _decimalFormat.format(value);
  }
}
