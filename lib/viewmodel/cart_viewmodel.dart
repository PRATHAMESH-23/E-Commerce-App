// lib/providers/cart_provider.dart
import 'package:flutter/material.dart';
import 'package:e_commerce_app/model/cart_item_model.dart'; // Import your CartItem model
import 'package:e_commerce_app/model/product_model.dart'; // Import your Product model

class CartProvider extends ChangeNotifier {
  final List<CartItem> _items = [];

  List<CartItem> get items => _items;

  int get totalItems => _items.fold(0, (sum, item) => sum + item.quantity);

  double get subtotal {
    double total = 0.0;
    for (var item in _items) {
      total += item.product.price * item.quantity;
    }
    return total;
  }

  double get total => subtotal;

  void addProductToCart(Product product) {
    // Check if the product is already in the cart
    int existingIndex = _items.indexWhere(
      (item) => item.product.id == product.id,
    );

    if (existingIndex != -1) {
      // If exists, increment quantity
      _items[existingIndex].incrementQuantity();
    } else {
      // If not, add as a new item
      _items.add(CartItem(product: product, quantity: 1));
    }
    notifyListeners();
  }

  void removeProductFromCart(int productId) {
    _items.removeWhere((item) => item.product.id == productId);
    notifyListeners();
  }

  void incrementQuantity(int productId) {
    int index = _items.indexWhere((item) => item.product.id == productId);
    if (index != -1) {
      _items[index].incrementQuantity();
      notifyListeners();
    }
  }

  void decrementQuantity(int productId) {
    int index = _items.indexWhere((item) => item.product.id == productId);
    if (index != -1) {
      if (_items[index].quantity > 1) {
        _items[index].decrementQuantity();
      } else {
        // If quantity becomes 0, remove the item
        _items.removeAt(index);
      }
      notifyListeners();
    }
  }

  void clearCart() {
    _items.clear();
    notifyListeners();
  }
}
