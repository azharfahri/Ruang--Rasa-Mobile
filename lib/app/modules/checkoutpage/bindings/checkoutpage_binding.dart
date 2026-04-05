import 'package:get/get.dart';

import '../controllers/checkoutpage_controller.dart';

class CheckoutpageBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<CheckoutController>(
      () => CheckoutController(),
    );
  }
}


