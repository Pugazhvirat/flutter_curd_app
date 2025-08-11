import 'dart:convert';

import 'package:http/http.dart' as http;

import '../models/product.dart';

class ProductApi {
  static const String baseUrl = 'http://192.168.1.40:3000/api/products';

  // Fetch all products
  static Future<List<Product>> fetchProducts() async {
    final response = await http.get(Uri.parse(baseUrl));
    if (response.statusCode == 200) {
      final List<dynamic> jsonList = jsonDecode(response.body);
      return jsonList.map((json) => Product.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load products: ${response.statusCode}');
    }
  }

  // Fetch products by category
  static Future<List<Product>> fetchProductsByCategory(String category) async {
    final url = Uri.parse('$baseUrl/category/$category');
    final response = await http.get(url);

    print('Fetch by category status: ${response.statusCode}');
    print('Fetch by category body: ${response.body}');

    if (response.statusCode == 200) {
      final List<dynamic> jsonList = jsonDecode(response.body);
      return jsonList.map((json) => Product.fromJson(json)).toList();
    } else {
      throw Exception(
        'Failed to load products by category: ${response.statusCode}',
      );
    }
  }

  // Create product and parse returned product JSON
  static Future<Product> createProduct(Product product) async {
    final response = await http.post(
      Uri.parse(baseUrl),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(product.toJson()),
    );

    print('Response status code: ${response.statusCode}');
    print('Response body: ${response.body}');

    if (response.statusCode == 201 || response.statusCode == 200) {
      final json = jsonDecode(response.body);
      return Product.fromJson(json);
    } else {
      throw Exception('Failed to create product: ${response.body}');
    }
  }

  // Alternative create method returning bool if backend returns no product JSON
  static Future<bool> createProductBool(Product product) async {
    final response = await http.post(
      Uri.parse(baseUrl),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(product.toJson()),
    );

    print('Response status code: ${response.statusCode}');
    print('Response body: ${response.body}');

    return response.statusCode == 201 || response.statusCode == 200;
  }

  // Update product by ID
  static Future<bool> updateProduct(String id, Product product) async {
    final url = Uri.parse('$baseUrl/$id');
    final response = await http.put(
      url,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(product.toJson()),
    );

    print('Update response status: ${response.statusCode}');
    print('Update response body: ${response.body}');

    if (response.statusCode == 200) {
      return true;
    } else {
      throw Exception('Failed to update product: ${response.body}');
    }
  }

  // Delete product by ID
  static Future<bool> deleteProduct(String id) async {
    final url = Uri.parse('$baseUrl/$id');
    final response = await http.delete(url);

    print('Delete response status: ${response.statusCode}');
    print('Delete response body: ${response.body}');

    if (response.statusCode == 200) {
      return true;
    } else {
      throw Exception('Failed to delete product: ${response.body}');
    }
  }
}
