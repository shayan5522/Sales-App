import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:salesapp/app/ui/screens/owner/dashboard/Add_Sales/addSalesController.dart';
import '../../../../../themes/colors.dart';
import '../../../../widgets/appbar.dart';
import '../../../../widgets/buttons.dart';
import '../../../../widgets/grid_container.dart';
import '../../../../widgets/transactionlist.dart';
import '../intake/addintake.dart';
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
                  item['title'] == newProduct['title']);
                  if (existingIndex == -1) {
                    cart.add(newProduct);
                  } else {
                    cart[existingIndex]['quantity'] += newProduct['quantity'];
                    cart[existingIndex]['price'] = newProduct['price'];
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
              if (controller.isLoading.value) {
                return Center(
                  child: CircularProgressIndicator(
                    color: AppColors.primary,
                  ),
                );
              }
              final products = controller.products;

              return Column(
                children: [
                  if (cart.isNotEmpty)
                    Container(
                      padding: const EdgeInsets.all(12),
                      color: Colors.grey[100],
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Items in Cart: ${cart.length}',
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          Text(
                            'Total: ₹${_calculateCartTotal()}',
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                  Expanded(
                    child: SingleChildScrollView(
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
                    ),
                  ),
                ],
              );
            });
          },
        ),
      ),
    );
  }

  double _calculateCartTotal() {
    return cart.fold(0.0, (sum, item) =>
    sum + (item['price'] * (item['quantity'] ?? 1)));
  }
}