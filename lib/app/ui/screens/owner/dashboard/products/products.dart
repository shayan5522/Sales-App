import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shoporbit/app/themes/colors.dart';
import 'package:shoporbit/app/ui/screens/owner/dashboard/products/productController.dart';
import 'package:shoporbit/app/ui/widgets/appbar.dart';
import 'package:shoporbit/app/ui/widgets/buttons.dart';
import 'package:shoporbit/app/ui/widgets/grid_container.dart';

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
    var isLoading = false.obs;

    await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) {
        return Obx(() => Dialog(
          insetPadding:
          const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
          backgroundColor: AppColors.backgroundColor,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20)),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Form(
              key: formKey,
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        color: AppColors.primary,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: const CustomAppbar(
                        title: 'Add New Product',
                        backgroundColor: Colors.transparent,
                      ),
                    ),
                    const SizedBox(height: 12),
                    // Image Picker
                    GestureDetector(
                      onTap: isLoading.value
                          ? null
                          : () async {
                        final picked = await ImagePicker().pickImage(
                          source: ImageSource.gallery,
                        );
                        if (picked != null) {
                          imageFile = File(picked.path);
                          (context as Element).markNeedsBuild();
                        }
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black12,
                              blurRadius: 8,
                              spreadRadius: 2,
                              offset: Offset(0, 4),
                            )
                          ],
                        ),
                        child: CircleAvatar(
                          radius: 45,
                          backgroundColor: Colors.blue,
                          // backgroundImage: imageFile != null
                          //     ? FileImage(imageFile!)
                          //     : const AssetImage(
                          //     'assets/images/products.png')
                          // as ImageProvider,
                          child: imageFile == null
                              ? Icon(Icons.camera_alt,
                              color: AppColors.secondary, size: 28)
                              : null,
                        ),
                      ),
                    ),

                    const SizedBox(height: 16),

                    // Product Name Field
                    TextFormField(
                      decoration: InputDecoration(
                        labelText: 'Enter Product Name',
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none,
                        ),
                      ),
                      validator: (value) => value == null || value.isEmpty
                          ? 'Required'
                          : null,
                      onSaved: (value) => title = value!,
                      enabled: !isLoading.value,
                    ),
                    const SizedBox(height: 12),

                    // Price Field
                    TextFormField(
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        labelText: 'Enter Price',
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none,
                        ),
                      ),
                      validator: (value) => value == null ||
                          double.tryParse(value) == null
                          ? 'Enter valid price'
                          : null,
                      onSaved: (value) =>
                      price = double.tryParse(value ?? '0') ?? 0.0,
                      enabled: !isLoading.value,
                    ),
                    const SizedBox(height: 20),

                    // Buttons
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: OutlinedButton(
                            onPressed: isLoading.value
                                ? null
                                : () => Navigator.pop(context),
                            style: OutlinedButton.styleFrom(
                              padding:
                              const EdgeInsets.symmetric(vertical: 12),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            child: const Text("Cancel"),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: ElevatedButton(
                            onPressed: isLoading.value
                                ? null
                                : () async {
                              if (formKey.currentState!.validate()) {
                                formKey.currentState!.save();
                                isLoading.value = true;
                                try {
                                  await controller.addProduct(
                                    title: title,
                                    price: price,
                                    imageFile: imageFile,
                                  );
                                  Navigator.pop(context);
                                } finally {
                                  isLoading.value = false;
                                }
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.primary,
                              padding:
                              const EdgeInsets.symmetric(vertical: 12),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            child: isLoading.value
                                ? const SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                valueColor:
                                AlwaysStoppedAnimation<Color>(
                                    Colors.white),
                              ),
                            )
                                : const Text("Add", style: TextStyle(color: Colors.white)),
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),
          ),
        ));
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppbar(
          title: 'Products',
        showBackButton: false,
      ),
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
              if (controller.isLoading.value) {
                return  Center(
                  child: CircularProgressIndicator(
                    color: AppColors.primary,
                  ),
                );
              }
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
                    childAspectRatio: 0.75,
                  ),
                    itemBuilder: (context, index) {
                      final product = products[index];
                      return GridCard(
                        title: product['title'],
                        imagePath: product['imagePath'],
                        price: product['price'],
                          onDelete: () {
                            showDialog(
                              context: context,
                              builder: (_) => AlertDialog(
                                backgroundColor: AppColors.backgroundColor, // Match your app background
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                                title: Row(
                                  children: const [
                                    Icon(Icons.warning_amber_rounded, color: Colors.redAccent, size: 28),
                                    SizedBox(width: 8),
                                    Text('Confirm Deletion', style: TextStyle(fontWeight: FontWeight.bold)),
                                  ],
                                ),
                                content: Text(
                                  'Are you sure you want to delete "${product['title']}"?',
                                  style: const TextStyle(color: Colors.black87, fontSize: 15),
                                ),
                                actionsPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                                actions: [
                                  OutlinedButton(
                                    style: OutlinedButton.styleFrom(
                                      side: BorderSide(color: AppColors.primary),
                                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                                    ),
                                    onPressed: () => Navigator.pop(context),
                                    child: const Text('Cancel'),
                                  ),
                                  ElevatedButton.icon(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.redAccent,
                                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                                    ),
                                    icon: const Icon(Icons.delete, size: 18, color: Colors.white),
                                    label: const Text('Delete', style: TextStyle(color: Colors.white)),
                                    onPressed: () {
                                      Navigator.pop(context);
                                      controller.deleteProduct(product['id']);
                                    },
                                  ),
                                ],
                              ),
                            );
                          }

                      );
                    }
                ),
              );
            });
          },
        ),
      ),
    );
  }
}
