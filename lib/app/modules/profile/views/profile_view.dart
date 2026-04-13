import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ruang_rasa_mobile/app/data/models/profile_model.dart';
import 'package:ruang_rasa_mobile/app/modules/pengaturan/views/pengaturan_view.dart';
import '../controllers/profile_controller.dart';
import '../../auth/controllers/auth_controller.dart';

class ProfileView extends GetView<ProfileController> {
  const ProfileView({super.key});

  static const Color bgColor = Color(0xFF004643);
  static const Color accentColor = Color(0xFFF9BC60);
  static const Color textColor = Color(0xFFFFFFFE);
  static const Color cardColor = Color(0xFF001E1D);
  static const Color secondaryTextColor = Color(0xFFABD1C6);

  @override
  Widget build(BuildContext context) {
    final authC = Get.find<AuthController>();

    return Scaffold(
      backgroundColor: bgColor,
      body: Obx(() {
        if (!authC.isLoggedIn.value) {
          return _buildGuestView();
        }

        if (controller.isLoading.value) {
          return const Center(
            child: CircularProgressIndicator(color: accentColor),
          );
        }

        return _buildUserView(controller.profile.value);
      }),
    );
  }

  Widget _buildGuestView() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.person_outline, size: 80, color: accentColor),
          const SizedBox(height: 16),
          const Text(
            "Kamu belum login",
            style: TextStyle(
              color: textColor,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 10),
          const Text(
            "Masuk dulu biar bisa lihat profile kamu",
            style: TextStyle(color: secondaryTextColor),
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () => Get.toNamed('/login'),
            style: ElevatedButton.styleFrom(
              backgroundColor: accentColor,
              foregroundColor: bgColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
            ),
            child: const Text("Login"),
          ),
        ],
      ),
    );
  }

  Widget _buildUserView(ProfileModel? profile) {
    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: cardColor,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            children: [
              const CircleAvatar(
                radius: 40,
                backgroundColor: accentColor,
                child: Icon(Icons.person, size: 40, color: bgColor),
              ),
              const SizedBox(height: 12),
              Text(
                profile?.name ?? "User",
                style: const TextStyle(
                  color: textColor,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                profile?.email ?? "-",
                style: const TextStyle(color: secondaryTextColor),
              ),
            ],
          ),
        ),

        const SizedBox(height: 30),

        // Perubahan di sini: Menambahkan navigasi ke History
        _buildMenuItem(
          Icons.history,
          "Riwayat Pesanan",
          onTap: () =>
              Get.toNamed('/history'), // Sesuaikan dengan route history kamu
        ),

        _buildMenuItem(
          Icons.settings,
          "Pengaturan",
          onTap: () {
            Get.to(() => const PengaturanPage());
          },
        ),

        // _buildMenuItem(
        //   Icons.help_outline,
        //   "Bantuan",
        //   onTap: () {
        //     // Navigasi bantuan jika ada
        //   },
        // ),

        const SizedBox(height: 30),

        ElevatedButton(
          onPressed: () {
            Get.find<AuthController>().logout();
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.red,
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
          ),
          child: const Text("Logout"),
        ),
      ],
    );
  }

  // Menambahkan parameter VoidCallback? onTap
  Widget _buildMenuItem(IconData icon, String title, {VoidCallback? onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: cardColor,
          borderRadius: BorderRadius.circular(15),
        ),
        child: Row(
          children: [
            Icon(icon, color: accentColor),
            const SizedBox(width: 12),
            Text(
              title,
              style: const TextStyle(
                color: textColor,
                fontWeight: FontWeight.w500,
              ),
            ),
            const Spacer(),
            const Icon(Icons.arrow_forward_ios, size: 14, color: textColor),
          ],
        ),
      ),
    );
  }
}
