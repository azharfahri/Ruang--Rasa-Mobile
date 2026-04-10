import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:ruang_rasa_mobile/app/modules/detail_produk/controllers/addcart_controller.dart';
import 'package:ruang_rasa_mobile/app/routes/app_pages.dart';
import 'package:ruang_rasa_mobile/app/services/auth_service.dart';
import 'package:ruang_rasa_mobile/app/utils/api.dart';

class AuthController extends GetxController {
  final AuthService api = AuthService();
  final box = GetStorage();

  RxBool isLoggedIn = false.obs;
  RxBool isLoading = false.obs;
  RxBool isPasswordHidden = true.obs;

  void togglePasswordVisibility() {
    isPasswordHidden.value = !isPasswordHidden.value;
  }

  @override
  void onInit() {
    super.onInit();
    isLoggedIn.value = box.hasData('token');
  }

  Future<void> login(String email, String password) async {
    if (email.isEmpty || password.isEmpty) {
      Get.snackbar(
        'Login gagal',
        'Email dan password wajib diisi',
        backgroundColor: const Color(0xFFF9BC60),
        colorText: const Color(0xFF001E1D),
        snackPosition: SnackPosition.TOP,
      );
      return;
    }

    try {
      isLoading.value = true;

      final response = await api
          .login(email, password)
          .timeout(const Duration(seconds: 10));

      // ===== ERROR HANDLING =====
      if (response.hasError || response.statusCode != 200) {
        final body = response.body;

        if (response.statusCode == 401) {
          Get.snackbar(
            'Login gagal',
            'Email atau password salah',
            backgroundColor: const Color(0xFFE16162),
            colorText: Colors.white,
          );
          return;
        }

        if (response.statusCode == 422 && body != null) {
          final errors = body['errors'];
          Get.snackbar(
            'Data tidak valid',
            errors?.values.first[0] ?? 'Input tidak valid',
            backgroundColor: const Color(0xFFF9BC60),
            colorText: const Color(0xFF001E1D),
          );
          return;
        }

        Get.snackbar(
          'Login gagal',
          body?['message'] ?? 'Akun tidak ditemukan',
          backgroundColor: const Color(0xFFE16162),
          colorText: Colors.white,
        );
        return;
      }

      // ===== LOGIN SUKSES =====
      final token = response.body['token'];
      box.write('token', token);
      box.write('user_id', response.body['user']['id']);

      final cart = Get.find<CartController>();
      cart.loadCart();
      isLoggedIn.value = true;

      // Pindah halaman dulu
      Get.offAllNamed(Routes.MAIN);

      // Munculkan snackbar setelah navigasi selesai
      Future.delayed(const Duration(milliseconds: 600), () {
        Get.snackbar(
          'Selamat datang',
          'Berhasil masuk ke Ruang Rasa',
          backgroundColor: const Color(0xFF004643),
          colorText: Colors.white,
          snackPosition: SnackPosition.TOP,
        );
      });

    } catch (_) {
      Get.snackbar(
        'Koneksi bermasalah',
        'Server tidak merespon',
        backgroundColor: Colors.black,
        colorText: Colors.white,
        snackPosition: SnackPosition.TOP,
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> register(String name, String email, String password) async {
    try {
      isLoading.value = true;

      final response = await api.register(name, email, password);

      if (response.statusCode == BaseUrl.created) {
        // Balik ke login
        Get.offAllNamed(Routes.LOGIN);

        // Delay snackbar
        Future.delayed(const Duration(milliseconds: 600), () {
          Get.snackbar(
            'Akun berhasil dibuat',
            'Silakan login dan nikmati Ruang Rasa',
            backgroundColor: const Color(0xFF004643),
            colorText: Colors.white,
            snackPosition: SnackPosition.TOP,
          );
        });
      } else if (response.statusCode == BaseUrl.unprocessableEntity) {
        final errors = response.body['errors'];
        Get.snackbar(
          'Data tidak valid',
          errors.values.first[0],
          backgroundColor: const Color(0xFFF9BC60),
          colorText: const Color(0xFF001E1D),
          snackPosition: SnackPosition.TOP,
        );
      } else {
        Get.snackbar(
          'Gagal daftar',
          response.body['message'] ?? 'Terjadi kesalahan',
          backgroundColor: const Color(0xFFE16162),
          colorText: Colors.white,
          snackPosition: SnackPosition.TOP,
        );
      }
    } catch (e) {
      Get.snackbar(
        'Koneksi bermasalah',
        'Tidak dapat terhubung ke server',
        backgroundColor: Colors.black,
        colorText: Colors.white,
        snackPosition: SnackPosition.TOP,
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> logout() async {
    try {
      isLoading.value = true;
      final token = box.read('token');

      if (token != null) {
        await api.logout(token);
        box.remove('token');
      }

      isLoggedIn.value = false;

      final cart = Get.find<CartController>();
      cart.items.clear();

      // Pindah ke halaman utama
      Get.offAllNamed(Routes.MAIN);

      // Delay snackbar
      Future.delayed(const Duration(milliseconds: 600), () {
        Get.snackbar(
          'Sampai jumpa',
          'Kamu keluar dari Ruang Rasa',
          backgroundColor: const Color(0xFF001E1D),
          colorText: const Color(0xFFABD1C6),
          snackPosition: SnackPosition.TOP,
        );
      });
    } catch (_) {
      box.remove('token');
      final cart = Get.find<CartController>();
      cart.items.clear();
      Get.offAllNamed(Routes.MAIN);
    } finally {
      isLoading.value = false;
    }
  }
}