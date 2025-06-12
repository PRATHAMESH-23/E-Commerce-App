import 'package:cached_network_image/cached_network_image.dart';
import 'package:e_commerce_app/viewmodel/cart_viewmodel.dart';
import 'package:e_commerce_app/widgets/custom_appicon.dart';
import 'package:flutter/material.dart';
import 'package:e_commerce_app/model/product_model.dart';
import 'package:provider/provider.dart';

class ProductDetailScreen extends StatefulWidget {
  final Product product;
  const ProductDetailScreen({super.key, required this.product});

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen>
    with SingleTickerProviderStateMixin {
  int _quantity = 1;
  late TabController _tabController;
  int _currentImageIndex = 0; // For image carousel indicator

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _increaseQuantity() {
    setState(() {
      _quantity++;
    });
  }

  void _decreaseQuantity() {
    setState(() {
      if (_quantity > 1) {
        _quantity--;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final product = widget.product;
    final cartProvider = Provider.of<CartProvider>(context, listen: false);

    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 16.0,
              vertical: 8.0,
            ),
            decoration: const BoxDecoration(color: Colors.white),
            child: SafeArea(
              // Ensures content respects device notches/status bar
              child: Row(
                children: [
                  CustomAppicon(
                    icon: Icons.arrow_back,
                    onButtonClicked: () => Navigator.of(context).pop(),
                  ),
                  Spacer(),
                  CustomAppicon(icon: Icons.share),
                  SizedBox(width: 10),
                  CustomAppicon(icon: Icons.favorite_outline_outlined),
                ],
              ),
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Hero(
                    tag: 'productImage-${product.id}',
                    child: Container(
                      height: 250,
                      width: double.infinity,
                      alignment: Alignment.center,
                      child: Stack(
                        alignment: Alignment.bottomCenter,
                        children: [
                          PageView.builder(
                            itemCount: 1, // Assuming one main image for now
                            onPageChanged: (index) {
                              setState(() {
                                _currentImageIndex = index;
                              });
                            },
                            itemBuilder: (context, index) {
                              return CachedNetworkImage(
                                imageUrl: product.image,
                                fit: BoxFit.contain,
                                placeholder:
                                    (context, url) => const Center(
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                      ),
                                    ),
                                errorWidget:
                                    (context, url, error) => const Icon(
                                      Icons.broken_image,
                                      size: 80,
                                    ),
                              );
                            },
                          ),
                          // Image carousel indicators (dots)
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: List.generate(
                              4,
                              (index) => Container(
                                width: 8.0,
                                height: 8.0,
                                margin: const EdgeInsets.symmetric(
                                  horizontal: 4.0,
                                ),
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color:
                                      _currentImageIndex == index
                                          ? Colors.deepOrange
                                          : Colors.grey.withOpacity(0.5),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          product.title,
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        // Only showing current price
                        Text(
                          '\Rs.${product.price.toStringAsFixed(2)}',
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.deepOrange,
                          ),
                        ),
                        const SizedBox(height: 4),

                        Row(
                          children: [
                            Container(
                              height: 25,
                              width: 50,
                              decoration: BoxDecoration(
                                color: Colors.deepOrange,
                                borderRadius: BorderRadius.circular(100),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.star,
                                    size: 15,
                                    color: Colors.white,
                                  ),
                                  Text(
                                    "4.3",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(width: 5),
                            Text(
                              "(132 Reviews)",
                              style: TextStyle(color: Colors.grey),
                            ),
                            Spacer(),
                            // Seller Info
                            Text(
                              'Seller: ${product.brand}',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 16),

                        // TabBar for Description, Specifications, Reviews
                        TabBar(
                          dividerColor: Colors.transparent,
                          controller: _tabController,
                          labelColor:
                              Colors.white, // Text color for selected tab
                          unselectedLabelColor:
                              Colors.black, // Text color for unselected tabs
                          labelStyle: const TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                          indicatorSize: TabBarIndicatorSize.tab,
                          indicator: BoxDecoration(
                            borderRadius: BorderRadius.circular(100),
                            color: Colors.deepOrange,
                          ),
                          tabs: const [
                            Tab(text: 'Description'),
                            Tab(text: 'Specifications'),
                            Tab(text: 'Reviews'),
                          ],
                        ),
                        SizedBox(
                          height:
                              200, // Fixed height for tab content (adjust as needed)
                          child: TabBarView(
                            controller: _tabController,
                            children: [
                              // Description Tab
                              SingleChildScrollView(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 12.0,
                                ),
                                child: Text(
                                  product.description,
                                  style: const TextStyle(
                                    fontSize: 15,
                                    color: Colors.grey,
                                  ),
                                ),
                              ),
                              // Specifications Tab (Dummy content)
                              const SingleChildScrollView(
                                padding: EdgeInsets.symmetric(vertical: 12.0),
                                child: Text(
                                  'Detailed specifications will be listed here. This could include dimensions, weight, battery life, connectivity, etc.',
                                  style: TextStyle(
                                    fontSize: 15,
                                    color: Colors.grey,
                                  ),
                                ),
                              ),
                              // Reviews Tab (Dummy content)
                              const SingleChildScrollView(
                                padding: EdgeInsets.symmetric(vertical: 12.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Customer reviews will appear here.',
                                      style: TextStyle(
                                        fontSize: 15,
                                        color: Colors.grey,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 24),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          // Bottom quantity selector and Add to Cart button
          Container(
            margin: EdgeInsets.only(left: 12, right: 12, bottom: 12),
            padding: EdgeInsets.symmetric(vertical: 5),
            decoration: BoxDecoration(
              color: Colors.black,
              borderRadius: BorderRadius.circular(100),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  margin: EdgeInsets.only(left: 12),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(100),
                    border: Border.all(color: Colors.white),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.only(left: 5, right: 5),
                    child: Row(
                      children: [
                        GestureDetector(
                          onTap: _decreaseQuantity,
                          child: Icon(
                            Icons.remove,
                            size: 24,
                            color: Colors.white,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: Text(
                            '$_quantity',
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: _increaseQuantity,
                          child: Icon(Icons.add, size: 24, color: Colors.white),
                        ),
                      ],
                    ),
                  ),
                ),
                InkWell(
                  onTap: () {
                    for (int i = 0; i < _quantity; i++) {
                      cartProvider.addProductToCart(
                        product,
                      ); // Pass the entire product
                    }
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          'Added $_quantity quantity to cart successfully!',
                        ),
                      ),
                    );
                  },
                  child: Container(
                    width: 200,
                    margin: EdgeInsets.only(right: 12),
                    padding: EdgeInsets.symmetric(vertical: 10),
                    decoration: BoxDecoration(
                      color: Colors.deepOrange,
                      borderRadius: BorderRadius.circular(100),
                    ),
                    child: Center(
                      child: Text(
                        'Add to Cart',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 16),
        ],
      ),
    );
  }
}
