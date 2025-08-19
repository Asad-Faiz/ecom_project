import 'package:ecom_project/constants/app_colors.dart';
import 'package:ecom_project/models/product.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

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
      style: GoogleFonts.playfairDisplay(
        fontSize: fontSize,
        fontWeight: fontWeight,
        color: color,
        letterSpacing: letterSpacing,
      ),
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

  static buildProductCard(Product product) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 6),
      padding: EdgeInsets.fromLTRB(10, 0, 10, 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.vertical(bottom: Radius.circular(5)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 4,
            offset: const Offset(-1, 1),
          ),
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 4,
            offset: const Offset(1, 1),
          ),
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 4,
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
            child: product.images.isNotEmpty
                ? Image.network(
                    product.images.first,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return const Center(
                        child: Icon(Icons.image, size: 40, color: Colors.grey),
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

                const SizedBox(height: 12),

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
                    Row(
                      children: List.generate(5, (index) {
                        if (index < product.rating.floor()) {
                          return Icon(
                            Icons.star,
                            size: 11,
                            color: Colors.amber.shade600,
                          );
                        } else if (index == product.rating.floor() &&
                            product.rating % 1 > 0) {
                          return Icon(
                            Icons.star_half,
                            size: 11,
                            color: Colors.amber.shade600,
                          );
                        } else {
                          return Icon(
                            Icons.star_border,
                            size: 11,
                            color: Colors.grey.shade400,
                          );
                        }
                      }),
                    ),
                  ],
                ),

                const SizedBox(height: 8),

                // Brand
                Text(
                  'By ${product.brand}',
                  style: TextStyle(
                    fontSize: 10,
                    color: Color(0xff0C0C0C).withOpacity(0.40),
                    fontWeight: FontWeight.w400,
                  ),
                ),

                const SizedBox(height: 4),

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
    );
  }
}
