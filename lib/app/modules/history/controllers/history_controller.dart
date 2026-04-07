import 'dart:convert';

import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'package:ruang_rasa_mobile/app/data/models/order_model.dart';
import 'package:ruang_rasa_mobile/app/utils/api.dart';

class HistoryController extends GetxController {
  var isLoading = false.obs;
  var orders = <OrderModel>[].obs;
  final box = GetStorage();

  @override
  void onInit() {
    fetchHistory();
    super.onInit();
  }

  Future<void> fetchHistory() async {
    try {
      isLoading(true);
      final token = box.read('token');

      // Gunakan BaseUrl.orders di sini
      final response = await http.get(
        Uri.parse(BaseUrl.orders),
        headers: BaseUrl.authHeaders(token),
      );

      

      final body = json.decode(response.body);

      if (response.statusCode == 200 && body['success'] == true) {
        final List data = body['data'];
        orders.value = data.map((e) => OrderModel.fromJson(e)).toList();
      } else {
        print("Gagal muat history: ${response.statusCode}");
      }
    } catch (e) {
      print("Error History: $e");
    } finally {
      isLoading(false);
    }
  }
}
