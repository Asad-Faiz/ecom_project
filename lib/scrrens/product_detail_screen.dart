import 'package:ecom_project/models/product.dart';
import 'package:ecom_project/services/app_widget.dart';
import 'package:ecom_project/controllers/home_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ProductDetailScreen extends StatefulWidget {
  final Product currentProduct;
  const ProductDetailScreen({super.key, required this.currentProduct});

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  final HomeController homeController = Get.find<HomeController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppWidget.customAppbar(
        title: 'Product Details',
        showBackButton: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            productImage(),

            Container(
              margin: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  AppWidget.largeTitle(
                    text: 'Product Details:',
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(right: 10.0),
                    child: Obx(
                      () => GestureDetector(
                        onTap: () {
                          homeController.toggleFavourite(
                            widget.currentProduct.id,
                          );
                        },
                        child: Image.asset(
                          homeController.isProductFavourite(
                                widget.currentProduct.id,
                              )
                              ? "assets/icons/ic_selected_heart.png"
                              : "assets/icons/ic_unselected_heart.png",

                          width: 27,
                          height: 22,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            buildProductDetails(),

            productGallery(),

            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  productImage() {
    return Container(
      width: double.infinity,
      height: 209,
      margin: const EdgeInsets.all(16),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Image.network(
          widget.currentProduct.thumbnail.isNotEmpty
              ? widget.currentProduct.thumbnail
              : widget.currentProduct.images.isNotEmpty
              ? widget.currentProduct.images.first
              : '',
          fit: BoxFit.fitHeight,
          errorBuilder: (context, error, stackTrace) {
            return Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                color: Colors.grey[300],
              ),
              child: const Icon(Icons.image, color: Colors.grey, size: 80),
            );
          },
        ),
      ),
    );
  }

  buildProductDetails() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // const SizedBox(height: 20),

          // Product information
          if (widget.currentProduct.title != '')
            buildInfoRow('Name', widget.currentProduct.title),
          if (widget.currentProduct.formattedPrice != '')
            buildInfoRow('Price', widget.currentProduct.formattedPrice),
          if (widget.currentProduct.category != '')
            buildInfoRow('Category', widget.currentProduct.category),
          if (widget.currentProduct.brand != '')
            buildInfoRow('Brand', widget.currentProduct.brand),
          if (widget.currentProduct.rating != 0)
            buildInfoRow(
              'Rating',
              '${(widget.currentProduct.rating * 2).round() / 2}',
              showStars: true,
            ),
          buildInfoRow('Stock', '${widget.currentProduct.stock}'),

          const SizedBox(height: 16),

          // Description
          const Text(
            'Description:',
            style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 8),
          Text(
            widget.currentProduct.description,
            style: const TextStyle(fontSize: 10),
          ),
        ],
      ),
    );
  }

  Widget buildInfoRow(String label, String value, {bool showStars = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          SizedBox(
            child: Text(
              '$label:',
              style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
            ),
          ),
          const SizedBox(width: 16),
          if (showStars && label == 'Rating')
            Row(
              children: [
                Text(value, style: const TextStyle(fontSize: 10)),
                const SizedBox(width: 8),
                AppWidget.starRating(
                  rating: double.tryParse(value) ?? 0,
                  starSize: 11,
                ),
              ],
            )
          else
            Text(value, style: const TextStyle(fontSize: 10)),
        ],
      ),
    );
  }

  productGallery() {
    return Container(
      margin: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppWidget.largeTitle(
            text: 'Product Gallery:',
            fontSize: 12,
            fontWeight: FontWeight.w600,
          ),
          const SizedBox(height: 16),

          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: 1.2,
            ),
            itemCount: widget.currentProduct.images.length > 4
                ? 4
                : widget.currentProduct.images.length,
            itemBuilder: (context, index) {
              return Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color: Colors.grey[200],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.network(
                    widget.currentProduct.images[index],
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          color: Colors.grey[300],
                        ),
                        child: const Icon(
                          Icons.image,
                          color: Colors.grey,
                          size: 40,
                        ),
                      );
                    },
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
