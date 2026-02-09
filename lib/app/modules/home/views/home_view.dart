import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../auth/controllers/auth_controller.dart';
import '../controllers/home_controller.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({super.key});

  // Palette Ruang Rasa
  static const Color bgColor = Color(0xFF004643);
  static const Color accentColor = Color(0xFFF9BC60);
  static const Color textColor = Color(0xFFFFFFFE);
  static const Color buttonTextColor = Color(0xFF001E1D);

  @override
  Widget build(BuildContext context) {
    final AuthController authC = Get.find<AuthController>();

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        title: const Text(
          'Ruang Rasa',
          style: TextStyle(color: textColor, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,

        actions: [
          Obx(() {
            // ===== JIKA SUDAH LOGIN → LOGOUT =====
            if (authC.isLoggedIn.value) {
              return IconButton(
                icon: const Icon(Icons.logout_rounded, color: accentColor),
                onPressed: () {
                  Get.defaultDialog(
                    title: 'Keluar?',
                    middleText: 'Kamu yakin mau keluar dari Ruang Rasa?',
                    textConfirm: 'Logout',
                    textCancel: 'Batal',
                    confirmTextColor: buttonTextColor,
                    cancelTextColor: Colors.grey,
                    buttonColor: accentColor,
                    onConfirm: () {
                      Get.back();
                      authC.logout();
                    },
                  );
                },
              );
            }

            // ===== JIKA BELUM LOGIN → TOMBOL MASUK =====
            return TextButton(
              onPressed: () {
                Get.toNamed('/login');
              },
              child: const Text(
                'Masuk',
                style: TextStyle(
                  color: accentColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
            );
          }),
        ],
      ),

      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Haloo ☕',
              style: TextStyle(
                fontSize: 26,
                color: textColor,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Selamat datang di Ruang Rasa.',
              style: TextStyle(color: Color(0xFFABD1C6), fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}
