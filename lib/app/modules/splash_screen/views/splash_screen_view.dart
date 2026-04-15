import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/splash_screen_controller.dart';

class SplashScreenView extends GetView<SplashScreenController> {
  const SplashScreenView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF004643), // bgColor kamu
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Logo / Icon
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: const Color(0xFF001E1D), // cardColor untuk kontras sedikit
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Icon(
                Icons.local_cafe_rounded, 
                size: 80,
                color: Color(0xFFF9BC60), // accentColor (Gold)
              ),
            ),
            const SizedBox(height: 30),
            
            // Nama Brand
            const Text(
              'Ruang Rasa',
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: Color(0xFFFFFFFE), // textColor (Putih Bersih)
                letterSpacing: 1.5,
              ),
            ),
            
            // Tagline
            const Text(
              'Menikmati Rasa dalam Ruang',
              style: TextStyle(
                fontSize: 14,
                color: Color(0xFFABD1C6), // secondaryTextColor
                letterSpacing: 1.2,
              ),
            ),
            
            const SizedBox(height: 50),
            
            // Loading
            const SizedBox(
              width: 25,
              height: 25,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                valueColor: AlwaysStoppedAnimation<Color>(Color(0xFFF9BC60)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}