import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:salesapp/app/ui/screens/owner/dashboard/Add_Sales/addSalesController.dart';
import '../../../../themes/colors.dart';
import '../../../widgets/appbar.dart';
import '../../../widgets/grid_container.dart';
import '../../owner/dashboard/intake/addintake.dart';
import '../../owner/dashboard/products/productController.dart';

class LabourAddSales extends StatefulWidget {
  const LabourAddSales({super.key});

  @override
  State<LabourAddSales> createState() => _LabourAddSalesState();
}

class _LabourAddSalesState extends State<LabourAddSales> {
  final ProductController controller = Get.put(ProductController());
  final SalesController saleController = Get.put(SalesController());
  List<Map<String, dynamic>> cart = [];
  String paymentType = 'Cash'; // Default payment type

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
        return StatefulBuilder(
          builder: (context, setState) {
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
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: DropdownButtonFormField<String>(
                        value: paymentType,
                        decoration: InputDecoration(
                          labelText: 'Payment Type',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        items: ['Cash', 'Online'].map((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                        onChanged: (newValue) {
                          setState(() {
                            paymentType = newValue!;
                          });
                        },
                      ),
                    ),
                    Expanded(
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
                          await saleController.saveSale(cartCopy, paymentType);
                          setState(() {
                            cart.clear();
                            paymentType = 'Cash'; // Reset to default
                          });
                          Navigator.pop(context);
                        },
                      ),
                    ),
                  ],
                ),
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