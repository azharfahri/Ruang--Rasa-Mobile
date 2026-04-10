import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'package:ruang_rasa_mobile/app/modules/auth/controllers/auth_controller.dart';
import 'package:ruang_rasa_mobile/app/utils/api.dart';

class PengaturanController extends GetxController {
  final box = GetStorage();

  var isLoading = false.obs;

  String token = "";

  @override
  void onInit() {
    super.onInit();

    token = box.read('token') ?? '';

    print("TOKEN (Pengaturan): $token");

    if (token.isEmpty) {
      Get.snackbar("Error", "Token tidak ada, login ulang ya");
      Get.offAllNamed('/login');
    }
  }

  Future<void> deleteAccount() async {
    isLoading.value = true;

    try {
      final response = await http.delete(
        Uri.parse(BaseUrl.deleteAccount),
        headers: BaseUrl.authHeaders(token),
      );

      final data = jsonDecode(response.body);

      if (response.statusCode == 200) {
        // 1. Hapus token dari storage
        box.remove('token');

        // 2. Update state di AuthController agar UI (misal: Sidebar/Navbar) langsung berubah ke state Logout
        if (Get.isRegistered<AuthController>()) {
          Get.find<AuthController>().isLoggedIn.value = false;
        }

        // 3. Eksekusi pindah halaman terlebih dahulu untuk membersihkan stack
        Get.offAllNamed('/main');

        // 4. Munculkan snackbar setelah proses navigasi dimulai
        // Memberikan sedikit delay (misal 300ms) memastikan snackbar menempel di halaman baru ('/main')
        Future.delayed(const Duration(milliseconds: 300), () {
          Get.snackbar(
            "Sukses",
            data['message'] ?? "Akun berhasil dihapus",
            backgroundColor: const Color(0xFF004643), // Sesuai tema Ruang Rasa
            colorText: Colors.white,
            snackPosition: SnackPosition.TOP,
          );
        });
      } else {
        Get.snackbar("Error", data['message'] ?? "Gagal menghapus akun");
      }
    } catch (e) {
      Get.snackbar("Error", "Terjadi kesalahan koneksi");
    } finally {
      isLoading.value = false;
    }
  }
}
