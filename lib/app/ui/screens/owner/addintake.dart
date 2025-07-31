import 'package:flutter/material.dart';
import 'package:salesapp/app/themes/colors.dart';
import 'package:salesapp/app/ui/widgets/appbar.dart';
import 'package:salesapp/app/ui/widgets/buttons.dart';
import 'package:salesapp/app/ui/widgets/grid_container.dart';
import 'package:salesapp/app/ui/widgets/textfield.dart'; // Your custom text field

class Intake extends StatefulWidget {
  const Intake({super.key});

  @override
  State<Intake> createState() => _IntakeState();
}

class _IntakeState extends State<Intake> {
  final List<Map<String, dynamic>> products = List.generate(10, (index) {
    return {
      'title': 'Product $index',
      'imagePath': 'assets/images/products.png',
      'price': (index + 1) * 100,
    };
  });

  void _showProductPopover(BuildContext context, Map<String, dynamic> product) {
    int quantity = 1;
    double? total = product['price'].toDouble();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            void updateTotal(int newQty) {
              quantity = newQty;
              total = (quantity * product['price']) as double?;
              setState(() {});
            }

            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 25),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Product Image and Quantity Box
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Image Box
                      Container(
                        width: 100,
                        height: 100,
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey.shade400),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Image.asset(
                          product['imagePath'],
                          fit: BoxFit.cover,
                        ),
                      ),
                      const SizedBox(width: 20),
                      // Quantity Controls
                      Column(
                        children: [
                          IconButton(
                            icon: const Icon(
                              Icons.add_circle,
                              color: AppColors.primary,
                            ),
                            onPressed: () => updateTotal(quantity + 1),
                          ),
                          Text(
                            '$quantity',
                            style: const TextStyle(fontSize: 18),
                          ),
                          IconButton(
                            icon: const Icon(
                              Icons.remove_circle,
                              color: AppColors.primary,
                            ),
                            onPressed: () {
                              if (quantity > 1) updateTotal(quantity - 1);
                            },
                          ),
                        ],
                      ),
                    ],
                  ),

                  const SizedBox(height: 20),

                  // Total Amount using custom text field
                  CustomTextField(labelText: 'Total Amount'),

                  const SizedBox(height: 16),

                  // Add product button
                  Align(
                    alignment: Alignment.centerLeft,
                    child: SecondaryButton(
                      text: "Add Product",
                      onPressed: () {
                        // Optional: Logic to add new product field below
                      },
                    ),
                  ),

                  const SizedBox(height: 16),

                  // Save and Cancel Buttons
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      SecondaryButton(
                        text: 'Cancel',
                        onPressed: () => Navigator.pop(context),
                        widthFactor: 0.35,
                      ),
                      PrimaryButton(
                        text: 'Save',
                        onPressed: () {
                          // Save logic here
                          Navigator.pop(context);
                        },
                        widthFactor: 0.35,
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppbar(title: 'Products'),
      backgroundColor: AppColors.backgroundColor,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final double screenWidth = constraints.maxWidth;
            final int crossAxisCount = screenWidth ~/ 160;

            return SingleChildScrollView(
              padding: const EdgeInsets.all(12),
              child: GridView.builder(
                itemCount: products.length,
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: crossAxisCount.clamp(1, 6),
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                  childAspectRatio: 0.9,
                ),
                itemBuilder: (context, index) {
                  final product = products[index];
                  return GestureDetector(
                    onTap: () => _showProductPopover(context, product),
                    child: GridCard(
                      title: product['title'],
                      imagePath: product['imagePath'],
                      price: product['price'],
                    ),
                  );
                },
              ),
            );
          },
        ),
      ),
    );
  }
}
