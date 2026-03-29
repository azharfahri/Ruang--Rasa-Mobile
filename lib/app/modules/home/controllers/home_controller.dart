import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:ruang_rasa_mobile/app/utils/api.dart';
import 'package:flutter/material.dart';

class HomeController extends GetxController {
  var isLoading = false.obs;
  
  // Data dari API
  var listCabang = <dynamic>[].obs;
  var listProduk = <dynamic>[].obs;
  
  // State pilihan user
  var selectedCabangId = RxnInt();

  @override
  void onInit() {
    super.onInit();
    fetchDataAwal();
  }

  // Fungsi utama untuk mengambil semua data secara berurutan
  Future<void> fetchDataAwal() async {
    isLoading(true);
    try {
      // 1. Ambil Data Cabang terlebih dahulu
      await fetchCabang();
      
      // 2. Jika cabang ditemukan, set default ke cabang pertama
      if (listCabang.isNotEmpty) {
        selectedCabangId.value = listCabang[0]['id'];
        // 3. Ambil produk yang terhubung ke cabang tersebut (via pivot)
        await fetchProduk(branchId: selectedCabangId.value);
      }
    } catch (e) {
      Get.snackbar("Error", "Gagal memuat data: $e", 
          backgroundColor: Colors.red, colorText: Colors.white);
    } finally {
      isLoading(false);
    }
  }

  // Fungsi Fetch Cabang
  Future<void> fetchCabang() async {
    final response = await http.get(
      Uri.parse(BaseUrl.cabang),
      headers: BaseUrl.defaultHeaders,
    );

    if (response.statusCode == BaseUrl.success) {
      var body = json.decode(response.body);
      if (body['success'] == true) {
        listCabang.assignAll(body['data']);
      }
    }
  }

  // Fungsi Fetch Produk dengan parameter branchId
  Future<void> fetchProduk({int? branchId}) async {
    // Membangun URL dengan query parameter ?branch_id=...
    final Uri url = Uri.parse(BaseUrl.produk).replace(
      queryParameters: {
        if (branchId != null) 'branch_id': branchId.toString(),
      },
    );

    final response = await http.get(
      url,
      headers: BaseUrl.defaultHeaders,
    );

    if (response.statusCode == BaseUrl.success) {
      var body = json.decode(response.body);
      if (body['success'] == true) {
        listProduk.assignAll(body['data']);
      }
    }
  }

  // Dipanggil saat dropdown di View berubah
  void changeCabang(int? id) {
    if (id != null) {
      selectedCabangId.value = id;
      
      // Ambil data ulang dari server untuk cabang yang dipilih
      isLoading(true);
      fetchProduk(branchId: id).then((_) {
        isLoading(false);
        Get.snackbar(
          "Cabang Berhasil Diganti", 
          "Menu diperbarui sesuai lokasi pilihannmu",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: const Color(0xFFF9BC60),
          colorText: const Color(0xFF001E1D),
        );
      });
    }
  }
}