import 'package:ecom_project/services/app_widget.dart';
import 'package:flutter/material.dart';
import 'package:ecom_project/constants/app_colors.dart';

class UserScreen extends StatefulWidget {
  const UserScreen({super.key});

  @override
  State<UserScreen> createState() => _UserScreenState();
}

class _UserScreenState extends State<UserScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: AppWidget.mainHeading(
          text: 'Mitt konto',
          fontSize: 24,
          fontWeight: FontWeight.w600,
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: AppColors.blackColor),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),

          child: Column(
            children: [
              const SizedBox(height: 20),

              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(15),
                decoration: BoxDecoration(
                  color: AppColors.blackColor,
                  borderRadius: BorderRadius.circular(5),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 62,
                      height: 62,
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.person,
                        size: 40,
                        color: AppColors.blackColor,
                      ),
                    ),

                    const SizedBox(width: 15),

                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          AppWidget.largeTitle(
                            fontSize: 14,
                            text: "Muhammad Asad Faiz",
                            color: AppColors.whiteColor,
                          ),

                          const SizedBox(height: 4),
                          AppWidget.largeTitle(
                            text: "MuhammadAsadFaiz2000@gmail.com",
                            color: AppColors.whiteColor,
                            fontSize: 10,
                            fontWeight: FontWeight.w400,
                          ),

                          const SizedBox(height: 4),

                          AppWidget.largeTitle(
                            text: "07XXXXXXXX",
                            color: AppColors.whiteColor,
                            fontSize: 10,
                            fontWeight: FontWeight.w400,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 30),

              Container(
                padding: const EdgeInsets.only(top: 10),
                child: Column(
                  children: [
                    menuItem(
                      icon: "ic_setting.png",
                      title: "Kontoinstallningar",
                      onTap: () {},
                    ),
                    menuItem(
                      icon: "ic_cash.png",
                      title: "Mina betalmetoder",
                      onTap: () {},
                    ),
                    menuItem(
                      icon: "ic_support.png",
                      title: "Support",
                      onTap: () {},
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  menuItem({
    required String icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: Row(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Image.asset("assets/icons/$icon", width: 18, height: 18),
            ),
            AppWidget.largeTitle(
              text: title,
              color: AppColors.blackColor,
              fontSize: 14,
              fontWeight: FontWeight.w400,
            ),
          ],
        ),
      ),
    );
  }
}
