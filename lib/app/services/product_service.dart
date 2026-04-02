import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:ruang_rasa_mobile/app/data/models/branch_model.dart';
import 'package:ruang_rasa_mobile/app/data/models/product_model.dart';
import 'package:ruang_rasa_mobile/app/utils/api.dart';

class ProductService {
  // =====================
  // GET PRODUCTS
  // =====================
  static Future<List<ProductModel>> getProducts(int? branchId) async {
    try {
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
        final body = json.decode(response.body);

        if (body['success'] == true) {
          return (body['data'] as List)
              .map((e) => ProductModel.fromJson(e))
              .toList();
        } else {
          throw Exception(body['message'] ?? "Gagal ambil produk");
        }
      } else {
        throw Exception("Server error: ${response.statusCode}");
      }
    } catch (e) {
      throw Exception("Error getProducts: $e");
    }
  }

  // =====================
  // GET BRANCHES
  // =====================
  static Future<List<BranchModel>> getBranches() async {
    try {
      final response = await http.get(
        Uri.parse(BaseUrl.cabang),
        headers: BaseUrl.defaultHeaders,
      );

      if (response.statusCode == BaseUrl.success) {
        final body = json.decode(response.body);

        if (body['success'] == true) {
          return (body['data'] as List)
              .map((e) => BranchModel.fromJson(e))
              .toList();
        } else {
          throw Exception(body['message'] ?? "Gagal ambil cabang");
        }
      } else {
        throw Exception("Server error: ${response.statusCode}");
      }
    } catch (e) {
      throw Exception("Error getBranches: $e");
    }
  }
}