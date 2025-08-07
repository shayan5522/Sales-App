import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:salesapp/app/ui/screens/owner/dashboard/Add_Sales/addSalesController.dart';
import '../../../../../themes/colors.dart';
import '../../../../widgets/appbar.dart';
import '../../../../widgets/buttons.dart';
import '../../../../widgets/grid_container.dart';
import '../../../../widgets/transactionlist.dart';
import '../products/productController.dart';

class Sales extends StatefulWidget {
  const Sales({super.key});

  @override
  State<Sales> createState() => _SalesState();
}

class _SalesState extends State<Sales> {
  final ProductController controller = Get.put(ProductController());
  final SalesController saleController = Get.put(SalesController());
  List<Map<String, dynamic>> cart = [];

  @override
  void initState() {
    super.initState();
    controller.fetchProducts();
  }

  void _openIntakeDialog(Map<String, dynamic> product) {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          insetPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 32),
          child: ConstrainedBox(
            constraints: BoxConstraints(
              maxHeight: MediaQuery.of(context).size.height * 0.85,
              maxWidth: MediaQuery.of(context).size.width * 0.95,
            ),
            child: Intakepopover(
              cart: cart,
              product: product,
              onAddProduct: (newProduct) {
                setState(() {
                  final existingIndex = cart.indexWhere((item) =>
                  item['title'] == newProduct['title'] &&
                      item['price'] == newProduct['price']
                  );
                  if (existingIndex == -1) {
                    cart.add(newProduct);
                  } else {
                    cart[existingIndex]['quantity'] += newProduct['quantity'];
                  }
                });
              },
              onSaveIntake: () async {
                final cartCopy = List<Map<String, dynamic>>.from(cart);
                await saleController.saveSale(cartCopy);
                setState(() {
                  cart.clear();
                });
                Navigator.pop(context);
              },
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppbar(title: 'Add Sales'),
      backgroundColor: AppColors.backgroundColor,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final double screenWidth = constraints.maxWidth;
            final int crossAxisCount = screenWidth ~/ 160;

            return Obx(() {
              final products = controller.products;

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
                      onTap: () => _openIntakeDialog(product),
                      child: GridCard(
                        title: product['title'],
                        imagePath: product['imagePath'],
                        price: product['price'],
                      ),
                    );
                  },
                ),
              );
            });
          },
        ),
      ),
    );
  }
}

class Intakepopover extends StatefulWidget {
  final List<Map<String, dynamic>> cart;
  final Map<String, dynamic> product;
  final Function(Map<String, dynamic> newProduct) onAddProduct;
  final Future<void> Function() onSaveIntake;

  const Intakepopover({
    super.key,
    required this.cart,
    required this.product,
    required this.onAddProduct,
    required this.onSaveIntake,
  });

  @override
  State<Intakepopover> createState() => _IntakePopoverState();
}

class _IntakePopoverState extends State<Intakepopover> {
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
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              decoration: BoxDecoration(
                color: AppColors.primary,
                borderRadius: BorderRadius.circular(16),
              ),
              child: CustomAppbar(
                title: 'Add Sales',
                backgroundColor: Colors.transparent,
              ),
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
                              setState(() => quantity--);
                            }
                          },
                        ),
                        Text('$quantity', style: const TextStyle(fontSize: 16)),
                        IconButton(
                          icon: const Icon(Icons.add, size: 18),
                          onPressed: () => setState(() => quantity++),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 18),

            TransactionTextRow(product: 'Total Amount', amount: grandTotal),
            const SizedBox(height: 16),

            Align(
              alignment: Alignment.centerRight,
              child: Text(
                'Total: ₹$grandTotal',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
            ),
            const SizedBox(height: 16),

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
                    child: const Text(
                      'Add Product',
                      style: TextStyle(color: Colors.white, fontSize: 16),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 18),

            Row(
              children: [
                Expanded(
                  child: SecondaryButton(
                    text: 'Save',
                    onPressed: () async {
                      widget.onAddProduct({
                        ...widget.product,
                        'quantity': quantity,
                      });
                      await widget.onSaveIntake();
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
