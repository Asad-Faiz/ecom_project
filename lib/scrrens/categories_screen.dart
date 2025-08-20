import 'dart:developer';

import 'package:ecom_project/controllers/home_controller.dart';
import 'package:ecom_project/scrrens/product_screen.dart';
import 'package:ecom_project/services/app_widget.dart';
import 'package:ecom_project/models/category.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CategoriesScreen extends StatefulWidget {
  const CategoriesScreen({super.key});

  @override
  State<CategoriesScreen> createState() => _CategoriesScreenState();
}

class _CategoriesScreenState extends State<CategoriesScreen> {
  final HomeController homeController = Get.find<HomeController>();
  final TextEditingController searchController = TextEditingController();
  String searchQuery = '';

  @override
  void initState() {
    super.initState();
    homeController.getAllCategories();
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  List<Category> get filteredCategories {
    if (searchQuery.isEmpty) {
      return homeController.categories;
    }
    return homeController.categories
        .where(
          (category) =>
              category.name.toLowerCase().contains(searchQuery.toLowerCase()),
        )
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppWidget.customAppbar(title: 'Categories'),
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
                      hintText: 'Search categories...',
                      controller: searchController,
                    ),

                    const SizedBox(height: 16),

                    // Results count
                    Obx(() {
                      if (homeController.isLoading.value == false) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16.0),
                          child: Text(
                            '${filteredCategories.length} results found',
                            style: TextStyle(
                              fontSize: 10,
                              color: Color(0xff0c0c0c).withOpacity(0.40),
                            ),
                          ),
                        );
                      } else {
                        return SizedBox();
                      }
                    }),

                    const SizedBox(height: 16),

                    // Categories grid
                    Expanded(
                      child: Obx(() {
                        if (homeController.isLoading.value) {
                          return const Center(
                            child: CircularProgressIndicator(
                              color: Colors.black,
                            ),
                          );
                        }

                        if (filteredCategories.isEmpty) {
                          return Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  searchQuery.isEmpty
                                      ? Icons.category_outlined
                                      : Icons.search_off,
                                  size: 64,
                                  color: Colors.grey.shade400,
                                ),
                                const SizedBox(height: 16),
                                Text(
                                  searchQuery.isEmpty
                                      ? 'No categories found'
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
                            await homeController.getAllCategories();
                          },
                          child: Padding(
                            padding: EdgeInsetsGeometry.symmetric(
                              horizontal: 16,
                            ),
                            child: GridView.builder(
                              gridDelegate:
                                  const SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 2,
                                    crossAxisSpacing: 20,
                                    mainAxisSpacing: 20,
                                    childAspectRatio: 1,
                                  ),
                              itemCount: filteredCategories.length,
                              itemBuilder: (context, index) {
                                final category = filteredCategories[index];
                                return _buildCategoryCard(category);
                              },
                            ),
                          ),
                        );
                      }),
                    ),
                  ],
                ),
              )
            : AppWidget.noInternetConnetion(
                onTap: () {
                  homeController.getAllCategories();
                },
              ),
      ),
    );
  }

  Widget _buildCategoryCard(Category category) {
    return GestureDetector(
      onTap: () {
        Get.to(() => ProductScreen(currentCategory: category));
      },
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Stack(
          children: [
            // Category background image
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.asset(
                _getCategoryImage(category.slug),
                width: double.infinity,
                height: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
            // Category name overlay at bottom left without background
            Positioned(
              bottom: 20,
              left: 12,
              child: SizedBox(
                width: MediaQuery.sizeOf(context).width * 0.32,
                child: Text(
                  category.name,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _getCategoryImage(String slug) {
    switch (slug.toLowerCase()) {
      case 'laptops':
        return 'assets/images/ic_laptop.png';
      case 'smartphones':
        return 'assets/images/ic_smartphone.png';
      default:
        return 'assets/images/ic_other.png';
    }
  }
}
