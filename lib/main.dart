import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:ruang_rasa_mobile/app/modules/auth/controllers/auth_controller.dart';
import 'package:ruang_rasa_mobile/app/modules/detail_produk/controllers/addcart_controller.dart';
import 'package:ruang_rasa_mobile/app/modules/editprofile/controllers/editprofile_controller.dart';
import 'package:ruang_rasa_mobile/app/modules/home/controllers/home_controller.dart';
import 'package:ruang_rasa_mobile/app/modules/product/controllers/product_controller.dart';
import 'package:ruang_rasa_mobile/app/modules/profile/controllers/profile_controller.dart';

import 'app/routes/app_pages.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await GetStorage.init();

  runApp(
    GetMaterialApp(
      title: "Ruang Rasa - Cafe Nyaman",
      initialRoute: '/main',
      getPages: AppPages.routes,
      debugShowCheckedModeBanner: false,
      // PINDAHKAN Get.put ke initialBinding
      initialBinding: BindingsBuilder(() {
        Get.put(AuthController());
        Get.put(HomeController());
        Get.put(CartController());
        Get.put(ProductController());
        Get.put(ProfileController());
        Get.put(EditprofileController());
      }),
      theme: ThemeData(
        primarySwatch: Colors.blue,
        fontFamily: 'Poppins',
        primaryColor: const Color(0xFF1E3A8A),
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF1E3A8A),
          secondary: const Color(0xFFFBBF24),
        ),
      ),
    ),
  );
}
