import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:ruang_rasa_mobile/app/data/models/branch_model.dart';
import 'package:ruang_rasa_mobile/app/data/models/product_model.dart';
import 'package:ruang_rasa_mobile/app/services/product_service.dart';

class HomeController extends GetxController {
  var isLoading = false.obs;

  // Data dari API
  var listCabang = <BranchModel>[].obs;
  var listProduk = <ProductModel>[].obs;

  // State pilihan user
  var selectedCabangId = RxnInt();

  @override
  void onInit() {
    super.onInit();
    fetchDataAwal();
  }

  // =====================
  // FETCH DATA AWAL
  // =====================
  Future<void> fetchDataAwal() async {
    isLoading(true);
    try {
      // 1. Ambil cabang dari service
      final branches = await ProductService.getBranches();
      listCabang.assignAll(branches);

      // 2. Set default cabang pertama
      if (listCabang.isNotEmpty) {
        selectedCabangId.value = listCabang[0].id;

        // 3. Ambil produk berdasarkan cabang
        final products = await ProductService.getProducts(
          selectedCabangId.value,
        );

        listProduk.assignAll(products);
      }
    } catch (e) {
      Get.snackbar(
        "Error",
        "Gagal memuat data: $e",
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading(false);
    }
  }

  // =====================
  // CHANGE CABANG
  // =====================
  void changeCabang(int? id) {
    if (id != null) {
      selectedCabangId.value = id;

      isLoading(true);

      ProductService.getProducts(id).then((products) {
        listProduk.assignAll(products);

        isLoading(false);

        Get.snackbar(
          "Cabang Berhasil Diganti",
          "Menu diperbarui sesuai lokasi pilihannmu",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: const Color(0xFFF9BC60),
          colorText: const Color(0xFF001E1D),
        );
      }).catchError((e) {
        isLoading(false);
        Get.snackbar("Error", "Gagal ambil produk");
      });
    }
  }
}