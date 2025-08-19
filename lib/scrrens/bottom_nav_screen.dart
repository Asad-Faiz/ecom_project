import 'package:ecom_project/controllers/home_controller.dart';
import 'package:flutter/material.dart';
import 'package:ecom_project/constants/app_colors.dart';
import 'package:get/get.dart';
import 'product_screen.dart';
import 'categories_screen.dart';
import 'favourites_screen.dart';
import 'user_screen.dart';

class BottomNavScreen extends StatefulWidget {
  const BottomNavScreen({super.key});

  @override
  State<BottomNavScreen> createState() => _BottomNavScreenState();
}

class _BottomNavScreenState extends State<BottomNavScreen> {
  final HomeController homeController = Get.put(HomeController());
  int _currentIndex = 0;

  // List of screens for each tab
  final List<Widget> _screens = [
    const ProductScreen(),
    const CategoriesScreen(),
    const FavouritesScreen(),
    const UserScreen(),
  ];

  // Navigation items 
  final List<Map<String, dynamic>> _navItems = [
    {'icon': 'assets/icons/ic_home.png', 'label': 'Product'},
    {'icon': 'assets/icons/ic_category.png', 'label': 'Categories'},
    {'icon': 'assets/icons/ic_fav.png', 'label': 'Favourites'},
    {'icon': 'assets/icons/ic_person.png', 'label': 'Mitt konto'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_currentIndex],
      bottomNavigationBar: Container(
        padding: const EdgeInsets.only(top: 10, bottom: 20),
        decoration: BoxDecoration(
          color: AppColors.blackColor,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(10),
            topRight: Radius.circular(10),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: List.generate(
            _navItems.length,
            (index) => _buildNavItem(index),
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(int index) {
    final isSelected = _currentIndex == index;
    final item = _navItems[index];

    return GestureDetector(
      onTap: () {
        setState(() {
          _currentIndex = index;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Icon
            Image.asset(
              item['icon'],
              width: 24,
              height: 24,
              color: AppColors.whiteColor,
            ),
            const SizedBox(height: 4),
            // Label
            Text(
              item['label'],
              style: TextStyle(
                fontSize: 10,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.w400,
                color: AppColors.whiteColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
