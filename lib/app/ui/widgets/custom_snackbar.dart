import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shoporbit/app/themes/snackbar_theme.dart';

class CustomSnackbar {
  static void show({
    required String title,
    required String message,
    bool isError = false,
  }) {
    Get.snackbar(
      title,
      message,
      snackPosition: SnackPosition.TOP,
      backgroundColor: isError
          ? SnackbarTheme.errorBackground
          : SnackbarTheme.successBackground,
      colorText: SnackbarTheme.textColor,
      borderRadius: 12,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      duration: const Duration(seconds: 2),
      animationDuration: const Duration(milliseconds: 300),
      icon: Icon(
        isError ? Icons.error_outline : Icons.check_circle_outline,
        color: SnackbarTheme.textColor,
      ),
    );
  }
}
