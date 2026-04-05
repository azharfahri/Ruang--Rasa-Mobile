import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:get_storage/get_storage.dart';
import 'package:ruang_rasa_mobile/app/modules/detail_produk/controllers/addcart_controller.dart';
import 'package:ruang_rasa_mobile/app/services/product_service.dart';
import 'package:ruang_rasa_mobile/app/utils/api.dart';


class CheckoutController extends GetxController {
  var isLoading = false.obs;

  final cart = Get.find<CartController>();
  final box = GetStorage();

  Future<void> createOrder() async {
    try {
      isLoading(true);

      final token = box.read('token');

      final response = await http.post(
        Uri.parse(BaseUrl.base + "/orders"),
        headers: BaseUrl.authHeaders(token),
        body: jsonEncode({
          "branch_id": 1, // nanti bisa dinamis
          "payment_method": "cash",
          "items": cart.items.map((e) {
            return {
              "product_id": e.productId,
              "quantity": e.qty,
            };
          }).toList(),
        }),
      );

      print(response.body);

      if (response.statusCode == 200) {
        cart.clearCart();

        Get.offAllNamed('/order-success');

        Get.snackbar("Sukses", "Pesanan berhasil dibuat");
      }
    } catch (e) {
      Get.snackbar("Error", "Gagal checkout");
    } finally {
      isLoading(false);
    }
  }
}