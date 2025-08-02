import 'package:flutter/material.dart';
import 'package:salesapp/app/themes/colors.dart';
import 'package:salesapp/app/themes/styles.dart';
import 'package:salesapp/app/ui/widgets/appbar.dart';
import 'package:salesapp/app/ui/widgets/buttons.dart';
import 'package:salesapp/app/ui/widgets/grid_container.dart';

class ReturnProduct extends StatefulWidget {
  const ReturnProduct({super.key});

  @override
  State<ReturnProduct> createState() => _IntakeState();
}

class _IntakeState extends State<ReturnProduct> {
  final List<Map<String, dynamic>> products = List.generate(10, (index) {
    return {
      'title': 'Product $index',
      'imagePath': 'assets/images/Apple.jpg',
      'price': (index + 1) * 100,
    };
  });

  List<Map<String, dynamic>> cart = [];

  void _showProductPopover(BuildContext context, Map<String, dynamic> product) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Returnpopover(
          cart: cart,
          product: product,
          onAddProduct: (newProduct) {
            setState(() {
              int existingIndex = cart.indexWhere(
                (item) => item['title'] == newProduct['title'],
              );
              if (existingIndex != -1) {
                cart[existingIndex]['quantity'] += newProduct['quantity'];
              } else {
                cart.add(newProduct);
              }
            });
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppbar(title: 'Return Product'),
      backgroundColor: AppColors.backgroundColor,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final double screenWidth = constraints.maxWidth;
            final int crossAxisCount = screenWidth ~/ 160;

            return SingleChildScrollView(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Return Product',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 16), // Space between text and grid
                  GridView.builder(
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
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

class Returnpopover extends StatefulWidget {
  final List<Map<String, dynamic>> cart;
  final Map<String, dynamic> product;
  final Function(Map<String, dynamic> newProduct) onAddProduct;

  const Returnpopover({
    super.key,
    required this.cart,
    required this.product,
    required this.onAddProduct,
  });

  @override
  State<Returnpopover> createState() => _IntakePopoverState();
}

class _IntakePopoverState extends State<Returnpopover> {
  int quantity = 1;

  @override
  Widget build(BuildContext context) {
    double price = widget.product['price'].toDouble();

    // Calculate totals
    int cartTotal = widget.cart.fold<int>(
      0,
      (sum, item) => (sum + (item['price'] * (item['quantity'] ?? 1))).toInt(),
    );
    int currentProductTotal = (quantity * price).toInt();
    int grandTotal = cartTotal + currentProductTotal;

    return Padding(
      padding: const EdgeInsets.all(16),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              decoration: BoxDecoration(
                color: AppColors.primary,
                borderRadius: BorderRadius.circular(
                  16,
                ), // Change 16 to your desired radius
              ),
              child: CustomAppbar(
                title: 'Return Product',
                backgroundColor:
                    Colors.transparent, // So the Container's color shows
              ),
            ),
            const SizedBox(height: 12),

            // Cart items
            if (widget.cart.isNotEmpty)
              ...widget.cart.map(
                (item) => Container(
                  margin: const EdgeInsets.symmetric(vertical: 6),
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    border: Border.all(color: AppColors.primary),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    children: [
                      Image.asset(item['imagePath'], width: 40, height: 40),
                      const SizedBox(width: 10),
                      Text(
                        item['title'],
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      const Spacer(),
                      Text('x${item['quantity']}'),
                      const SizedBox(width: 10),
                      Text(
                        'Rs. ${(item['price'] * item['quantity']).toString()}',
                      ),
                    ],
                  ),
                ),
              ),

            // Current product
            Container(
              margin: const EdgeInsets.symmetric(vertical: 6),
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                border: Border.all(color: AppColors.primary),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                children: [
                  Image.asset(
                    widget.product['imagePath'],
                    width: 40,
                    height: 40,
                  ),
                  const SizedBox(width: 10),
                  Text(
                    widget.product['title'],
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const Spacer(),
                  Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey.shade400),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      children: [
                        IconButton(
                          icon: const Icon(Icons.remove, size: 18),
                          onPressed: () {
                            if (quantity > 1) {
                              setState(() {
                                quantity--;
                              });
                            }
                          },
                        ),
                        Text('$quantity', style: const TextStyle(fontSize: 16)),
                        IconButton(
                          icon: const Icon(Icons.add, size: 18),
                          onPressed: () {
                            setState(() {
                              quantity++;
                            });
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 18),

            Align(
              alignment: Alignment.centerRight,
              child: Text(
                'Total:  ₹$grandTotal',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Add Product Button
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.4,
                  height: 56,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    onPressed: () {
                      widget.onAddProduct({
                        ...widget.product,
                        'quantity': quantity,
                      });
                      Navigator.pop(context);
                    },
                    child: Text(
                      'Add Product',
                      style: AppTextStyles.title.copyWith(
                        color: Colors.white,
                        fontSize: 14,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 18),

            // Save & Close Buttons
            Row(
              children: [
                Expanded(
                  child: SecondaryButton(
                    text: 'Save',
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    borderRadius: 8.0,
                    heightFactor: 0.07,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: SecondaryButton(
                    text: 'Close',
                    onPressed: () => Navigator.pop(context),
                    borderRadius: 8.0,
                    heightFactor: 0.07,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
