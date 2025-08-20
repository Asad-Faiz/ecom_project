import 'dart:developer';

import 'package:dio/dio.dart';
import '../models/product.dart';
import '../models/category.dart';

class ApiService {
  static const String baseUrl = 'https://dummyjson.com';

  final Dio _dio = Dio();

  Future<List<Product>> getProducts({int limit = 100}) async {
    try {
      final response = await _dio.get('$baseUrl/products?limit=$limit');

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = response.data;
        final List<dynamic> productsList = data['products'];

        List<Product> products = [];
        for (var productJson in productsList) {
          try {
            Product product = Product.fromJson(productJson);
            products.add(product);
          } catch (e) {
            print('Error parsing product: $e');
            continue;
          }
        }

        return products;
      } else {
        throw Exception(
          'Failed to load products. Status: ${response.statusCode}',
        );
      }
    } catch (e) {
      print('Error getting products: $e');
      throw Exception('Failed to load products: $e');
    }
  }

  Future<Product> getProductById(int id) async {
    try {
      final response = await _dio.get('$baseUrl/products/$id');

      if (response.statusCode == 200) {
        final Map<String, dynamic> productJson = response.data;

        Product product = Product.fromJson(productJson);
        return product;
      } else if (response.statusCode == 404) {
        throw Exception('Product not found');
      } else {
        throw Exception(
          'Failed to load product. Status: ${response.statusCode}',
        );
      }
    } catch (e) {
      print('Error getting product $id: $e');
      throw Exception('Failed to load product: $e');
    }
  }

  Future<List<Category>> getCategories() async {
    try {
      final response = await _dio.get('$baseUrl/products/categories');

      if (response.statusCode == 200) {
        final List<dynamic> categoriesList = response.data;

        List<Category> categories = [];
        for (var categoryJson in categoriesList) {
          try {
            Category category = Category.fromJson(categoryJson);
            categories.add(category);
          } catch (e) {
            print('Error parsing category: $e');
            continue;
          }
        }

        return categories;
      } else {
        throw Exception(
          'Failed to load categories. Status: ${response.statusCode}',
        );
      }
    } catch (e) {
      print('Error getting categories: $e');
      throw Exception('Failed to load categories: $e');
    }
  }

  Future<List<Product>> getProductsByCategory(String categorySlug) async {
    try {
      final response = await _dio.get(
        '$baseUrl/products/category/$categorySlug',
      );

      if (response.statusCode == 200) {
        // log("response is ${response.data}");
        final Map<String, dynamic> data = response.data;
        final List<dynamic> productsList = data['products'];

        List<Product> products = [];
        for (var productJson in productsList) {
          try {
            Product product = Product.fromJson(productJson);
            products.add(product);
          } catch (e) {
            print('Error parsing product: $e');
            continue;
          }
        }

        return products;
      } else if (response.statusCode == 404) {
        throw Exception('Category not found');
      } else {
        throw Exception(
          'Failed to load category products. Status: ${response.statusCode}',
        );
      }
    } catch (e) {
      print('Error getting products for category $categorySlug: $e');
      throw Exception('Failed to load category products: $e');
    }
  }
}
