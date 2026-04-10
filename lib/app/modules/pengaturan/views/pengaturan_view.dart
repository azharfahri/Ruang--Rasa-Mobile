import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/pengaturan_controller.dart';
import '../../editprofile/views/editprofile_view.dart';

class PengaturanPage extends StatelessWidget {
  const PengaturanPage({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(PengaturanController());

    return Scaffold(
      backgroundColor: const Color(0xFF0B5D53),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0B5D53),
        elevation: 0,
        title: const Text("Pengaturan"),
        centerTitle: true,
      ),
      body: Column(
        children: [
          const SizedBox(height: 20),

          // 🔹 EDIT PROFILE
          buildMenuItem(
            icon: Icons.edit,
            title: "Edit Profil",
            onTap: () {
              Get.to(() => const EditProfilePage());
            },
          ),

          // 🔹 HAPUS AKUN
          buildMenuItem(
            icon: Icons.delete,
            title: "Hapus Akun",
            color: Colors.red,
            onTap: () {
              Get.defaultDialog(
                title: "Hapus Akun",
                middleText:
                    "Yakin akan menghapus akun? Semua data kamu bakal hilang",
                textCancel: "Batal",
                textConfirm: "Hapus",
                confirmTextColor: Colors.white,
                buttonColor: Colors.red,
                onConfirm: () {
                  Get.back(); // tutup dialog
                  controller.deleteAccount();
                },
              );
            },
          ),
        ],
      ),
    );
  }

  Widget buildMenuItem({
    required IconData icon,
    required String title,
    Color? color,
    required VoidCallback onTap,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: const Color(0xFF063D35),
        borderRadius: BorderRadius.circular(16),
      ),
      child: ListTile(
        leading: Icon(icon, color: color ?? Colors.white),
        title: Text(
          title,
          style: TextStyle(color: color ?? Colors.white),
        ),
        trailing:
            const Icon(Icons.arrow_forward_ios, color: Colors.white, size: 16),
        onTap: onTap,
      ),
    );
  }
}