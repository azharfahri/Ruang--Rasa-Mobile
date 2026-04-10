import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'package:ruang_rasa_mobile/app/modules/profile/controllers/profile_controller.dart';
import 'package:ruang_rasa_mobile/app/routes/app_pages.dart';
import 'package:ruang_rasa_mobile/app/utils/api.dart';

class EditprofileController extends GetxController {
  final box = GetStorage();

  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  var isLoading = false.obs;

  // Gunakan getter agar selalu mengambil data terbaru dari storage
  String get currentToken => box.read('token') ?? '';

  @override
  void onInit() {
    super.onInit();
    
    if (currentToken.isNotEmpty) {
      fetchProfile();
    } else {
      // Delay sedikit agar view siap menerima snackbar
      Future.delayed(Duration.zero, () {
        Get.snackbar("Error", "Sesi berakhir, silakan login kembali.");
      });
    }
  }

  Future<void> fetchProfile() async {
    try {
      isLoading.value = true;
      final response = await http.get(
        Uri.parse(BaseUrl.profile),
        headers: {
          'Authorization': 'Bearer $currentToken', // Pastikan formatnya Bearer
          'Accept': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        nameController.text = data['name'] ?? '';
        emailController.text = data['email'] ?? '';
      } else if (response.statusCode == 401) {
        Get.snackbar("Sesi Berakhir", "Silakan login ulang.");
      } else {
        Get.snackbar("Error", "Gagal mengambil data (${response.statusCode})");
      }
    } catch (e) {
      Get.snackbar("Error", "Koneksi bermasalah: $e");
    } finally {
      isLoading.value = false;
    }
  }

 Future<void> updateProfile() async {
  if (currentToken.isEmpty) return;
  
  isLoading.value = true;
  try {
    final response = await http.post(
      Uri.parse(BaseUrl.updateProfile),
      headers: {
        'Authorization': 'Bearer $currentToken',
        'Accept': 'application/json',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'name': nameController.text,
        'email': emailController.text,
        if (passwordController.text.isNotEmpty) 'password': passwordController.text,
      }),
    );

    if (response.statusCode == 200) {
      // 1. Refresh data di controller lain (opsional tapi disarankan)
      if (Get.isRegistered<ProfileController>()) {
        Get.find<ProfileController>().fetchProfile(); 
      }

      // 2. Pindah halaman (Pilih salah satu di bawah ini)
      

      // Opsi B: Hanya kembali ke satu halaman sebelumnya (Profile)
      Get.back();

      // 3. Munculkan snackbar setelah pindah (pakai delay agar muncul di halaman baru)
      Future.delayed(const Duration(milliseconds: 600), () {
        Get.snackbar(
          "Sukses", 
          "Profil Ruang Rasa berhasil diperbarui",
          backgroundColor: const Color(0xFF004643),
          colorText: Colors.white,
        );
      });
      
    } else {
      final data = jsonDecode(response.body);
      Get.snackbar("Gagal", data['message'] ?? "Terjadi kesalahan");
    }
  } catch (e) {
    Get.snackbar("Error", "Gagal terhubung ke server");
  } finally {
    isLoading.value = false;
  }
}

  @override
  void onClose() {
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    super.onClose();
  }
}