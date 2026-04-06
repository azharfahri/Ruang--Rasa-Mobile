import 'package:get/get.dart';

import '../controllers/order_succes_controller.dart';

class OrderSuccesBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<OrderSuccesController>(
      () => OrderSuccesController(),
    );
  }
}
