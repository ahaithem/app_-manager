import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/product_database.dart';
import '../models/product.dart';
import '../widgets/add_product_bottom_sheet.dart';
import '../widgets/product_item.dart';

class ProductListScreen extends StatefulWidget {
  @override
  _ProductListScreenState createState() => _ProductListScreenState();
}

class _ProductListScreenState extends State<ProductListScreen> {
  TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<ProductDatabase>(context, listen: false).fetchProducts();
    });
  }

  void addNewProduct(
      String name, double sellingPrice, double purchasingPrice, int quantity) {
    Provider.of<ProductDatabase>(context, listen: false).addProduct(
      name: name,
      sellingPrice: sellingPrice,
      purchasingPrice: purchasingPrice,
      quantity: quantity,
    );
  }

  void updateProduct(int id, String newName, double newSellPrice,
      double newPurchasingPrice, int newQuantity) {
    Provider.of<ProductDatabase>(context, listen: false).updateProduct(
      id,
      name: newName,
      sellingPrice: newSellPrice,
      purchasingPrice: newPurchasingPrice,
      quantity: newQuantity,
    );
  }

  void deleteProduct(int id) {
    Provider.of<ProductDatabase>(context, listen: false).deleteProduct(id);
  }

  void _startAddNewProduct(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (_) {
        return AddProductBottomSheet(addNewProduct);
      },
    );
  }

  void _startEditProduct(BuildContext context, Product product) {
    showModalBottomSheet(
      context: context,
      builder: (_) {
        return AddProductBottomSheet(
          (name, sellPrice, purchasingPrice, quantity) {
            updateProduct(
                product.id, name, sellPrice, purchasingPrice, quantity);
          },
          product: product,
        );
      },
    );
  }

  void _showDecrementQuantityDialog(BuildContext context, Product product) {
    final _quantityController = TextEditingController();

    showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          title: Text('Decrease Quantity'),
          content: TextField(
            controller: _quantityController,
            decoration: InputDecoration(labelText: 'Quantity to Decrease'),
            keyboardType: TextInputType.number,
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(ctx).pop(),
              child: Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                final enteredQuantity = int.tryParse(_quantityController.text);
                if (enteredQuantity != null && enteredQuantity > 0) {
                  if (enteredQuantity <= product.quantity) {
                    Provider.of<ProductDatabase>(context, listen: false)
                        .decrementQuantity(product.id, enteredQuantity);
                    Navigator.of(ctx).pop();
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          'Entered quantity exceeds available quantity.',
                        ),
                      ),
                    );
                  }
                }
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }

  void _showDeleteConfirmationDialog(BuildContext context, Product product) {
    showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          title: Text('Delete Product'),
          content: Text('Are you sure you want to delete this product?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(ctx).pop(),
              child: Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                deleteProduct(product.id);
                Navigator.of(ctx).pop();
              },
              child: Text('Delete'),
            ),
          ],
        );
      },
    );
  }

  void _filterProducts() {
    setState(() {
      _searchQuery = _searchController.text.toLowerCase();
    });
  }

  void _resetTotalSales(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          title: Text('Reset Total Sales'),
          content: Text('Are you sure you want to reset the total sales to 0?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(ctx).pop(),
              child: Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                Provider.of<ProductDatabase>(context, listen: false)
                    .resetTotalSales();
                Navigator.of(ctx).pop();
              },
              child: Text('Reset'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final productDatabase = Provider.of<ProductDatabase>(context);
    final products = productDatabase.currentProducts.where((product) {
      return product.name.toLowerCase().contains(_searchQuery);
    }).toList();
    final totalSales = productDatabase.getTotalSales();

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Store Manager',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.blue,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: LayoutBuilder(
              builder: (context, constraints) {
                bool isPhone = constraints.maxWidth < 600;
                return Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(isPhone ? 8 : 16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        spreadRadius: 3,
                        blurRadius: 7,
                        offset: Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Padding(
                    padding: EdgeInsets.all(isPhone ? 8 : 16),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Total Sales: ${totalSales.toStringAsFixed(2)} DA',
                              style: TextStyle(
                                fontSize: isPhone ? 16 : 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.red,
                                foregroundColor: Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.circular(isPhone ? 8 : 16),
                                ),
                              ),
                              onPressed: () => _resetTotalSales(context),
                              child: Text(
                                'Reset',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: isPhone ? 8 : 16),
                        TextField(
                          controller: _searchController,
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: Colors.grey[200],
                            hintText: 'Search product by name...',
                            border: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.circular(isPhone ? 8 : 16),
                              borderSide: BorderSide.none,
                            ),
                            prefixIcon: Icon(Icons.search),
                          ),
                          style: TextStyle(fontSize: isPhone ? 14 : 18),
                          onChanged: (value) => _filterProducts(),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          Expanded(
            child: LayoutBuilder(
              builder: (context, constraints) {
                if (constraints.maxWidth < 600) {
                  // Use ListView for phone screens
                  return ListView.builder(
                    itemCount: products.length,
                    itemBuilder: (context, index) {
                      final product = products[index];
                      return ProductItem(
                        product: product,
                        editProduct: _startEditProduct,
                        decrementQuantity: _showDecrementQuantityDialog,
                        deleteProduct: _showDeleteConfirmationDialog,
                      );
                    },
                  );
                } else {
                  // Use GridView for tablets and larger screens
                  return GridView.builder(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      childAspectRatio: 1 / 0.5,
                      crossAxisSpacing: 10,
                      mainAxisSpacing: 10,
                    ),
                    itemCount: products.length,
                    itemBuilder: (context, index) {
                      final product = products[index];
                      return ProductItem(
                        product: product,
                        editProduct: _startEditProduct,
                        decrementQuantity: _showDecrementQuantityDialog,
                        deleteProduct: _showDeleteConfirmationDialog,
                      );
                    },
                  );
                }
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _startAddNewProduct(context),
        child: Icon(Icons.add),
        tooltip: 'Add Product',
        backgroundColor: Colors.blue,
      ),
    );
  }
}
