import 'package:flutter/material.dart';

import '../models/product.dart';
import '../services/product_api.dart';

class ProductController extends ChangeNotifier {
  List<Product> products = [];
  bool isLoading = false;

  Future<void> loadProducts() async {
    isLoading = true;
    notifyListeners();

    try {
      products = await ProductApi.fetchProducts();
    } catch (e) {
      debugPrint('Error loading products: $e');
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> addProduct(Product product) async {
    try {
      final newProduct = await ProductApi.createProduct(product);
      products.add(newProduct);
      notifyListeners();
      return true;
    } catch (e) {
      debugPrint('Error adding product: $e');
      return false;
    }
  }
}
