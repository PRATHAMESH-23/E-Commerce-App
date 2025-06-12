import 'package:e_commerce_app/model/apiresonse_model.dart';
import 'package:e_commerce_app/model/categoryapiresonse_model.dart';
import 'package:e_commerce_app/model/product_model.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ProductProvider with ChangeNotifier {
  List<Product> _allProducts = [];
  List<String> _categories = [];
  bool _isLoadingProducts = false;
  bool _isLoadingCategories = false;
  String? _errorProducts;
  String? _errorCategories;
  String? _selectedCategory;

  List<Product> get allProducts => _allProducts;
  List<String> get categories => _categories;
  bool get isLoadingProducts => _isLoadingProducts;
  bool get isLoadingCategories => _isLoadingCategories;
  String? get errorProducts => _errorProducts;
  String? get errorCategories => _errorCategories;
  String? get selectedCategory => _selectedCategory;

  void setSelectedCategory(String? category) {
    _selectedCategory = category;
    notifyListeners();
  }

  int _selectedIndex = 0;
  int get selectedIndex => _selectedIndex;
  void setSelectedIndex(int index) {
    if (_selectedIndex != index) {
      // Only update if the index actually changes
      _selectedIndex = index;
      notifyListeners(); // Notify listeners (UI widgets) about the change
    }
  }

  // Constructor: Load data when provider is initialized
  ProductProvider() {
    fetchAllProducts();
    fetchCategories();
  }

  //Fetch All Products
  Future<void> fetchAllProducts() async {
    _isLoadingProducts = true;
    _errorProducts = null;
    notifyListeners();

    try {
      final response = await http.get(
        Uri.parse("https://fakestoreapi.in/api/products?limit=10"),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonResponse = json.decode(response.body);
        final ApiResponse apiResponse = ApiResponse.fromJson(jsonResponse);

        if (apiResponse.status == 'SUCCESS') {
          _allProducts = apiResponse.products;
        } else {
          throw Exception(
            'API response failed for products: ${apiResponse.message}',
          );
        }
      } else {
        throw Exception('Failed to load products: ${response.statusCode}');
      }
    } catch (e) {
      _errorProducts = e.toString();
      debugPrint('Error fetching all products: $e');
    } finally {
      _isLoadingProducts = false;
      notifyListeners();
    }
  }

  //Fetch Category List
  Future<void> fetchCategories() async {
    _isLoadingCategories = true;
    _errorCategories = null;
    notifyListeners();

    try {
      final response = await http.get(
        Uri.parse('https://fakestoreapi.in/api/products/category'),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonResponse = json.decode(response.body);
        final CategoryApiResponse categoryApiResponse =
            CategoryApiResponse.fromJson(jsonResponse);

        if (categoryApiResponse.status == 'SUCCESS') {
          _categories = categoryApiResponse.categories;
        } else {
          throw Exception(
            'API response failed for categories: ${categoryApiResponse.message}',
          );
        }
      } else {
        throw Exception('Failed to load categories: ${response.statusCode}');
      }
    } catch (e) {
      _errorCategories = e.toString();
      debugPrint('Error fetching categories: $e');
    } finally {
      _isLoadingCategories = false;
      notifyListeners();
    }
  }

  // Get products by category
  Future<List<Product>> getProductsByCategory(String categoryName) async {
    try {
      final response = await http.get(
        Uri.parse('YOUR_CUSTOM_API_BASE_URL/products/category/$categoryName'),
      );
      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonResponse = json.decode(response.body);
        final ApiResponse apiResponse = ApiResponse.fromJson(jsonResponse);

        if (apiResponse.status == 'SUCCESS') {
          return apiResponse.products;
        } else {
          throw Exception(
            'API response failed for category products: ${apiResponse.message}',
          );
        }
      } else {
        throw Exception(
          'Failed to load products for category: ${response.statusCode}',
        );
      }
    } catch (e) {
      debugPrint('Error fetching products by category: $e');
      rethrow;
    }
  }

  // Get details of particular product
  Future<Product?> getProductById(int productId) async {
    try {
      final response = await http.get(
        Uri.parse('https://fakestoreapi.in/api/products/$productId'),
      ); // <-- REPLACE
      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        // Assuming a single product response is directly the product object
        return Product.fromJson(data);
      } else {
        throw Exception(
          'Failed to load product details: ${response.statusCode}',
        );
      }
    } catch (e) {
      debugPrint('Error fetching product by ID: $e');
      return null; // Or rethrow the exception
    }
  }
}
