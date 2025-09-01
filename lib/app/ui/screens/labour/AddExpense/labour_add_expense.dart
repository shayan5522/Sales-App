import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shoporbit/app/themes/colors.dart';
import 'package:shoporbit/app/themes/styles.dart';
import 'package:shoporbit/app/ui/widgets/appbar.dart';
import 'package:shoporbit/app/ui/widgets/buttons.dart';
import 'package:shoporbit/app/ui/widgets/textfield.dart';
import '../../owner/dashboard/expenses/expenseController.dart';

class LabourAddExpenseScreen extends StatefulWidget {
  const LabourAddExpenseScreen({super.key});

  @override
  State<LabourAddExpenseScreen> createState() => _LabourAddExpenseScreenState();
}

class _LabourAddExpenseScreenState extends State<LabourAddExpenseScreen> {
  final _formKey = GlobalKey<FormState>();
  final ExpenseController controller = Get.put(ExpenseController());

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final fieldFontSize = screenWidth * 0.045;
    final labelFontSize = screenWidth * 0.048;

    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(screenHeight * 0.08),
        child: CustomAppbar(
          title: 'Add Expense',
          backgroundColor: AppColors.primary,
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(12.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: screenHeight * 0.015),
                  child: Image.asset(
                    'assets/images/laboursignin.png',
                    height: screenHeight * 0.11,
                  ),
                ),
              ),
              SizedBox(height: screenHeight * 0.01),

              Text(
                'Expense Name *',
                style: AppTextStyles.title.copyWith(
                  fontWeight: FontWeight.w500,
                  fontSize: labelFontSize,
                ),
              ),
              SizedBox(height: screenHeight * 0.008),
              CustomTextField(
                hintText: 'Expense title',
                controller: controller.nameController,
                validator: (value) =>
                value == null || value.isEmpty ? 'Required' : null,
              ),
              SizedBox(height: screenHeight * 0.018),

              Text(
                'Amount *',
                style: AppTextStyles.title.copyWith(
                  fontWeight: FontWeight.w500,
                  fontSize: labelFontSize,
                ),
              ),
              SizedBox(height: screenHeight * 0.008),
              CustomTextField(
                hintText: 'Enter Amount',
                controller: controller.amountController,
                keyboardType: TextInputType.number,
                validator: (value) =>
                value == null || value.isEmpty ? 'Required' : null,
              ),
              SizedBox(height: screenHeight * 0.018),

              Text(
                'Category *',
                style: AppTextStyles.title.copyWith(
                  fontWeight: FontWeight.w500,
                  fontSize: labelFontSize,
                ),
              ),
              SizedBox(height: screenHeight * 0.008),
              Obx(() => DropdownButtonFormField<String>(
                value: controller.selectedCategory.value,
                hint: Text(
                  'Select category',
                  style: TextStyle(fontSize: fieldFontSize * 0.95),
                ),
                items: controller.categoryList
                    .map(
                      (cat) => DropdownMenuItem(
                    value: cat,
                    child: Text(
                      cat,
                      style: TextStyle(fontSize: fieldFontSize),
                    ),
                  ),
                )
                    .toList(),
                onChanged: (val) =>
                controller.selectedCategory.value = val,
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: screenWidth * 0.04,
                    vertical: screenHeight * 0.018,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(color: AppColors.primary),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(color: AppColors.primary),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide:
                    BorderSide(color: AppColors.primary, width: 2),
                  ),
                ),
                validator: (value) => value == null ? 'Required' : null,
              )),
              SizedBox(height: screenHeight * 0.018),

              Text(
                'Description',
                style: AppTextStyles.title.copyWith(
                  fontWeight: FontWeight.w500,
                  fontSize: labelFontSize,
                ),
              ),
              SizedBox(height: screenHeight * 0.008),
              CustomTextField(
                hintText: 'Enter description...',
                controller: controller.descController,
                maxlines: 3,
              ),
              SizedBox(height: screenHeight * 0.03),

              Obx(() => PrimaryButton(
                text: controller.isLoading.value ? 'Saving...' : 'Save Expense',
                onPressed: () {
                  if (controller.isLoading.value) return;

                  if (_formKey.currentState!.validate()) {
                    controller.saveExpense();
                  }
                },
                widthFactor: 1.0,
                heightFactor: 0.065,
                borderRadius: 10,
                textStyle: AppTextStyles.title.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: fieldFontSize * 1.1,
                ),
              ),
              ),
              SizedBox(height: screenHeight * 0.02),
            ],
          ),
        ),
      ),
    );
  }
}
