class Product {
  final int id;
  final String title;
  final String image;
  final double price;
  final String description;
  final String brand;
  final String model;
  final String color;
  final String category;
  final double? discount;
  final bool? popular;

  Product({
    required this.id,
    required this.title,
    required this.image,
    required this.price,
    required this.description,
    required this.brand,
    required this.model,
    required this.color,
    required this.category,
    this.discount,
    this.popular,
  });

  // Factory constructor to create a Product object from a JSON map
  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'] as int,
      title: json['title'] as String,
      image: json['image'] as String,
      // Ensure price is parsed as double, handling int if it comes as int
      price: (json['price'] as num).toDouble(),
      description: json['description'] as String,
      brand: json['brand'] as String,
      model: json['model'] as String,
      color: json['color'] as String,
      category: json['category'] as String,
      // Safely parse nullable fields
      discount: (json['discount'] as num?)?.toDouble(),
      popular: json['popular'] as bool?,
    );
  }
}
