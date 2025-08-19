import 'package:ecom_project/controllers/home_controller.dart';
import 'package:ecom_project/services/app_widget.dart';
import 'package:flutter/material.dart';
import 'package:ecom_project/constants/app_colors.dart';
import 'package:get/get.dart';
import '../models/product.dart';

class ProductScreen extends StatefulWidget {
  const ProductScreen({super.key});

  @override
  State<ProductScreen> createState() => _ProductScreenState();
}

class _ProductScreenState extends State<ProductScreen> {
  final HomeController homeController = Get.find();
  final TextEditingController searchController = TextEditingController();
  RxBool isRefresh = false.obs;

  @override
  void initState() {
    super.initState();
    homeController.getAllProducts();
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        scrolledUnderElevation: 0,
        title: const Text(
          'Products',
          style: TextStyle(
            color: AppColors.blackColor,
            fontWeight: FontWeight.w600,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: AppColors.blackColor),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Search bar
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(25),
              ),
              child: Row(
                children: [
                  Icon(Icons.search, color: Colors.grey.shade600),
                  const SizedBox(width: 12),
                  Expanded(
                    child: TextField(
                      controller: searchController,
                      decoration: InputDecoration(
                        hintText: 'Search products...',
                        border: InputBorder.none,
                        hintStyle: TextStyle(color: Colors.grey.shade600),
                      ),
                      onChanged: (query) {
                        // Search functionality will be implemented here
                      },
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // Results count
            Obx(() {
              // final searchQuery = searchController.text;
              // final displayProducts = searchQuery.isEmpty
              //     ? homeController.products
              //     : homeController.searchProducts(searchQuery);

              return Text(
                '${homeController.products.length} results found',
                style: TextStyle(
                  fontSize: 10,
                  color: Color(0xff0c0c0c).withOpacity(0.40),
                ),
              );
            }),

            const SizedBox(height: 24),

            // Products grid
            Expanded(
              child: Obx(() {
                if (homeController.isLoading.value) {
                  return const Center(
                    child: CircularProgressIndicator(
                      color: AppColors.blackColor,
                    ),
                  );
                }

                if (homeController.errorMessage.value.isNotEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.error_outline,
                          size: 64,
                          color: Colors.grey.shade400,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'Error loading products',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            color: Colors.grey.shade600,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          homeController.errorMessage.value,
                          style: TextStyle(color: Colors.grey.shade500),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 16),
                        ElevatedButton(
                          onPressed: () => homeController.getAllProducts(),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.blackColor,
                            foregroundColor: Colors.white,
                          ),
                          child: const Text('Try Again'),
                        ),
                      ],
                    ),
                  );
                }

                // final searchQuery = searchController.text;
                // final displayProducts = searchQuery.isEmpty
                //     ? homeController.products
                //     : homeController.searchProducts(searchQuery);

                // if (displayProducts.isEmpty) {
                //   return Center(
                //     child: Column(
                //       mainAxisAlignment: MainAxisAlignment.center,
                //       children: [
                //         Icon(
                //           Icons.search_off,
                //           size: 64,
                //           color: Colors.grey.shade400,
                //         ),
                //         const SizedBox(height: 16),
                //         Text(
                //           searchQuery.isEmpty
                //               ? 'No products found'
                //               : 'No search results',
                //           style: TextStyle(
                //             fontSize: 18,
                //             fontWeight: FontWeight.w600,
                //             color: Colors.grey.shade600,
                //           ),
                //         ),
                //         const SizedBox(height: 8),
                //         Text(
                //           searchQuery.isEmpty
                //               ? 'Try refreshing the page'
                //               : 'Try different search terms',
                //           style: TextStyle(color: Colors.grey.shade500),
                //           textAlign: TextAlign.center,
                //         ),
                //       ],
                //     ),
                //   );
                // }

                return RefreshIndicator(
                  onRefresh: () async {
                    await homeController.getAllProducts();
                  },
                  child: ListView.builder(
                    itemCount: homeController.products.length,
                    itemBuilder: (context, index) {
                      final product = homeController.products[index];

                      return Padding(
                        padding: const EdgeInsets.only(bottom: 16),
                        child: AppWidget.buildProductCard(product),
                      );
                    },
                  ),
                );
              }),
            ),
          ],
        ),
      ),
    );
  }
}
