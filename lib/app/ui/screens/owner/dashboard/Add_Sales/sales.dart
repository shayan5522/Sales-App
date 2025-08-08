import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:salesapp/app/themes/colors.dart';
import 'package:salesapp/app/ui/widgets/appbar.dart';
import 'package:salesapp/app/ui/widgets/buttons.dart';
import 'package:salesapp/app/ui/widgets/grid_container.dart';
import 'package:salesapp/app/ui/widgets/transactionlist.dart';
import 'SalesController.dart';

class Sales extends StatefulWidget {
  const Sales({super.key});

  @override
  State<Sales> createState() => _SalesState();
}

class _SalesState extends State<Sales> {
  final List<Map<String, dynamic>> products = List.generate(10, (index) {
    return {
      'title': 'Product $index',
      'imagePath': 'assets/images/Apple.jpg',
      'price': (index + 1) * 100,
    };
  });

  final SalesController salesController = Get.put(SalesController());
  List<Map<String, dynamic>> cart = [];

  void _showProductPopover(Map<String, dynamic> product) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Salespopover(
          cart: cart,
          product: product,
          onAddProduct: (newProduct) {
            setState(() {
              int index = cart.indexWhere((item) => item['title'] == newProduct['title']);
              if (index != -1) {
                cart[index]['quantity'] += newProduct['quantity'];
              } else {
                cart.add(newProduct);
              }
            });
          },
          onSaveSale: () async {
            final cartCopy = List<Map<String, dynamic>>.from(cart);
            await salesController.saveSale(cartCopy);
            setState(() {
              cart.clear();
            });
            Navigator.pop(context);
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppbar(title: 'Add Sale'),
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
                    onTap: () => _showProductPopover(product),
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

class Salespopover extends StatefulWidget {
  final List<Map<String, dynamic>> cart;
  final Map<String, dynamic> product;
  final Function(Map<String, dynamic>) onAddProduct;
  final VoidCallback onSaveSale;

  const Salespopover({
    super.key,
    required this.cart,
    required this.product,
    required this.onAddProduct,
    required this.onSaveSale,
  });

  @override
  State<Salespopover> createState() => _SalespopoverState();
}

class _SalespopoverState extends State<Salespopover> {
  int quantity = 1;

  @override
  Widget build(BuildContext context) {
    double price = widget.product['price'].toDouble();

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
          children: [
            CustomAppbar(
              title: 'Add Sale',
              backgroundColor: Colors.transparent,
            ),
            const SizedBox(height: 12),
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
                      Text(item['title'], style: const TextStyle(fontWeight: FontWeight.bold)),
                      const Spacer(),
                      Text('x${item['quantity']}'),
                      const SizedBox(width: 10),
                      Text('Rs. ${(item['price'] * item['quantity']).toString()}'),
                    ],
                  ),
                ),
              ),
            Container(
              margin: const EdgeInsets.symmetric(vertical: 6),
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                border: Border.all(color: AppColors.primary),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                children: [
                  Image.asset(widget.product['imagePath'], width: 40, height: 40),
                  const SizedBox(width: 10),
                  Text(widget.product['title'], style: const TextStyle(fontWeight: FontWeight.bold)),
                  const Spacer(),
                  Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.remove, size: 18),
                        onPressed: () {
                          if (quantity > 1) setState(() => quantity--);
                        },
                      ),
                      Text('$quantity', style: const TextStyle(fontSize: 16)),
                      IconButton(
                        icon: const Icon(Icons.add, size: 18),
                        onPressed: () => setState(() => quantity++),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 18),
            TransactionTextRow(product: 'Total Amount', amount: grandTotal),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: SecondaryButton(
                    text: 'Save',
                    onPressed: widget.onSaveSale,
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
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: () {
                widget.onAddProduct({
                  ...widget.product,
                  'quantity': quantity,
                });
                Navigator.pop(context);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                minimumSize: Size(MediaQuery.of(context).size.width * 0.4, 50),
              ),
              child: const Text("Add Product", style: TextStyle(color: Colors.white)),
            ),
          ],
        ),
      ),
    );
  }
}
