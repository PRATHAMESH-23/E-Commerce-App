// lib/model/cart_item_model.dart
import 'package:e_commerce_app/model/product_model.dart'; // Import your Product model

class CartItem {
  final Product product;
  int quantity;

  CartItem({required this.product, this.quantity = 1});

  // Method to increment quantity
  void incrementQuantity() {
    quantity++;
  }

  // Method to decrement quantity
  void decrementQuantity() {
    if (quantity > 1) {
      quantity--;
    }
  }

  // For easy identification and equality checks in a list
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is CartItem && other.product.id == product.id;
  }

  @override
  int get hashCode => product.id.hashCode;
}
