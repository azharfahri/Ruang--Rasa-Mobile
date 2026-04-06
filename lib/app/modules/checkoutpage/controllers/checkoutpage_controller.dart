import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:get_storage/get_storage.dart';
import 'package:ruang_rasa_mobile/app/modules/detail_produk/controllers/addcart_controller.dart';
import 'package:ruang_rasa_mobile/app/modules/home/controllers/home_controller.dart';
import 'package:ruang_rasa_mobile/app/utils/api.dart';

class CheckoutController extends GetxController {
  var isLoading = false.obs;

  final cart = Get.find<CartController>();
  final homeC = Get.find<HomeController>();
  final box = GetStorage();

  Future<void> createOrder() async {
    try {
      isLoading(true);

      final token = box.read('token');
      print(cart.items.map((e)=> e.variants).toList());

      final response = await http.post(
        Uri.parse(BaseUrl.base + "/orders"),
        headers: BaseUrl.authHeaders(token),
        body: jsonEncode({
          "branch_id": homeC.selectedCabangId.value,
          "payment_method": "cash",
          "items": cart.items.map((e) {
            return {
              "product_id": e.productId,
              "qty": e.qty,
              "details": e.variants ?? [],
            };
          }).toList(),
        }),
      );

      print(response.body);

      final body = json.decode(response.body);

      if (body['success'] == true) {
        final data = body['data'];

        cart.items.clear();
        cart.saveCart();

        Get.snackbar("Sukses", "Pesanan berhasil dibuat");

        Future.delayed(const Duration(milliseconds: 300), () {
          Get.offAllNamed('/order-success', arguments: data);
        });
      } else {
        Get.snackbar("Error", body['message'] ?? "Gagal checkout");
      }
    } catch (e) {
      Get.snackbar("Error", "Gagal checkout");
    } finally {
      isLoading(false);
    }
  }
}
