import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:ruang_rasa_mobile/app/modules/auth/controllers/auth_controller.dart';
import 'package:ruang_rasa_mobile/app/modules/detail_produk/controllers/cart_controller.dart';
import 'package:ruang_rasa_mobile/app/modules/home/controllers/home_controller.dart';

import 'app/routes/app_pages.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await GetStorage.init();

  Get.put(AuthController());
  Get.put(HomeController());
  Get.put(CartController());
  
  runApp(
    GetMaterialApp(
      title: "Ruang Rasa - Cafe Nyaman",
      initialRoute: '/main',
      getPages: AppPages.routes,
      debugShowCheckedModeBanner: false,
      useInheritedMediaQuery: true,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        fontFamily: 'Poppins',
        primaryColor: const Color(0xFF1E3A8A),
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF1E3A8A),
          secondary: const Color(0xFFFBBF24), // Yellow
        ),
      ),
    ),
  );
}
