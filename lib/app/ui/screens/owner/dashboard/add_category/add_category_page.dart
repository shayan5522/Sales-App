import 'package:flutter/material.dart';
import 'package:salesapp/app/themes/colors.dart';
import 'package:salesapp/app/ui/widgets/appbar.dart';
import 'package:salesapp/app/ui/widgets/textfield.dart';
import 'package:salesapp/app/ui/widgets/buttons.dart';
class AddCategoryPage extends StatelessWidget {
  AddCategoryPage({super.key});
  final TextEditingController _categoryController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppbar(title: "Add Category"),
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
              controller: _categoryController,
              borderColor: AppColors.primary,
              fillColor: Colors.white,
            ),
            const SizedBox(height: 24),

            /// 🔹 Save Button
            PrimaryButton(
              text: "Save",
              onPressed: () {
                final name = _categoryController.text.trim();
                if (name.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Please enter category name")),
                  );
                  return;
                }

                // 🔽 TODO: Save logic
                debugPrint("Saving category: $name");

                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text("Category '$name' saved")),
                );

                _categoryController.clear();
              },
            ),
          ],
        ),
      ),
    );
  }
}
