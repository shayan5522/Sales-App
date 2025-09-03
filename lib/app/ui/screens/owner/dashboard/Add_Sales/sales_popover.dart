import 'package:flutter/material.dart';
import '../../../../../themes/colors.dart';
import '../../../../widgets/appbar.dart';
import '../../../../widgets/buttons.dart';
import '../../../../widgets/transactionlist.dart';

class SalesPopover extends StatefulWidget {
  final List<Map<String, dynamic>> cart;
  final Map<String, dynamic> product;
  final Function(Map<String, dynamic> newProduct) onAddProduct;
  final Future<void> Function() onSaveSale;

  const SalesPopover({
    super.key,
    required this.cart,
    required this.product,
    required this.onAddProduct,
    required this.onSaveSale,
  });

  @override
  State<SalesPopover> createState() => _SalesPopoverState();
}

class _SalesPopoverState extends State<SalesPopover> {
  int quantity = 1;
  final TextEditingController _priceController = TextEditingController();
  double originalPrice = 0.0;
  final BlueThermalPrinter bluetooth = BlueThermalPrinter.instance;

  @override
  void initState() {
    super.initState();
    originalPrice = widget.product['price'].toDouble();
    _priceController.text = originalPrice.toStringAsFixed(2);
  }

  @override
  void dispose() {
    _priceController.dispose();
    super.dispose();
  }

  /// ✅ Print receipt with auto-connect
  Future<void> _printReceipt() async {
    try {
      bool? isConnected = await bluetooth.isConnected;

      if (isConnected == null || !isConnected) {
        List<BluetoothDevice> devices = await bluetooth.getBondedDevices();
        if (devices.isNotEmpty) {
          await bluetooth.connect(devices.first);
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("No paired printer found")),
          );
          return;
        }
      }

      double currentPrice = double.tryParse(_priceController.text) ?? originalPrice;
      int currentProductTotal = (quantity * currentPrice).toInt();
      int cartTotal = widget.cart.fold<int>(
        0,
            (sum, item) => (sum + (item['price'] * (item['quantity'] ?? 1))).toInt(),
      );
      int grandTotal = cartTotal + currentProductTotal;

      bluetooth.printNewLine();
      bluetooth.printCustom("SALES RECEIPT", 3, 1);
      bluetooth.printNewLine();

      for (var item in widget.cart) {
        bluetooth.printLeftRight(
          "${item['title']} x${item['quantity']}",
          "₹${(item['price'] * item['quantity']).toStringAsFixed(2)}",
          1,
        );
      }

      bluetooth.printLeftRight(
        "${widget.product['title']} x$quantity",
        "₹${(currentPrice * quantity).toStringAsFixed(2)}",
        1,
      );
      bluetooth.printNewLine();

      bluetooth.printLeftRight("Subtotal:", "₹$cartTotal", 1);
      bluetooth.printLeftRight("Current:", "₹$currentProductTotal", 1);
      bluetooth.printLeftRight("GRAND TOTAL:", "₹$grandTotal", 2);

      bluetooth.printNewLine();
      bluetooth.printCustom("Thank you for shopping!", 1, 1);
      bluetooth.printNewLine();
      bluetooth.paperCut();

    } catch (e) {
      debugPrint("❌ Print Error: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed to print: $e")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    double currentPrice = double.tryParse(_priceController.text) ?? originalPrice;
    int currentProductTotal = (quantity * currentPrice).toInt();
    int cartTotal = widget.cart.fold<int>(
      0,
          (sum, item) => (sum + (item['price'] * (item['quantity'] ?? 1))).toInt(),
    );
    int grandTotal = cartTotal + currentProductTotal;

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Stack(
        children: [
          SingleChildScrollView(
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

                // Existing cart items
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
                          Expanded(
                            child: Text(
                              item['title'],
                              style: const TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Text('x${item['quantity']}'),
                          const SizedBox(width: 10),
                          Text(
                            '₹${(item['price'] * item['quantity']).toStringAsFixed(2)}',
                          ),
                        ],
                      ),
                    ),
                  ),

                // Current product input
                Container(
                  margin: const EdgeInsets.symmetric(vertical: 6),
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    border: Border.all(color: AppColors.primary),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Image.asset(widget.product['imagePath'], width: 40, height: 40),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              widget.product['title'],
                              style: const TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          Expanded(
                            child: TextFormField(
                              controller: _priceController,
                              keyboardType: TextInputType.number,
                              decoration: InputDecoration(
                                labelText: 'Price',
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                prefixText: '₹',
                              ),
                              onChanged: (value) => setState(() {}),
                            ),
                          ),
                          const SizedBox(width: 10),
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
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Original: ₹${originalPrice.toStringAsFixed(2)}',
                            style: TextStyle(color: Colors.grey[600], fontSize: 12),
                          ),
                          Text(
                            'Total: ₹${(currentPrice * quantity).toStringAsFixed(2)}',
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 18),

                TransactionTextRow(product: 'Total Amount', amount: grandTotal.toDouble()),
                const SizedBox(height: 16),

                Align(
                  alignment: Alignment.centerRight,
                  child: Text(
                    'Grand Total: ₹${grandTotal.toStringAsFixed(2)}',
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                  ),
                ),
                const SizedBox(height: 16),

                // Buttons
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.4,
                      height: 56,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                        ),
                        onPressed: () {
                          widget.onAddProduct({
                            ...widget.product,
                            'quantity': quantity,
                            'price': currentPrice,
                            'originalPrice': originalPrice,
                          });
                          Navigator.pop(context);
                        },
                        child: const Text('Add Product', style: TextStyle(color: Colors.white, fontSize: 16)),
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
                            'price': currentPrice,
                            'originalPrice': originalPrice,
                          });
                          await widget.onSaveSale();
                        },
                        borderRadius: 8.0,
                        heightFactor: 0.07,
                      ),
                    ),
                    const SizedBox(width: 16),
                    ElevatedButton.icon(
                      onPressed: _printReceipt,
                      icon: const Icon(Icons.print, color: Colors.white),
                      label: const Text("Print"),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 18),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Close icon
          Positioned(
            right: 0,
            top: 3,
            child: IconButton(
              icon: const Icon(Icons.close, color: Colors.red, size: 30),
              onPressed: () => Navigator.pop(context),
            ),
          ),
        ],
      ),
    );
  }
}
