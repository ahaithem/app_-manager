import 'package:flutter/material.dart';
import '../models/product.dart';

class AddProductBottomSheet extends StatefulWidget {
  final void Function(String name, double sellingPrice, double purchasingPrice,
      int quantity) onAddProduct;
  final Product? product;

  AddProductBottomSheet(this.onAddProduct, {this.product});

  @override
  _AddProductBottomSheetState createState() => _AddProductBottomSheetState();
}

class _AddProductBottomSheetState extends State<AddProductBottomSheet> {
  final _nameController = TextEditingController();
  final _sellpriceController = TextEditingController();
  final _purchasingPriceController = TextEditingController();
  final _quantityController = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.product != null) {
      _nameController.text = widget.product!.name;
      _sellpriceController.text = widget.product!.selling_price.toString();
      _purchasingPriceController.text =
          widget.product!.purchasing_price.toString();
      _quantityController.text = widget.product!.quantity.toString();
    }
  }

  void _submit() {
    final name = _nameController.text;
    final sellingPrice = double.tryParse(_sellpriceController.text) ?? 0.0;
    final purchasingPrice =
        double.tryParse(_purchasingPriceController.text) ?? 0.0;
    final quantity = int.tryParse(_quantityController.text) ?? 0;

    if (name.isEmpty ||
        sellingPrice <= 0 ||
        purchasingPrice <= 0 ||
        quantity <= 0) {
      return;
    }

    widget.onAddProduct(name, sellingPrice, purchasingPrice, quantity);
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          TextField(
            controller: _nameController,
            decoration: InputDecoration(labelText: 'Product Name'),
          ),
          TextField(
            controller: _sellpriceController,
            decoration: InputDecoration(labelText: 'Selling Price'),
            keyboardType: TextInputType.number,
          ),
          TextField(
            controller: _purchasingPriceController,
            decoration: InputDecoration(labelText: 'Purchasing Price'),
            keyboardType: TextInputType.number,
          ),
          TextField(
            controller: _quantityController,
            decoration: InputDecoration(labelText: 'Quantity'),
            keyboardType: TextInputType.number,
          ),
          ElevatedButton(
            onPressed: _submit,
            child:
                Text(widget.product == null ? 'Add Product' : 'Update Product'),
          ),
        ],
      ),
    );
  }
}
