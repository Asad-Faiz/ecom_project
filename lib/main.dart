import 'package:ecom_project/scrrens/bottom_nav_screen.dart';
import 'package:ecom_project/scrrens/splash.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Ecom Store',
      theme: ThemeData(fontFamily: GoogleFonts.poppins().fontFamily),
      home: const SplashScreen(),
    );
  }
}
