import 'package:flutter/material.dart';
import 'package:isar/isar.dart';
import '../models/product.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProductDatabase extends ChangeNotifier {
  static late Isar isar;
  double totalSales = 0.0;

  static Future<ProductDatabase> initialize() async {
    final dir = await getApplicationDocumentsDirectory();
    isar = await Isar.open([ProductSchema], directory: dir.path);

    final database = ProductDatabase();
    await database._loadTotalSales(); // Load total sales using instance method
    return database;
  }

  final List<Product> currentProducts = [];

  Future<void> addProduct({
    required String name,
    required double sellingPrice,
    required double purchasingPrice,
    required int quantity,
  }) async {
    final newProduct = Product()
      ..name = name
      ..selling_price = sellingPrice
      ..purchasing_price = purchasingPrice
      ..quantity = quantity;

    await isar.writeTxn(() => isar.products.put(newProduct));
    fetchProducts();
  }

  Future<void> fetchProducts() async {
    final products = await isar.products.where().findAll();
    currentProducts.clear();
    currentProducts.addAll(products);
    notifyListeners();
  }

  Future<void> updateProduct(
    int id, {
    required String name,
    required double sellingPrice,
    required double purchasingPrice,
    required int quantity,
  }) async {
    final existingProduct = await isar.products.get(id);
    if (existingProduct != null) {
      existingProduct
        ..name = name
        ..selling_price = sellingPrice
        ..purchasing_price = purchasingPrice
        ..quantity = quantity;

      await isar.writeTxn(() => isar.products.put(existingProduct));
      fetchProducts();
    }
  }

  Future<void> decrementQuantity(int id, int quantityToDecrease) async {
    final existingProduct = await isar.products.get(id);
    if (existingProduct != null &&
        existingProduct.quantity >= quantityToDecrease) {
      existingProduct.quantity -= quantityToDecrease;
      totalSales += existingProduct.selling_price * quantityToDecrease;

      await isar.writeTxn(() => isar.products.put(existingProduct));
      await _saveTotalSales(); // Save total sales using instance method
      fetchProducts();
    } else {
      throw Exception("Quantity to decrease exceeds available quantity.");
    }
  }

  Future<void> deleteProduct(int id) async {
    await isar.writeTxn(() => isar.products.delete(id));
    fetchProducts();
  }

  double getTotalSales() {
    return totalSales;
  }

  // Save total sales to SharedPreferences
  Future<void> _saveTotalSales() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble('totalSales', totalSales);
    print('Saved totalSales: $totalSales'); // Debug print
  }

  // Load total sales from SharedPreferences
  Future<void> _loadTotalSales() async {
    final prefs = await SharedPreferences.getInstance();
    totalSales = prefs.getDouble('totalSales') ?? 0.0;
    print('Loaded totalSales: $totalSales'); // Debug print
  }

  // ... The new method that I add

  Future<void> resetTotalSales() async {
    totalSales = 0.0;
    await _saveTotalSales();
    notifyListeners();
  }
}
