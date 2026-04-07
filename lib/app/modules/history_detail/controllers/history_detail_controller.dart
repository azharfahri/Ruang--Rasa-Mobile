import 'package:get/get.dart';
import 'package:ruang_rasa_mobile/app/data/models/order_model.dart';

class HistoryDetailController extends GetxController {
  // Kita simpan data order di variabel observable
  late OrderModel order;

  @override
  void onInit() {
    super.onInit();
    // Menangkap argumen yang dikirim dari Get.toNamed
    order = Get.arguments;
  }
}