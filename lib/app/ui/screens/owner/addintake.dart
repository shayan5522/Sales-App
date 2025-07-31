import 'package:flutter/material.dart';
import 'package:salesapp/app/themes/colors.dart';
import 'package:salesapp/app/ui/widgets/appbar.dart';
import 'package:salesapp/app/ui/widgets/grid_container.dart';
import 'package:salesapp/app/ui/widgets/buttons.dart';

class IntakeScreen extends StatefulWidget {
  const IntakeScreen({super.key});

  @override
  State<IntakeScreen> createState() => _IntakeScreenState();
}

class _IntakeScreenState extends State<IntakeScreen> {
  final List<Map<String, dynamic>> products = List.generate(10, (index) {
    return {
      'title': 'Product $index',
      'imagePath': 'assets/images/products.png',
      'price': (index + 1) * 100,
    };
  });

  void _showProductSheet(BuildContext context, Map<String, dynamic> product) {
    int quantity = 1;
    double? totalAmount = product['price'].toDouble();

    void updateAmount(int qty) {
      setState(() {
        quantity = qty;
        totalAmount = (qty * product['price']) as double?;
      });
    }

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.backgroundColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey.shade300),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Column(
                        children: [
                          Image.asset(product['imagePath'], height: 100),
                          const SizedBox(height: 10),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              IconButton(
                                icon: const Icon(Icons.remove_circle_outline),
                                onPressed: () {
                                  if (quantity > 1) {
                                    setState(() {
                                      updateAmount(quantity - 1);
                                    });
                                  }
                                },
                              ),
                              Text(
                                '$quantity',
                                style: const TextStyle(fontSize: 18),
                              ),
                              IconButton(
                                icon: const Icon(Icons.add_circle_outline),
                                onPressed: () {
                                  setState(() {
                                    updateAmount(quantity + 1);
                                  });
                                },
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              vertical: 10,
                              horizontal: 20,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Text(
                                  'Total Amount: ',
                                  style: TextStyle(fontSize: 16),
                                ),
                                Text(
                                  'Rs. $totalAmount',
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                    SecondaryButton(
                      text: 'Add Product',
                      onPressed: () {
                        // Reopen same bottom sheet with a new product
                        Navigator.pop(context);
                        _showProductPicker(context);
                      },
                      widthFactor: 0.6,
                      heightFactor: 0.05,
                    ),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        SecondaryButton(
                          text: 'Close',
                          onPressed: () => Navigator.pop(context),
                          widthFactor: 0.35,
                          heightFactor: 0.05,
                        ),
                        SecondaryButton(
                          text: 'Save',
                          onPressed: () {
                            // Save logic
                            Navigator.pop(context);
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  '${product['title']} x$quantity saved with Rs. $totalAmount',
                                ),
                              ),
                            );
                          },
                          widthFactor: 0.35,
                          heightFactor: 0.05,
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  void _showProductPicker(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.backgroundColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(12),
          child: Wrap(
            children: products.map((product) {
              return ListTile(
                leading: Image.asset(product['imagePath'], height: 40),
                title: Text(product['title']),
                subtitle: Text('Rs. ${product['price']}'),
                onTap: () {
                  Navigator.pop(context);
                  _showProductSheet(context, product);
                },
              );
            }).toList(),
          ),
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
                    onTap: () => _showProductSheet(context, product),
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
