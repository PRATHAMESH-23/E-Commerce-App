import 'package:cached_network_image/cached_network_image.dart';
import 'package:e_commerce_app/pages/cart_page.dart';
import 'package:e_commerce_app/pages/product_details_page.dart';
import 'package:e_commerce_app/viewmodel/dashboard_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create:
          (context) =>
              ProductProvider(), // Initialize ProductProvider directly here
      child: Consumer<ProductProvider>(
        builder: (context, productProvider, child) {
          // Show a loading indicator if categories are being loaded
          if (productProvider.isLoadingCategories) {
            return const Scaffold(
              body: Center(child: CircularProgressIndicator()),
            );
          }

          return Scaffold(
            appBar: AppBar(
              leading: const Icon(Icons.menu),
              actions: const [
                Padding(
                  padding: EdgeInsets.only(right: 12.0),
                  child: Icon(Icons.notification_add),
                ),
              ],
            ),
            body: Column(
              children: [
                // Category List
                SizedBox(
                  height: 50,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    itemCount: productProvider.categories.length,
                    itemBuilder: (context, index) {
                      final category = productProvider.categories[index];
                      return GestureDetector(
                        onTap: () {},
                        child: Padding(
                          padding: const EdgeInsets.only(right: 8.0),
                          child: Chip(label: Text(category)),
                        ),
                      );
                    },
                  ),
                ),
                // Section Header: "Special for You"
                const Padding(
                  padding: EdgeInsets.all(12.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Special for You",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                      TextButton(
                        onPressed:
                            null, // onPressed: () {}, // Re-enable when functionality is added
                        child: Text("See All"),
                      ),
                    ],
                  ),
                ),
                // Product Grid or Loading Indicator
                Expanded(
                  // Use Expanded to make the GridView take available space and be scrollable
                  child:
                      productProvider.isLoadingProducts
                          ? const Center(
                            child: Column(
                              mainAxisAlignment:
                                  MainAxisAlignment
                                      .center, // Center content vertically
                              children: [
                                CircularProgressIndicator(),
                                SizedBox(height: 10), // Add some spacing
                                Text(
                                  "Please wait...",
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18,
                                  ),
                                ),
                              ],
                            ),
                          )
                          : GridView.builder(
                            padding: const EdgeInsets.only(
                              left: 10.0,
                              right: 10.0,
                            ),
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 2,
                                  crossAxisSpacing: 20.0,
                                  mainAxisSpacing: 20.0,
                                  childAspectRatio: 0.8,
                                ),
                            itemCount: productProvider.allProducts.length,
                            itemBuilder: (context, index) {
                              final product =
                                  productProvider.allProducts[index];
                              print(product.image);
                              return GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder:
                                          (context) => ProductDetailScreen(
                                            product: product,
                                          ),
                                    ),
                                  );
                                },
                                child: Card(
                                  elevation: 4,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  clipBehavior:
                                      Clip.antiAlias, // Ensures image respects border radius
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Expanded(
                                        child: Container(
                                          alignment: Alignment.center,
                                          padding: const EdgeInsets.all(8.0),
                                          child: CachedNetworkImage(
                                            imageUrl: product.image,
                                            fit: BoxFit.contain,
                                            placeholder:
                                                (context, url) => const Center(
                                                  child:
                                                      CircularProgressIndicator(
                                                        strokeWidth: 2,
                                                      ),
                                                ),
                                            errorWidget:
                                                (context, url, error) =>
                                                    const Icon(Icons.error),
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 8.0,
                                          vertical: 4.0,
                                        ),
                                        child: Text(
                                          product.title,
                                          style: const TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold,
                                          ),
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 8.0,
                                          vertical: 4.0,
                                        ),
                                        child: Text(
                                          '\Rs.${product.price.toStringAsFixed(2)}',
                                          style: const TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.blueAccent,
                                          ),
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 8,
                                      ), // Spacing at the bottom
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                ),
                Container(
                  height: 50,
                  decoration: BoxDecoration(color: Colors.white),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      IconButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => DashboardPage(),
                            ),
                          );
                        },
                        icon: Icon(Icons.home),
                      ),
                      IconButton(onPressed: () {}, icon: Icon(Icons.category)),
                      IconButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => CartScreen(),
                            ),
                          );
                        },
                        icon: Icon(Icons.shopping_cart),
                      ),
                      IconButton(onPressed: () {}, icon: Icon(Icons.person)),
                    ],
                  ),
                ),
                // Bottom Navigation Bar
              ],
            ),
          );
        },
      ),
    );
  }
}
