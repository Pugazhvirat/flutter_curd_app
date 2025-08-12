import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_curd_app/models/product.dart';
import 'package:flutter_curd_app/views/global_variable.dart';
import 'package:http/http.dart' as http;

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Product> _allProducts = [];
  List<Product> _filteredProducts = [];
  final List<String> categories = [
    'mobiles',
    'electronics',
    'toys',
    'furniture',
  ];
  final TextEditingController _searchController = TextEditingController();
  bool _isLoading = false;
  String? _errorMessage;
  int _selectedCategoryIndex = -1;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _loadAllProducts();
    _searchController.addListener(_filterProducts);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  // Add cache-busting query param here:
  Future<List<Product>> fetchAllProducts() async {
    final response = await http.get(
      Uri.parse('$uri/api/products?t=${DateTime.now().millisecondsSinceEpoch}'),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      return (json.decode(response.body) as List)
          .map((json) => Product.fromJson(json))
          .toList();
    } else {
      throw Exception('Failed to load products (${response.statusCode})');
    }
  }

  Future<List<Product>> fetchProductsByCategory(String category) async {
    final response = await http.get(
      Uri.parse(
        '$uri/api/products/category/$category?t=${DateTime.now().millisecondsSinceEpoch}',
      ),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      return (json.decode(response.body) as List)
          .map((json) => Product.fromJson(json))
          .toList();
    } else {
      throw Exception(
        'Failed to load $category products (${response.statusCode})',
      );
    }
  }

  Future<void> _loadAllProducts() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final products = await fetchAllProducts();
      setState(() {
        _allProducts = products;
        _filteredProducts = products;
        _selectedCategoryIndex = -1;
      });
    } catch (e) {
      setState(() {
        _errorMessage = e.toString();
        _allProducts = [];
        _filteredProducts = [];
      });
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _loadProductsByCategory(int index) async {
    if (index == _selectedCategoryIndex) {
      Navigator.pop(context);
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = null;
      _selectedCategoryIndex = index;
      _searchController.clear();
    });

    try {
      final products = await fetchProductsByCategory(categories[index]);
      setState(() {
        _allProducts = products;
        _filteredProducts = products;
      });
    } catch (e) {
      setState(() {
        _errorMessage = e.toString();
        _allProducts = [];
        _filteredProducts = [];
      });
    } finally {
      setState(() => _isLoading = false);
      if (mounted) Navigator.pop(context);
    }
  }

  void _filterProducts() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      _filteredProducts = query.isEmpty
          ? List.from(_allProducts)
          : _allProducts
                .where((p) => p.name.toLowerCase().contains(query))
                .toList();
    });
  }

  Widget _buildProductItem(Product product) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.15),
            spreadRadius: 2,
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.all(12),
        title: Text(
          product.name,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 6),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                product.description,
                style: TextStyle(fontSize: 13, color: Colors.grey[600]),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 6),
              Text(
                product.category,
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 13,
                  color: Colors.deepPurple,
                ),
              ),
            ],
          ),
        ),
        trailing: Text(
          "\$${product.price.toStringAsFixed(2)}",
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.green,
          ),
        ),
      ),
    );
  }

  Widget _buildDrawer() {
    return Drawer(
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.all(16.0),
              child: Text(
                'Categories',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
            ),
            const Divider(),
            ListTile(
              title: Text(
                'All Products',
                style: TextStyle(
                  fontWeight: _selectedCategoryIndex == -1
                      ? FontWeight.bold
                      : null,
                  color: _selectedCategoryIndex == -1
                      ? Colors.deepPurple
                      : null,
                ),
              ),
              onTap: () {
                if (_selectedCategoryIndex != -1) _loadAllProducts();
                Navigator.pop(context);
              },
            ),
            ...categories.asMap().entries.map((entry) {
              final index = entry.key;
              final category = entry.value;
              return ListTile(
                title: Text(
                  '${category[0].toUpperCase()}${category.substring(1)}',
                  style: TextStyle(
                    fontWeight: _selectedCategoryIndex == index
                        ? FontWeight.bold
                        : null,
                    color: _selectedCategoryIndex == index
                        ? Colors.deepPurple
                        : null,
                  ),
                ),
                onTap: () => _loadProductsByCategory(index),
              );
            }),
            const Spacer(),
            ListTile(
              leading: const Icon(Icons.close),
              title: const Text('Close Drawer'),
              onTap: () => Navigator.pop(context),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: const Text('Products'),
        backgroundColor: Colors.deepPurple,
        leading: IconButton(
          icon: const Icon(Icons.menu),
          onPressed: () => _scaffoldKey.currentState?.openDrawer(),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            tooltip: 'Refresh Products',
            onPressed: _loadAllProducts, // Manual refresh button
          ),
        ],
      ),
      drawer: _buildDrawer(),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(30),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    spreadRadius: 1,
                    blurRadius: 8,
                    offset: const Offset(0, 3),
                  ),
                ],
                border: Border.all(
                  color: Colors.deepPurple.shade100,
                  width: 1.5,
                ),
              ),
              child: TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  hintText: 'Search products by name...',
                  prefixIcon: Icon(
                    Icons.search,
                    color: Colors.deepPurple.shade400,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                    borderSide: BorderSide.none,
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                    borderSide: BorderSide(
                      color: Colors.deepPurple.shade400,
                      width: 2,
                    ),
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    vertical: 14,
                    horizontal: 20,
                  ),
                  fillColor: Colors.white,
                  filled: true,
                ),
                cursorColor: Colors.deepPurple,
              ),
            ),
          ),
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : _errorMessage != null
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Error: $_errorMessage',
                          style: const TextStyle(color: Colors.red),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 16),
                        ElevatedButton(
                          onPressed: _loadAllProducts,
                          child: const Text('Retry'),
                        ),
                      ],
                    ),
                  )
                : _filteredProducts.isEmpty
                ? const Center(child: Text('No products found'))
                : RefreshIndicator(
                    onRefresh: _loadAllProducts,
                    child: ListView.builder(
                      padding: const EdgeInsets.only(bottom: 16),
                      itemCount: _filteredProducts.length,
                      itemBuilder: (context, index) =>
                          _buildProductItem(_filteredProducts[index]),
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}
