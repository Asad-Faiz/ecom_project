import 'dart:developer';

import 'package:get/get.dart';
import '../models/product.dart';
import '../models/category.dart';
import '../services/api_service.dart';

class HomeController extends GetxController {
  final ApiService _apiService = ApiService();

  RxList<Product> products = <Product>[].obs;
  RxList<Category> categories = <Category>[].obs;
  RxList<Product> favourites = <Product>[].obs;
  // UI states
  RxBool isLoading = false.obs;
  RxString errorMessage = ''.obs;
  RxString selectedCategory = ''.obs;

  // Computed properties

  List<Product> get productsByCategory {
    if (selectedCategory.value.isEmpty) return products;
    return products.where((p) => p.category == selectedCategory.value).toList();
  }

  // @override
  // void onInit() {
  //   super.onInit();
  //   getAllCategories();
  // }

  Future<void> getAllProducts({int limit = 100}) async {
    
    try {
      isLoading.value = true;
      errorMessage.value = '';

      final result = await _apiService.getProducts(limit: limit);
      products.value = result;

      log(' Loaded ${products.length} products successfully');
    } catch (e) {
      errorMessage.value = 'Failed to load products: $e';
      log(' Error loading products: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<Product?> getProductById(int id) async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      final result = await _apiService.getProductById(id);

      // Update the product in the list if it exists
      final index = products.indexWhere((p) => p.id == id);
      if (index != -1) {
        products[index] = result;
        products.refresh();
      }

      print('✅ Loaded product ${result.title} successfully');
      return result;
    } catch (e) {
      errorMessage.value = 'Failed to load product: $e';
      print('❌ Error loading product: $e');
      return null;
    } finally {
      isLoading.value = false;
    }
  }

  void toggleFavourite(int productId) {
    try {
      final product = products.firstWhereOrNull((p) => p.id == productId);
      if (product != null) {
        if (favourites.any((p) => p.id == productId)) {
          // Remove from favourites
          favourites.removeWhere((p) => p.id == productId);
          log('✅ Product "${product.title}" removed from favourites');
        } else {
          // Add to favourites
          favourites.add(product);
          log('✅ Product "${product.title}" added to favourites');
        }
      }
    } catch (e) {
      log('❌ Error toggling favourite: $e');
    }
  }

  void addToFavourites(int productId) {
    try {
      final product = products.firstWhereOrNull((p) => p.id == productId);
      if (product != null && !favourites.any((p) => p.id == productId)) {
        favourites.add(product);
        log(' Product "${product.title}" added to favourites');
      }
    } catch (e) {
      log('Error adding to favourites: $e');
    }
  }

  void removeFromFavourites(int productId) {
    try {
      favourites.removeWhere((p) => p.id == productId);
      log('Product removed from favourites');
    } catch (e) {
      log(' Error removing from favourites: $e');
    }
  }

  // ------------------- CATEGORY METHODS -------------------

  Future<void> getAllCategories() async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      final result = await _apiService.getCategories();
      categories.value = result;

      log(' Loaded ${categories.length} categories successfully');
    } catch (e) {
      errorMessage.value = 'Failed to load categories: $e';
      log(' Error loading categories: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> getProductsByCategory(String categorySlug) async {
    try {
      isLoading.value = true;
      errorMessage.value = '';
      selectedCategory.value = categorySlug;

      final result = await _apiService.getProductsByCategory(categorySlug);

      products.value = result;

      log('Loaded ${products.length} products for category: $categorySlug');
    } catch (e) {
      errorMessage.value = 'Failed to load category products: $e';
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
