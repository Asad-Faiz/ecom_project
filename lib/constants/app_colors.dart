import 'package:flutter/material.dart';

class AppColors {
  static const whiteColor = Color(0xFFFFFFFF);
  static const blackColor = Color(0xFF000000);
 
}

class AppGradients {
  static final primaryGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [
      Colors.transparent,
      Colors.transparent,
      // Colors.black.withOpacity(0.7),
      Colors.black.withOpacity(0.8),
    ],
    // stops: const [0.0, 0.6, 1.4],
  );
}
