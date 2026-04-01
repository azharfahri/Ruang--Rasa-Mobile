import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:ruang_rasa_mobile/app/utils/api.dart';

class ProductController extends GetxController {
  var isLoading = true.obs;

  var allProductsWithCategories = <dynamic>[].obs;
  var branchList = <dynamic>[].obs;

  var selectedBranchId = RxnInt();
  var selectedBranchData = {}.obs;
  var selectedCategorySlug = "".obs;

  final scrollController = ScrollController();
  var categoryIndexMap = <String, int>{}.obs;

  @override
  void onInit() {
    super.onInit();
    fetchInitialData();
  }

  Future<void> fetchInitialData() async {
    try {
      isLoading(true);

      // =====================
      // 1. FETCH CABANG
      // =====================
      final branchRes = await http.get(
        Uri.parse(BaseUrl.cabang),
        headers: BaseUrl.defaultHeaders,
      );

      if (branchRes.statusCode == BaseUrl.success) {
        var body = json.decode(branchRes.body);
        branchList.assignAll(body['data']);

        if (selectedBranchId.value == null && branchList.isNotEmpty) {
          selectedBranchId.value = branchList[0]['id'];
          selectedBranchData.value = branchList[0];
        }
      }

      // =====================
      // 2. FETCH PRODUK (SEPERTI HOME)
      // =====================
      final Uri url = Uri.parse(BaseUrl.produk).replace(
        queryParameters: {
          if (selectedBranchId.value != null)
            'branch_id': selectedBranchId.value.toString(),
        },
      );

      final productRes = await http.get(
        url,
        headers: BaseUrl.defaultHeaders,
      );

      if (productRes.statusCode == BaseUrl.success) {
        var body = json.decode(productRes.body);
        List products = body['data'];

        // format data
        for (var p in products) {
          p['price'] = int.tryParse(p['price'].toString()) ?? 0;

          String rawImage = p['image'] ?? "";
          if (rawImage.isNotEmpty && !rawImage.contains('http')) {
            String storageUrl = BaseUrl.base.replaceAll('/api', '/storage');
            p['image'] = "$storageUrl/$rawImage";
          }
        }

        // =====================
        // 3. GROUP BY CATEGORY
        // =====================
        Map<String, List> grouped = {};

        for (var p in products) {
          String catName = p['category']['name'] ?? "Lainnya";

          if (!grouped.containsKey(catName)) {
            grouped[catName] = [];
          }

          grouped[catName]!.add(p);
        }

        List result = [];

        grouped.forEach((key, value) {
          result.add({
            'category': {'name': key},
            'products': value,
          });
        });

        allProductsWithCategories.assignAll(result);

        // =====================
        // 4. MAP INDEX UNTUK SCROLL
        // =====================
        categoryIndexMap.clear();
        for (int i = 0; i < result.length; i++) {
          categoryIndexMap[result[i]['category']['name']] = i;
        }
      }
    } catch (e) {
      print("ERROR PRODUCT: $e");
    } finally {
      isLoading(false);
    }
  }

  void changeBranch(dynamic branch) {
    selectedBranchId.value = branch['id'];
    selectedBranchData.value = branch;

    Get.back();

    fetchInitialData();
  }

  // =====================
  // SCROLL KE KATEGORI
  // =====================
  void scrollToCategory(String categoryName) {
    int? index = categoryIndexMap[categoryName];

    if (index != null) {
      scrollController.animateTo(
        index * 350, // bisa kamu adjust nanti
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOut,
      );
    }
  }
}