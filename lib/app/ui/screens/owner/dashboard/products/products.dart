import 'dart:ffi';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:salesapp/app/themes/colors.dart';
import 'package:salesapp/app/ui/screens/owner/dashboard/products/productController.dart';
import 'package:salesapp/app/ui/widgets/appbar.dart';
import 'package:salesapp/app/ui/widgets/buttons.dart';
import 'package:salesapp/app/ui/widgets/grid_container.dart';

class ProductScreen extends StatefulWidget {
  const ProductScreen({super.key});

  @override
  State<ProductScreen> createState() => _ProductScreenState();
}

class _ProductScreenState extends State<ProductScreen> {
  final ProductController controller = Get.put(ProductController());

  @override
  void initState() {
    super.initState();
    controller.fetchProducts();
  }

  Future<void> _showAddProductDialog() async {
    final formKey = GlobalKey<FormState>();
    String title = '';
    double price = 0.0;
    File? imageFile;

    await showDialog(
      context: context,
      builder: (_) {
        return AlertDialog(
          backgroundColor: AppColors.backgroundColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: const Text('Add Product'),
          content: StatefulBuilder(
            builder: (context, setState) {
              return SingleChildScrollView(
                child: Form(
                  key: formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      GestureDetector(
                        onTap: () async {
                          final picked = await ImagePicker().pickImage(
                            source: ImageSource.gallery,
                          );
                          if (picked != null) {
                            setState(() => imageFile = File(picked.path));
                          }
                        },
                        child: CircleAvatar(
                          radius: 40,
                          backgroundImage: imageFile != null
                              ? FileImage(imageFile!)
                              : const AssetImage('assets/images/products.png')
                          as ImageProvider,
                          backgroundColor: Colors.grey[300],
                          child: imageFile == null
                              ? const Icon(
                            Icons.camera_alt,
                            color: AppColors.secondary,
                          )
                              : null,
                        ),
                      ),
                      const SizedBox(height: 12),
                      TextFormField(
                        decoration:
                        const InputDecoration(labelText: 'Product Name'),
                        validator: (value) =>
                        value == null || value.isEmpty ? 'Required' : null,
                        onSaved: (value) => title = value!,
                      ),
                      const SizedBox(height: 12),
                      TextFormField(
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(labelText: 'Price'),
                        validator: (value) =>
                        value == null || double.tryParse(value) == null
                            ? 'Enter valid price'
                            : null,
                        onSaved: (value) => price = double.tryParse(value ?? '0') ?? 0.0,
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
          actions: [
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                SecondaryButton(
                  text: "Cancel",
                  onPressed: () => Navigator.pop(context),
                  widthFactor: 0.2,
                  heightFactor: 0.045,
                ),
                const SizedBox(width: 12),
                SecondaryButton(
                  text: "Add",
                  onPressed: () async {
                    if (formKey.currentState!.validate()) {
                      formKey.currentState!.save();
                      await controller.addProduct(
                        title: title,
                        price: price,
                        imageFile: imageFile,
                      );
                      Navigator.pop(context);
                    }
                  },
                  widthFactor: 0.2,
                  heightFactor: 0.045,
                ),
              ],
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppbar(title: 'Products'),
      backgroundColor: AppColors.backgroundColor,
      floatingActionButton: SecondaryButton(
        text: "Add Product",
        onPressed: _showAddProductDialog,
        widthFactor: 0.35,
        heightFactor: 0.06,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
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
                    return GridCard(
                      title: product['title'],
                      imagePath: product['imagePath'],
                      price: product['price'],
                      onDelete: () => controller.deleteProduct(product['id']),
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
