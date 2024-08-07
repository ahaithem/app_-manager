import 'package:flutter/material.dart';
import '../models/product.dart';

class ProductItem extends StatelessWidget {
  final Product product;
  final void Function(BuildContext, Product) editProduct;
  final void Function(BuildContext, Product) decrementQuantity;
  final void Function(BuildContext, Product) deleteProduct;

  ProductItem({
    required this.product,
    required this.editProduct,
    required this.decrementQuantity,
    required this.deleteProduct,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      elevation: 5,
      margin: EdgeInsets.symmetric(vertical: 8, horizontal: 8),
      child: Padding(
        padding: EdgeInsets.all(10),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Product Name: ${product.name}',
                style: TextStyle(
                  fontSize: 18, // Adjusted font size
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              SizedBox(height: 6), // Adjusted spacing
              Text(
                'Quantity: ${product.quantity}',
                style: TextStyle(
                  fontSize: 16, // Adjusted font size
                  color: Colors.black54,
                ),
              ),
              SizedBox(height: 4),
              Text(
                'Price of Sell: ${product.selling_price} DA',
                style: TextStyle(
                  fontSize: 16, // Adjusted font size
                  color: Colors.black54,
                ),
              ),
              SizedBox(height: 4),
              Text(
                'Price of Purchasing: ${product.purchasing_price} DA',
                style: TextStyle(
                  fontSize: 16, // Adjusted font size
                  color: Colors.black54,
                ),
              ),
              SizedBox(height: 10), // Added spacing for buttons
              product.quantity > 0
                  ? Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Flexible(
                          child: IconButton(
                            icon: Icon(Icons.edit, color: Colors.blue),
                            onPressed: () => editProduct(context, product),
                            tooltip: 'Edit Product',
                          ),
                        ),
                        Flexible(
                          child: IconButton(
                            icon: Icon(Icons.remove, color: Colors.orange),
                            onPressed: () =>
                                decrementQuantity(context, product),
                            tooltip: 'Decrement Quantity',
                          ),
                        ),
                        Flexible(
                          child: IconButton(
                            icon: Icon(Icons.delete, color: Colors.red),
                            onPressed: () => deleteProduct(context, product),
                            tooltip: 'Delete Product',
                          ),
                        ),
                      ],
                    )
                  : Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Flexible(
                          child: IconButton(
                            icon: Icon(Icons.edit, color: Colors.blue),
                            onPressed: () => editProduct(context, product),
                            tooltip: 'Edit Product',
                          ),
                        ),
                        Flexible(
                          child: IconButton(
                            icon: Icon(Icons.delete, color: Colors.red),
                            onPressed: () => deleteProduct(context, product),
                            tooltip: 'Delete Product',
                          ),
                        ),
                      ],
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
