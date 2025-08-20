import 'dart:developer';

import 'package:ecom_project/controllers/home_controller.dart';
import 'package:ecom_project/models/category.dart';
import 'package:ecom_project/services/app_widget.dart';
import 'package:flutter/material.dart';
import 'package:ecom_project/constants/app_colors.dart';
import 'package:get/get.dart';
import '../models/product.dart';

class ProductScreen extends StatefulWidget {
  final Category? currentCategory;
  const ProductScreen({super.key, this.currentCategory});

  @override
  State<ProductScreen> createState() => _ProductScreenState();
}

class _ProductScreenState extends State<ProductScreen> {
  final HomeController homeController = Get.find();
  final TextEditingController searchController = TextEditingController();
  RxBool isRefresh = false.obs;
  String searchQuery = '';

  @override
  void initState() {
    super.initState();
    // Use Future.microtask to avoid calling setState during build
    Future.microtask(() => doProcess());
  }

  Future<void> doProcess() async {
    try {
      if (widget.currentCategory != null) {
        log("Loading products for category: ${widget.currentCategory!.name}");
        await homeController.getProductsByCategory(
          widget.currentCategory!.slug,
        );
      } else {
        log("Loading all products");
        await homeController.getAllProducts();
      }
    } catch (e) {
      log("Error in doProcess: $e");
    }
  }

  List<Product> get filteredProducts {
    if (searchQuery.isEmpty) {
      if (widget.currentCategory != null) {
        return homeController.categoryProducts;
      } else {
        return homeController.products;
      }
    }
    if (widget.currentCategory != null) {
      return homeController.categoryProducts
          .where(
            (product) =>
                product.title.toLowerCase().contains(searchQuery.toLowerCase()),
          )
          .toList();
    } else {
      return homeController.products
          .where(
            (product) =>
                product.title.toLowerCase().contains(searchQuery.toLowerCase()),
          )
          .toList();
    }
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
      appBar: AppWidget.customAppbar(
        title: widget.currentCategory != null
            ? widget.currentCategory!.name
            : 'Products',
        showBackButton: widget.currentCategory != null ? true : false,
      ),
      body: Obx(
        () => homeController.hasInternetConnection.value
            ? Padding(
                padding: const EdgeInsets.fromLTRB(16.0, 0, 16.0, 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Search bar
                    AppWidget.searchTextField(
                      margin: EdgeInsets.symmetric(horizontal: 5),

                      onChanged: (query) {
                        setState(() {
                          searchQuery = query;
                        });
                      },
                      hintText: 'Search products...',
                      controller: searchController,
                    ),

                    const SizedBox(height: 16),

                    // Results count
                    Obx(() {
                      if (homeController.isLoading.value == false) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16.0),
                          child: Text(
                            '${filteredProducts.length} results found',
                            style: TextStyle(
                              fontSize: 10,
                              color: Color(0xff0c0c0c).withOpacity(0.25),
                            ),
                          ),
                        );
                      } else {
                        return SizedBox();
                      }
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

                        if (filteredProducts.isEmpty) {
                          return Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  searchQuery.isEmpty
                                      ? Icons.inventory_2_outlined
                                      : Icons.search_off,
                                  size: 64,
                                  color: Colors.grey.shade400,
                                ),
                                const SizedBox(height: 16),
                                Text(
                                  searchQuery.isEmpty
                                      ? 'No products found'
                                      : 'No search results',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.grey.shade600,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  searchQuery.isEmpty
                                      ? 'Try refreshing the page'
                                      : 'Try different search terms',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.grey.shade500,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            ),
                          );
                        }
                        return AppWidget.customRefreshIndicator(
                          onRefresh: () async {
                            if (widget.currentCategory != null) {
                              await homeController.getProductsByCategory(
                                widget.currentCategory!.slug,
                              );
                            } else {
                              await homeController.getAllProducts();
                            }
                          },
                          child: ListView.builder(
                            itemCount: filteredProducts.length,
                            itemBuilder: (context, index) {
                              final product = filteredProducts[index];

                              return Padding(
                                padding: const EdgeInsets.only(bottom: 20),
                                child: AppWidget.productCard(product),
                              );
                            },
                          ),
                        );
                      }),
                    ),
                  ],
                ),
              )
            : AppWidget.noInternetConnetion(onTap: doProcess),
      ),
    );
  }
}
