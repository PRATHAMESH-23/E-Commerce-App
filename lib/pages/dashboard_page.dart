import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:e_commerce_app/pages/cart_page.dart';
import 'package:e_commerce_app/pages/product_details_page.dart';
import 'package:e_commerce_app/viewmodel/dashboard_viewmodel.dart';
import 'package:e_commerce_app/widgets/custom_appicon.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  final List<String> discountImages = ['assets/images/BannerTemplate.jpg'];

  Widget _buildCategoryChip(String text, bool isSelected) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 4.0),
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      decoration: BoxDecoration(
        color: isSelected ? Colors.black : Colors.grey[200],
        borderRadius: BorderRadius.circular(20.0),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: isSelected ? Colors.white : Colors.black,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => ProductProvider(),
      child: Consumer<ProductProvider>(
        builder: (context, productProvider, child) {
          // Show a loading indicator if categories are being loaded initially
          if (productProvider.isLoadingCategories &&
              productProvider.categories.isEmpty) {
            return const Scaffold(
              body: Center(child: CircularProgressIndicator()),
            );
          }

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
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        CustomAppicon(icon: Icons.apps_rounded),
                        CustomAppicon(icon: Icons.notifications_none),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 12),
                Expanded(
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // 1. Search Bar
                          Container(
                            decoration: BoxDecoration(
                              color: Colors.grey[100],
                              borderRadius: BorderRadius.circular(100),
                            ),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 0,
                            ),
                            child: Row(
                              children: [
                                const Icon(Icons.search, color: Colors.grey),
                                const SizedBox(width: 10),
                                const Expanded(
                                  child: TextField(
                                    decoration: InputDecoration(
                                      hintText: 'Search...',
                                      border: InputBorder.none,
                                      isDense: true, // Reduce vertical padding
                                    ),
                                    style: TextStyle(fontSize: 14),
                                  ),
                                ),
                                IconButton(
                                  icon: const Icon(
                                    Icons.tune,
                                    color: Colors.grey,
                                  ), // Filter icon
                                  onPressed: () {},
                                  constraints:
                                      const BoxConstraints(), // Remove extra padding from IconButton
                                  padding: EdgeInsets.zero,
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 20),

                          // 2. Super Sale Discount Banner
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 16.0),
                            child: CarouselSlider(
                              options: CarouselOptions(
                                height: 180.0, // Adjust height as needed
                                autoPlay: true,
                                enlargeCenterPage: true,
                                aspectRatio: 16 / 9,
                                autoPlayCurve: Curves.fastOutSlowIn,
                                enableInfiniteScroll: true,
                                autoPlayAnimationDuration: const Duration(
                                  milliseconds: 1000,
                                ),
                                viewportFraction: 1.0,
                              ),
                              items:
                                  discountImages.map((imageUrl) {
                                    return Builder(
                                      builder: (BuildContext context) {
                                        return Container(
                                          width:
                                              MediaQuery.of(context).size.width,
                                          margin: const EdgeInsets.symmetric(
                                            horizontal: 5.0,
                                          ),
                                          decoration: BoxDecoration(
                                            color:
                                                Colors
                                                    .grey[200], // Placeholder color
                                            borderRadius: BorderRadius.circular(
                                              12.0,
                                            ),
                                            image: DecorationImage(
                                              image: AssetImage(imageUrl),
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                          child: Center(
                                            // You can overlay text like "Super Sale Discount Up to 50%" here
                                            // For now, it's just the image.
                                            child:
                                                Container(), // Or a Text widget
                                          ),
                                        );
                                      },
                                    );
                                  }).toList(),
                            ),
                          ),
                          const SizedBox(height: 20),

                          // 3. Category Chips
                          SizedBox(
                            height: 40,
                            child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 0.0,
                              ),
                              itemCount: productProvider.categories.length,
                              itemBuilder: (context, index) {
                                final category =
                                    productProvider.categories[index];
                                // Highlight the selected category based on productProvider state
                                bool isSelected =
                                    productProvider.selectedCategory ==
                                    category;
                                return GestureDetector(
                                  onTap: () {
                                    productProvider.setSelectedCategory(
                                      category,
                                    );
                                    // You might want to filter products here based on category
                                  },
                                  child: _buildCategoryChip(
                                    category,
                                    isSelected,
                                  ),
                                );
                              },
                            ),
                          ),
                          const SizedBox(height: 20),

                          // 4. "Special For You" Header
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                "Special For You",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20,
                                ),
                              ),
                              TextButton(
                                onPressed: () {
                                  // Handle "See All" functionality
                                },
                                child: const Text(
                                  "See all",
                                  style: TextStyle(
                                    color: Colors.grey,
                                    fontSize: 14,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),

                          // 5. Product Grid or Loading Indicator
                          productProvider.isLoadingProducts
                              ? const Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    CircularProgressIndicator(),
                                    SizedBox(height: 10),
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
                                shrinkWrap:
                                    true, // Important for GridView inside SingleChildScrollView
                                physics:
                                    const NeverScrollableScrollPhysics(), // Disable GridView's own scrolling
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 0.0,
                                ),
                                gridDelegate:
                                    const SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: 2,
                                      crossAxisSpacing: 16.0,
                                      mainAxisSpacing: 16.0,
                                      childAspectRatio:
                                          0.75, // Adjusted aspect ratio
                                    ),
                                itemCount: productProvider.allProducts.length,
                                itemBuilder: (context, index) {
                                  final product =
                                      productProvider.allProducts[index];
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
                                      color: Colors.grey.shade200,
                                      elevation: 4,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      clipBehavior: Clip.antiAlias,
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Expanded(
                                            child: Container(
                                              alignment: Alignment.center,
                                              decoration: BoxDecoration(
                                                borderRadius: BorderRadius.only(
                                                  topLeft: Radius.circular(12),
                                                  topRight: Radius.circular(12),
                                                ),
                                              ),
                                              child: ClipRRect(
                                                borderRadius: BorderRadius.only(
                                                  topLeft: Radius.circular(12),
                                                  topRight: Radius.circular(12),
                                                ),
                                                child: Stack(
                                                  children: [
                                                    CachedNetworkImage(
                                                      imageUrl: product.image,
                                                      width: double.infinity,
                                                      fit: BoxFit.cover,
                                                      placeholder:
                                                          (
                                                            context,
                                                            url,
                                                          ) => const Center(
                                                            child:
                                                                CircularProgressIndicator(
                                                                  strokeWidth:
                                                                      2,
                                                                ),
                                                          ),
                                                      errorWidget:
                                                          (
                                                            context,
                                                            url,
                                                            error,
                                                          ) => const Icon(
                                                            Icons.broken_image,
                                                          ),
                                                    ),
                                                    Positioned(
                                                      top: 0,
                                                      right: 0,
                                                      child: Container(
                                                        height: 30,
                                                        width: 30,
                                                        decoration: BoxDecoration(
                                                          color:
                                                              Colors.deepOrange,
                                                          borderRadius:
                                                              BorderRadius.only(
                                                                topRight:
                                                                    Radius.circular(
                                                                      12,
                                                                    ),
                                                                bottomLeft:
                                                                    Radius.circular(
                                                                      12,
                                                                    ),
                                                              ),
                                                        ),
                                                        child: Icon(
                                                          Icons
                                                              .favorite_border_outlined,
                                                          color: Colors.white,
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
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
                                              'Rs.${product.price.toStringAsFixed(2)}',
                                              style: const TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.black,
                                              ),
                                            ),
                                          ),

                                          const SizedBox(height: 8),
                                        ],
                                      ),
                                    ),
                                  );
                                },
                              ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
            bottomNavigationBar: BottomNavigationBar(
              items: const <BottomNavigationBarItem>[
                BottomNavigationBarItem(
                  icon: Icon(Icons.home_filled),
                  label: '',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.favorite_border),
                  label: '',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.shopping_cart_outlined),
                  label: '',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.person_outline),
                  label: '',
                ),
              ],
              currentIndex: productProvider.selectedIndex,
              selectedItemColor: Colors.deepOrange,
              unselectedItemColor: Colors.grey,
              type: BottomNavigationBarType.fixed,
              showSelectedLabels: false,
              showUnselectedLabels: false,
              onTap: (index) async {
                productProvider.setSelectedIndex(index);
                if (index == 2) {
                  // Navigate to CartScreen
                  await Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const CartScreen()),
                  );
                  productProvider.setSelectedIndex(0);
                }
              },
            ),
          );
        },
      ),
    );
  }
}
