import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:ruang_rasa_mobile/app/data/models/branch_model.dart';
import 'package:ruang_rasa_mobile/app/data/models/category_group_model.dart';
import 'package:ruang_rasa_mobile/app/data/models/category_model.dart';
import 'package:ruang_rasa_mobile/app/data/models/product_model.dart';
import 'package:ruang_rasa_mobile/app/services/product_service.dart';
import 'package:ruang_rasa_mobile/app/utils/api.dart';

class ProductController extends GetxController {
  var isLoading = true.obs;

  var allProductsWithCategories = <CategoryGroupModel>[].obs;
  var branchList = <BranchModel>[].obs;
  var selectedBranchData = Rxn<BranchModel>();

  var selectedBranchId = RxnInt();
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
      // 1. FETCH CABANG (dari service)
      // =====================
      final branches = await ProductService.getBranches();
      branchList.assignAll(branches);

      if (selectedBranchId.value == null && branchList.isNotEmpty) {
        selectedBranchId.value = branchList[0].id;
        selectedBranchData.value = branchList[0];
      }

      // =====================
      // 2. FETCH PRODUK (dari service)
      // =====================
      List<ProductModel> products = await ProductService.getProducts(
        selectedBranchId.value,
      );

      // =====================
      // 3. GROUP BY CATEGORY
      // =====================
      Map<String, List<ProductModel>> grouped = {};

      for (var p in products) {
        String catName = p.category?.name ?? "Lainnya";

        if (!grouped.containsKey(catName)) {
          grouped[catName] = [];
        }

        grouped[catName]!.add(p);
      }

      List<CategoryGroupModel> result = [];

      grouped.forEach((key, value) {
        result.add(
          CategoryGroupModel(
            category: CategoryModel(name: key),
            products: value,
          ),
        );
      });

      allProductsWithCategories.assignAll(result);
      // =====================
      // 4. MAP INDEX SCROLL
      // =====================
      categoryIndexMap.clear();

      for (int i = 0; i < result.length; i++) {
        categoryIndexMap[result[i].category.name ?? ""] = i;
      }
    } catch (e) {
      print("ERROR PRODUCT: $e");
    } finally {
      isLoading(false);
    }
  }

  void changeBranch(BranchModel branch) {
    selectedBranchId.value = branch.id;
    selectedBranchData.value = branch;

    Get.back();
    fetchInitialData();
  }

  void scrollToCategory(String categoryName) {
    int? index = categoryIndexMap[categoryName];

    if (index != null) {
      scrollController.animateTo(
        index * 350,
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOut,
      );
    }
  }
}
