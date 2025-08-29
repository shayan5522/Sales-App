import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:salesapp/app/themes/colors.dart';
import 'package:salesapp/app/themes/styles.dart';
import 'package:salesapp/app/ui/screens/owner/dashboard/credit_amount%20_due/transactionController.dart';
import 'package:salesapp/app/ui/widgets/appbar.dart';
import 'package:salesapp/app/ui/widgets/buttons.dart';
import 'package:salesapp/app/ui/widgets/custom_snackbar.dart';
import 'package:salesapp/app/ui/widgets/datepicker.dart';
import 'package:salesapp/app/ui/widgets/textfield.dart';

class AmountCreditScreen extends StatefulWidget {
   const AmountCreditScreen({super.key});



  @override
  State<AmountCreditScreen> createState() => _AmountCreditDueScreenState();
}

class _AmountCreditDueScreenState extends State<AmountCreditScreen> {
  final TransactionController _transactionController = Get.put(TransactionController());
  bool isSaving = false;
  bool isCredited = true;
  DateTime? selectedDate = DateTime.now();

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _detailController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final fieldFontSize = screenWidth * 0.045;
    final labelFontSize = screenWidth * 0.048;

    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: CustomAppbar(
        title: 'Amount Credit and Due',
        backgroundColor: AppColors.primary,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(
          horizontal: screenWidth * 0.06,
          vertical: screenHeight * 0.03,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Toggle Buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: () => setState(() => isCredited = true),
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        vertical: screenHeight * 0.018,
                      ),
                      decoration: BoxDecoration(
                        color: isCredited ? AppColors.primary : Colors.white,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: AppColors.primary),
                      ),
                      child: Center(
                        child: Text(
                          'Credited Amount',
                          style: AppTextStyles.title.copyWith(
                            color: isCredited
                                ? Colors.white
                                : AppColors.primary,
                            fontWeight: FontWeight.bold,
                            fontSize: screenWidth * 0.042,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(width: screenWidth * 0.04),
                Expanded(
                  child: GestureDetector(
                    onTap: () => setState(() => isCredited = false),
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        vertical: screenHeight * 0.018,
                      ),
                      decoration: BoxDecoration(
                        color: !isCredited ? AppColors.primary : Colors.white,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: AppColors.primary),
                      ),
                      child: Center(
                        child: Text(
                          'Amount Due',
                          style: AppTextStyles.title.copyWith(
                            color: !isCredited
                                ? Colors.white
                                : AppColors.primary,
                            fontWeight: FontWeight.bold,
                            fontSize: screenWidth * 0.042,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: screenHeight * 0.03),

            // Name
            Text(
              'Name',
              style: AppTextStyles.title.copyWith(
                fontWeight: FontWeight.w500,
                fontSize: labelFontSize,
              ),
            ),
            SizedBox(height: screenHeight * 0.008),
            CustomTextField(
              hintText: 'Enter Name',
              controller: _nameController,
            ),
            SizedBox(height: screenHeight * 0.018),

            // Detail
            Text(
              'Detail',
              style: AppTextStyles.title.copyWith(
                fontWeight: FontWeight.w500,
                fontSize: labelFontSize,
              ),
            ),
            SizedBox(height: screenHeight * 0.008),
            CustomTextField(
              hintText: 'Enter Detail...',
              controller: _detailController,
              maxlines: 2,
            ),
            SizedBox(height: screenHeight * 0.018),

            // Date and Price Row
            // First line: Enter Date label + Date Picker
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Label on the left
                SizedBox(
                  width: screenWidth * 0.28, // Adjust width as needed
                  child: Align(
                    alignment: Alignment.topLeft,
                    child: Text(
                      'Enter Date',
                      style: AppTextStyles.title.copyWith(
                        fontWeight: FontWeight.w500,
                        fontSize: labelFontSize,
                      ),
                    ),
                  ),
                ),
                // Date picker on the right
                Expanded(
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: CustomDatePicker(
                      label: '',
                      initialDate: selectedDate,
                      onDateSelected: (date) =>
                          setState(() => selectedDate = date),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: screenHeight * 0.038),

            // Second line: Enter Price label + Price TextField
            Row(
              children: [
                Text(
                  'Enter Price',
                  style: AppTextStyles.title.copyWith(
                    fontWeight: FontWeight.w500,
                    fontSize: labelFontSize,
                  ),
                ),
                SizedBox(width: screenWidth * 0.04),
                Expanded(
                  child: CustomTextField(
                    hintText: 'Enter Price',
                    controller: _priceController,
                    keyboardType: TextInputType.number,
                  ),
                ),
              ],
            ),

            SizedBox(height: screenHeight * 0.04),

            // Save Button
            PrimaryButton(
              text: 'Save',
              onPressed: () {
                final name = _nameController.text.trim();
                final detail = _detailController.text.trim();
                final price = double.tryParse(_priceController.text.trim()) ?? 0.0;
                final date = selectedDate ?? DateTime.now();

                if (name.isEmpty || detail.isEmpty || price <= 0) {
                  CustomSnackbar.show(
                    title: 'Error',
                    message: 'Please fill all fields correctly.',
                    isError: true,
                  );
                  // Get.snackbar('Error', 'Please fill all fields correctly.');
                  return;
                }

                _transactionController.addTransaction(
                  name: name,
                  detail: detail,
                  price: price,
                  date: date,
                  isCredit: isCredited,
                );

                // Optional: Clear fields after saving
                _nameController.clear();
                _detailController.clear();
                _priceController.clear();
                setState(() {
                  selectedDate = DateTime.now();
                  isCredited = true;
                });
              },

              widthFactor: 1.0,
              heightFactor: 0.065,
              borderRadius: 8,
              textStyle: AppTextStyles.title.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: fieldFontSize * 1.1,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
