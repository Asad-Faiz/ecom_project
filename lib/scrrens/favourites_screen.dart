import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ecom_project/controllers/home_controller.dart';
import 'package:ecom_project/services/app_widget.dart';
import 'package:ecom_project/models/product.dart';
import 'package:ecom_project/scrrens/product_detail_screen.dart';

class FavouritesScreen extends StatefulWidget {
  const FavouritesScreen({super.key});

  @override
  State<FavouritesScreen> createState() => _FavouritesScreenState();
}

class _FavouritesScreenState extends State<FavouritesScreen> {
  final HomeController homeController = Get.find<HomeController>();
  final TextEditingController searchController = TextEditingController();
  String searchQuery = '';

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  List<Product> get filteredFavourites {
    if (searchQuery.isEmpty) {
      return homeController.favourites;
    }
    return homeController.favourites
        .where(
          (product) =>
              product.title.toLowerCase().contains(searchQuery.toLowerCase()),
        )
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppWidget.customAppbar(
        title: 'Favourites',
        showBackButton: false,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppWidget.searchTextField(
            margin: EdgeInsets.symmetric(horizontal: 21),

            onChanged: (value) {
              setState(() {
                searchQuery = value;
              });
            },
            hintText: 'Search favourites...',
            controller: searchController,
          ),
          const SizedBox(height: 16),

          // Favourites List
          Obx(() {
            if (homeController.isLoading.value == false) {
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30.0),
                child: Text(
                  '${filteredFavourites.length} results found',
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
          const SizedBox(height: 16),

          Expanded(
            child: Obx(() {
              if (homeController.favourites.isEmpty) {
                return noFavoriteFound();
              }

              if (filteredFavourites.isEmpty) {
                return noSearchResults();
              }

              return favouriteContainer();
            }),
          ),
        ],
      ),
    );
  }

  noFavoriteFound() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.favorite_border, size: 80, color: Colors.grey[400]),
          const SizedBox(height: 16),
          Text(
            'No Favourites Yet',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Start adding products to your favourites\nand they will appear here',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 14, color: Colors.grey[500]),
          ),
        ],
      ),
    );
  }

  noSearchResults() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.search_off, size: 80, color: Colors.grey[400]),
          const SizedBox(height: 16),
          Text(
            'No Results Found',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Try adjusting your search terms',
            style: TextStyle(fontSize: 14, color: Colors.grey[500]),
          ),
        ],
      ),
    );
  }

  favouriteContainer() {
    return ListView.builder(
      padding: const EdgeInsets.only(left: 16, right: 30),
      itemCount: filteredFavourites.length,
      itemBuilder: (context, index) {
        final product = filteredFavourites[index];
        return Container(
          margin: const EdgeInsets.only(bottom: 12),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.transparent),
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: GestureDetector(
            onTap: () {
              Get.to(() => ProductDetailScreen(currentProduct: product));
            },
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Row(
                children: [
                  //product image
                  Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30),
                      color: Colors.grey[200],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(30),
                      child: Image.network(
                        product.thumbnail.isNotEmpty
                            ? product.thumbnail
                            : product.images.isNotEmpty
                            ? product.images.first
                            : '',
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return Icon(
                            Icons.image,
                            color: Colors.grey[400],
                            size: 24,
                          );
                        },
                      ),
                    ),
                  ),

                  const SizedBox(width: 12),

                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Title
                        Text(
                          product.title,
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 4),

                        // Price
                        Text(
                          product.formattedPrice,
                          style: const TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                            color: Colors.black,
                          ),
                        ),
                        const SizedBox(height: 4),

                        // Rating with stars
                        Row(
                          children: [
                            Text(
                              '${product.rating}',
                              style: const TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(width: 4),
                            AppWidget.starRating(
                              rating: product.rating,
                              starSize: 11,
                              emptyStarColor: Colors.grey[400]!,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(width: 12),

                  GestureDetector(
                    onTap: () {
                      homeController.toggleFavourite(product.id);
                    },
                    child: Image.asset(
                      homeController.isProductFavourite(product.id)
                          ? "assets/icons/ic_selected_heart.png"
                          : "assets/icons/ic_unselected_heart.png",

                      height: 16,
                      width: 19,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
