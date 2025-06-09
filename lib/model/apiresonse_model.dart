import 'package:e_commerce_app/model/product_model.dart';

class ApiResponse {
  final String status;
  final String message;
  final List<Product> products;

  ApiResponse({
    required this.status,
    required this.message,
    required this.products,
  });

  factory ApiResponse.fromJson(Map<String, dynamic> json) {
    // Ensure 'products' key exists and is a List before mapping
    var productsList =
        json['products']
            as List<dynamic>?; // Make nullable to handle missing key gracefully

    List<Product> parsedProducts = [];
    if (productsList != null) {
      parsedProducts =
          productsList
              .map(
                (productJson) =>
                    Product.fromJson(productJson as Map<String, dynamic>),
              )
              .toList();
    }

    return ApiResponse(
      status: json['status'] as String,
      message: json['message'] as String,
      products: parsedProducts,
    );
  }
}
