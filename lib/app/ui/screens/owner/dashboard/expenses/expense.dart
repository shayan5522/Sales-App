import 'package:flutter/material.dart';
import 'package:salesapp/app/themes/colors.dart';
import 'package:salesapp/app/themes/styles.dart';
import 'package:salesapp/app/ui/widgets/appbar.dart';
import 'package:salesapp/app/ui/widgets/buttons.dart';
import 'package:salesapp/app/ui/widgets/textfield.dart'; // Import your custom textfield

class AddExpenseScreen extends StatefulWidget {
  const AddExpenseScreen({super.key});

  @override
  State<AddExpenseScreen> createState() => _AddExpenseScreenState();
}

class _AddExpenseScreenState extends State<AddExpenseScreen> {
  final _formKey = GlobalKey<FormState>();
  String? _selectedCategory;

  final List<String> _categories = [
    'Food',
    'Transport',
    'Shopping',
    'Bills',
    'Other',
  ];

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _descController = TextEditingController();

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
        padding: EdgeInsets.all(12.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Top image
              Center(
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: screenHeight * 0.015),
                  child: Image.asset(
                    'assets/images/laboursignin.png', // <-- Replace with your asset
                    height: screenHeight * 0.11,
                  ),
                ),
              ),
              SizedBox(height: screenHeight * 0.01),

              // Expense Name
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
                controller: _nameController,
                validator: (value) =>
                    value == null || value.isEmpty ? 'Required' : null,
              ),
              SizedBox(height: screenHeight * 0.018),

              // Amount
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
                controller: _amountController,
                keyboardType: TextInputType.number,
                validator: (value) =>
                    value == null || value.isEmpty ? 'Required' : null,
              ),
              SizedBox(height: screenHeight * 0.018),

              // Category
              Text(
                'Category *',
                style: AppTextStyles.title.copyWith(
                  fontWeight: FontWeight.w500,
                  fontSize: labelFontSize,
                ),
              ),
              SizedBox(height: screenHeight * 0.008),
              DropdownButtonFormField<String>(
                value: _selectedCategory,
                hint: Text(
                  'Select category',
                  style: TextStyle(fontSize: fieldFontSize * 0.95),
                ),
                items: _categories
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
                onChanged: (val) => setState(() => _selectedCategory = val),
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
                    borderSide: BorderSide(color: AppColors.primary, width: 2),
                  ),
                ),
                validator: (value) => value == null ? 'Required' : null,
              ),
              SizedBox(height: screenHeight * 0.018),

              // Description
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
                controller: _descController,
                maxlines: 3,
              ),
              SizedBox(height: screenHeight * 0.03),

              // Save Button (using your custom PrimaryButton)
              PrimaryButton(
                text: 'Save Expense',
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    // Save logic here
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
              SizedBox(height: screenHeight * 0.02),
            ],
          ),
        ),
      ),
    );
  }
}
