import 'dart:developer';
import 'dart:io';

import 'package:get/get.dart';
import '../models/product.dart';
import '../models/category.dart';
import '../services/api_service.dart';

class HomeController extends GetxController {
  final ApiService _apiService = ApiService();

  RxList<Product> products = <Product>[].obs;
  RxList<Category> categories = <Category>[].obs;
  RxList<Product> favourites = <Product>[].obs;
  RxList<Product> categoryProducts = <Product>[].obs;
  RxBool isLoading = false.obs;
  RxBool hasInternetConnection = true.obs;

  Future<bool> checkInternetConnection() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      hasInternetConnection.value =
          result.isNotEmpty && result[0].rawAddress.isNotEmpty;
      return hasInternetConnection.value;
    } on SocketException catch (_) {
      hasInternetConnection.value = false;
      return false;
    }
  }

  Future<void> getAllProducts({int limit = 100}) async {
    // Check internet connection first
    if (!await checkInternetConnection()) {
      isLoading.value = false;
      return;
    }

    products.clear();
    try {
      isLoading.value = true;

      final result = await _apiService.getProducts(limit: limit);
      products.value = result;

      // print(' Loaded ${products.length} products successfully');
    } catch (e) {
      // print(' Error loading products: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<Product?> getProductById(int id) async {
    try {
      isLoading.value = true;

      final result = await _apiService.getProductById(id);

      // Update the product in the list if it exists
      final index = products.indexWhere((p) => p.id == id);
      if (index != -1) {
        products[index] = result;
        products.refresh();
      }

      // print(' Loaded product ${result.title} successfully');
      return result;
    } catch (e) {
      // print(' Error loading product: $e');
      return null;
    } finally {
      isLoading.value = false;
    }
  }

  void toggleFavourite(int productId) {
    try {
      // First check in products list
      Product? product = products.firstWhereOrNull((p) => p.id == productId);

      // If not found in products, check in categoryProducts
      product ??= categoryProducts.firstWhereOrNull((p) => p.id == productId);

      if (product != null) {
        if (favourites.any((p) => p.id == productId)) {
          // Remove from favourites
          favourites.removeWhere((p) => p.id == productId);
          log('Product "${product.title}" removed from favourites');
        } else {
          // Add to favourites
          favourites.add(product);
          log('Product "${product.title}" added to favourites');
        }
      } else {
        log('Product with ID $productId not found in any list');
      }
    } catch (e) {
      log('Error toggling favourite: $e');
    }
  }

  //--------------- CATEGORY METHODS -------------------

  Future<void> getAllCategories() async {
    if (!await checkInternetConnection()) {
      isLoading.value = false;
      return;
    }

    categories.clear();
    try {
      isLoading.value = true;
      final result = await _apiService.getCategories();
      categories.value = result;

      log(' Loaded ${categories.length} categories successfully');
    } catch (e) {
      log(' Error loading categories: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> getProductsByCategory(String categorySlug) async {
    if (!await checkInternetConnection()) {
      isLoading.value = false;
      return;
    }

    categoryProducts.clear();
    try {
      isLoading.value = true;

      final result = await _apiService.getProductsByCategory(categorySlug);

      categoryProducts.value = result;

      log(
        'Loaded ${categoryProducts.length} products for category: $categorySlug',
      );
    } catch (e) {
      log(' Error loading category products: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> refreshProducts() async {
    await Future.wait([getAllProducts(), getAllCategories()]);
  }

  Future<void> refreshCategories() async {
    await Future.wait([getAllProducts(), getAllCategories()]);
  }

  bool isProductFavourite(int productId) {
    return favourites.any((p) => p.id == productId);
  }

  void clearAllFavourites() {
    favourites.clear();
    log('All favourites cleared');
  }
}
