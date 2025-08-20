import 'package:ecom_project/constants/app_colors.dart';
import 'package:ecom_project/models/product.dart';
import 'package:ecom_project/scrrens/product_detail_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';

class AppWidget {
  static mainHeading({
    required String text,
    double fontSize = 50,
    double letterSpacing = 1.0,
    FontWeight fontWeight = FontWeight.w400,
    Color color = AppColors.blackColor,
  }) {
    return Text(
      text,
      style: TextStyle(
        fontFamily: "PlayfairDisplay",
        fontSize: fontSize,
        fontWeight: fontWeight,
        color: color,
        letterSpacing: letterSpacing,
      ),
    );
  }

  static customAppbar({required String title, bool showBackButton = false}) {
    return AppBar(
      scrolledUnderElevation: 0,
      centerTitle: true,
      leading: showBackButton
          ? GestureDetector(
              onTap: () => Get.back(),
              child: Icon(Icons.arrow_back_ios_new_rounded, size: 24),
            )
          : SizedBox(),
      title: AppWidget.mainHeading(
        text: title,
        fontSize: 24,
        fontWeight: FontWeight.w600,
      ),
      backgroundColor: Colors.white,
      elevation: 0,
      // iconTheme: const IconThemeData(color: AppColors.blackColor),
    );
  }

  static largeTitle({
    required String text,
    double fontSize = 16,
    FontWeight fontWeight = FontWeight.w600,
    Color color = AppColors.blackColor,
  }) {
    return Text(
      text,
      style: TextStyle(
        fontSize: fontSize,
        fontWeight: fontWeight,
        color: color,
      ),
    );
  }

  static Widget starRating({
    required double rating,
    double starSize = 16,
    Color starColor = AppColors.yellowStarColor,
    Color emptyStarColor = Colors.grey,
    int totalStars = 5,
  }) {
    return Row(
      children: List.generate(totalStars, (index) {
        if (index < rating.floor()) {
          // Full star
          return Icon(Icons.star, size: starSize, color: starColor);
        } else if (index == rating.floor() && rating % 1 != 0) {
          // Half star
          return Icon(Icons.star_half, size: starSize, color: starColor);
        } else {
          // Empty star
          return Icon(Icons.star_border, size: starSize, color: emptyStarColor);
        }
      }),
    );
  }

  static Widget searchTextField({
    required Function(String) onChanged,
    String hintText = 'Search...',
    TextEditingController? controller,
    EdgeInsets margin = const EdgeInsets.all(16),
  }) {
    return Container(
      margin: margin,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(5),
        border: Border.all(color: Colors.black, width: 1),
      ),
      child: IntrinsicHeight(
        child: TextField(
          controller: controller,
          onChanged: onChanged,
          cursorColor: AppColors.blackColor,
          style: const TextStyle(fontSize: 14),
          decoration: InputDecoration(
            hintText: hintText,
            hintStyle: const TextStyle(color: Colors.grey, fontSize: 14),
            prefixIcon: const Icon(Icons.search, size: 20),
            prefixIconConstraints: const BoxConstraints(
              minWidth: 40,
              minHeight: 33,
            ),
            border: InputBorder.none,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 10,
            ),
            isDense: true,
          ),
        ),
      ),
    );
  }

  static noInternetConnetion({required GestureTapCallback onTap}) {
    return SizedBox(
      width: double.infinity,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Lottie.asset("assets/lottie/No Internet Connection.json"),
          GestureDetector(
            onTap: onTap,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              decoration: BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                "Refresh",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Custom RefreshIndicator with black background and white icon
  static Widget customRefreshIndicator({
    required Widget child,
    required Future<void> Function() onRefresh,
    Color backgroundColor = Colors.black,
    Color color = Colors.white,
    double strokeWidth = 2.0,
  }) {
    return RefreshIndicator(
      onRefresh: onRefresh,
      backgroundColor: backgroundColor,
      color: color,
      strokeWidth: strokeWidth,
      child: child,
    );
  }

  static productCard(Product product) {
    return GestureDetector(
      onTap: () {
        Get.to(() => ProductDetailScreen(currentProduct: product));
      },
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 6),
        padding: EdgeInsets.fromLTRB(10, 0, 10, 10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: const BorderRadius.vertical(bottom: Radius.circular(5)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 1,
              offset: const Offset(-2, 1),
            ),
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 1,
              offset: const Offset(1, 1),
            ),
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 1,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: double.infinity,
              height: 200,
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.vertical(
                  bottom: Radius.circular(5),
                ),
              ),
              child: product.thumbnail.isNotEmpty
                  ? Image.network(
                      product.thumbnail,
                      fit: BoxFit.contain,
                      errorBuilder: (context, error, stackTrace) {
                        return const Center(
                          child: Icon(
                            Icons.image,
                            size: 40,
                            color: Colors.grey,
                          ),
                        );
                      },
                    )
                  : const Center(
                      child: Icon(Icons.image, size: 40, color: Colors.grey),
                    ),
            ),

            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Text(
                          product.title,
                          style: const TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 14,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const SizedBox(width: 12),
                      AppWidget.largeTitle(text: product.formattedPrice),
                    ],
                  ),

                  // Rating with stars
                  Row(
                    children: [
                      Text(
                        product.rating.toString(),
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(width: 8),
                      AppWidget.starRating(
                        rating: product.rating,
                        starSize: 11,
                      ),
                    ],
                  ),

                  const SizedBox(height: 4),

                  // Brand
                  Text(
                    'By ${product.brand}',
                    style: TextStyle(
                      fontSize: 10,
                      color: Color(0xff0C0C0C).withOpacity(0.40),
                      fontWeight: FontWeight.w400,
                    ),
                  ),

                  const SizedBox(height: 8),

                  // Category
                  Text(
                    'In ${product.category}',
                    style: TextStyle(fontSize: 10, fontWeight: FontWeight.w400),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
