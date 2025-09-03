import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shoporbit/app/themes/colors.dart';
import 'package:shoporbit/app/themes/styles.dart';
import 'package:shoporbit/app/ui/widgets/appbar.dart';
import 'low_stock_controller.dart';

class LowStockSettingsPage extends StatelessWidget {
  LowStockSettingsPage({super.key}) {
    Get.put(LowStockController());
  }

  final TextEditingController thresholdController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final LowStockController controller = Get.find<LowStockController>();

    return Scaffold(
      appBar: CustomAppbar(title: "Low Stock Settings"),
      body: SingleChildScrollView( // Added to prevent overflow
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Set Low Stock Threshold",
              style: AppTextStyles.heading.copyWith(fontSize: 18),
            ),
            const SizedBox(height: 8),
            Text(
              "Products with stock below this limit will be highlighted",
              style: AppTextStyles.subtitle.copyWith(color: Colors.grey),
            ),
            const SizedBox(height: 16),

            // Only wrap the specific parts that need reactivity with Obx
            Obx(() {
              thresholdController.text = controller.lowStockThreshold.value.toString();
              return TextFormField(
                controller: thresholdController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: "Threshold Quantity",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.save),
                    onPressed: () {
                      final value = int.tryParse(thresholdController.text);
                      if (value != null && value > 0) {
                        controller.setLowStockThreshold(value);
                        Get.snackbar(
                          "Success",
                          "Low stock threshold updated to $value",
                          backgroundColor: Colors.green,
                          colorText: Colors.white,
                        );
                      } else {
                        Get.snackbar(
                          "Error",
                          "Please enter a valid number",
                          backgroundColor: Colors.red,
                          colorText: Colors.white,
                        );
                      }
                    },
                  ),
                ),
                onChanged: (value) {
                  final numValue = int.tryParse(value);
                  if (numValue != null && numValue > 0) {
                    thresholdController.text = numValue.toString();
                  }
                },
              );
            }),

            const SizedBox(height: 16),

            // Only the text that needs to be reactive
            Obx(() => Text(
              "Current threshold: ${controller.lowStockThreshold.value}",
              style: AppTextStyles.subtitle.copyWith(
                color: AppColors.primary,
                fontWeight: FontWeight.bold,
              ),
            )),

            const SizedBox(height: 24),

            ElevatedButton(
              onPressed: () {
                Get.back();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                minimumSize: const Size(double.infinity, 50),
              ),
              child: const Text("Done", style: TextStyle(color: Colors.white)),
            ),
          ],
        ),
      ),
    );
  }
}