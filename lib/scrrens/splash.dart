import 'package:ecom_project/constants/app_colors.dart';
import 'package:ecom_project/services/app_widget.dart';
import 'package:flutter/material.dart';
import 'bottom_nav_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _navigateToHome();
  }

  Future<void> _navigateToHome() async {
    await Future.delayed(const Duration(seconds: 3));

    if (mounted) {
      Navigator.of(context).pushReplacement(
        PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) =>
              const BottomNavScreen(),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return FadeTransition(opacity: animation, child: child);
          },
          transitionDuration: const Duration(milliseconds: 500),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/splash.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: Container(
          decoration: BoxDecoration(gradient: AppGradients.primaryGradient),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 60, vertical: 30),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                AppWidget.mainHeading(text: 'My Store'),

                Padding(
                  padding: EdgeInsets.only(
                    bottom: MediaQuery.sizeOf(context).width * 0.25,
                  ),
                  child: Column(
                    children: [
                      Text(
                        'Valkommen',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: AppColors.whiteColor,
                          letterSpacing: 0.5,
                        ),
                        textAlign: TextAlign.center,
                      ),

                      const SizedBox(height: 20),

                      Text(
                        'Hos ass kan du baka tid has nastan alla Sveriges salonger och motagningar. Baka frisor, massage, skonhetsbehandingar, friskvard och mycket mer.',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w400,
                          color: AppColors.whiteColor,
                          height: 1.4,
                          letterSpacing: 0.3,
                        ),
                        textAlign: TextAlign.center,
                        // maxLines: 4,
                      ),
                    ],
                  ),
                ), // Spacer(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
