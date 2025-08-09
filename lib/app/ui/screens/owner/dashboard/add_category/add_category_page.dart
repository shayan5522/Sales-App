import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:salesapp/app/themes/colors.dart';
import 'package:salesapp/app/ui/widgets/appbar.dart';
import 'package:salesapp/app/ui/widgets/textfield.dart';
import 'package:salesapp/app/ui/widgets/buttons.dart';

import 'categoryController.dart'; // path may vary

class AddCategoryPage extends StatelessWidget {
  AddCategoryPage({super.key});
  final AddCategoryController controller = Get.put(AddCategoryController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppbar(title: "Add Expense Category"),
      backgroundColor: const Color(0xFFEFEFF1),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            /// 🔹 Category Illustration
            Center(
              child: Image.asset(
                "assets/images/add_category.png",
                width: 200,
                height: 200,
                fit: BoxFit.contain,
              ),
            ),
            const SizedBox(height: 20),

            /// 🔹 Category Text Field
            CustomTextField(
              hintText: "Enter Category name",
              controller: controller.categoryNameController,
              borderColor: AppColors.primary,
              fillColor: Colors.white,
            ),
            const SizedBox(height: 24),

            /// 🔹 Save Button
            Obx(() {
              return PrimaryButton(
                text: controller.isLoading.value ? "Saving..." : "Save",
                onPressed: () => controller.isLoading.value
                    ? null
                    : controller.saveCategory(),
              );
            }),
          ],
        ),
      ),
    );
  }
}
