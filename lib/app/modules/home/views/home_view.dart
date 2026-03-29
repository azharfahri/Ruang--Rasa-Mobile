import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../auth/controllers/auth_controller.dart';
import '../controllers/home_controller.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({super.key});

  // Palette Ruang Rasa
  static const Color bgColor = Color(0xFF004643);
  static const Color accentColor = Color(0xFFF9BC60);
  static const Color textColor = Color(0xFFFFFFFE);
  static const Color secondaryTextColor = Color(0xFFABD1C6);
  static const Color cardColor = Color(0xFF001E1D);

  @override
  Widget build(BuildContext context) {
    final AuthController authC = Get.find<AuthController>();

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        title: const Text(
          'Ruang Rasa',
          style: TextStyle(color: textColor, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          Obx(() {
            if (authC.isLoggedIn.value) {
              return IconButton(
                icon: const Icon(Icons.logout_rounded, color: accentColor),
                onPressed: () => _confirmLogout(authC),
              );
            }
            return TextButton(
              onPressed: () => Get.toNamed('/login'),
              child: const Text('Masuk', style: TextStyle(color: accentColor, fontWeight: FontWeight.bold)),
            );
          }),
        ],
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator(color: accentColor));
        }

        return RefreshIndicator(
          onRefresh: () => controller.fetchDataAwal(),
          color: accentColor,
          child: ListView(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            children: [
              const SizedBox(height: 10),
              // --- HEADER ---
              const Text(
                'Selamat Datang di',
                style: TextStyle(color: secondaryTextColor, fontSize: 16),
              ),
              const Text(
                'Ruang Rasa Coffee',
                style: TextStyle(color: textColor, fontSize: 28, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 25),

              // --- DROPDOWN CABANG ---
              const Text(
                'Pilih Lokasi Cabang',
                style: TextStyle(color: textColor, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 10),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                decoration: BoxDecoration(
                  color: cardColor,
                  borderRadius: BorderRadius.circular(15),
                  border: Border.all(color: accentColor.withOpacity(0.3)),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<int>(
                    dropdownColor: cardColor,
                    isExpanded: true,
                    value: controller.selectedCabangId.value,
                    icon: const Icon(Icons.location_on, color: accentColor),
                    items: controller.listCabang.map((cabang) {
                      return DropdownMenuItem<int>(
                        value: cabang['id'],
                        child: Text(cabang['name'], style: const TextStyle(color: textColor)),
                      );
                    }).toList(),
                    onChanged: (val) => controller.changeCabang(val),
                  ),
                ),
              ),
              const SizedBox(height: 30),

              // --- GRID PRODUK ---
              const Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Menu Spesial',
                    style: TextStyle(color: textColor, fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    'Lihat Semua',
                    style: TextStyle(color: accentColor, fontSize: 12),
                  ),
                ],
              ),
              const SizedBox(height: 15),
              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: controller.listProduk.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 0.7,
                  crossAxisSpacing: 15,
                  mainAxisSpacing: 15,
                ),
                itemBuilder: (context, index) {
                  final item = controller.listProduk[index];
                  return _buildProductCard(item);
                },
              ),
              const SizedBox(height: 30),
            ],
          ),
        );
      }),
    );
  }

  // Widget Card Produk
  Widget _buildProductCard(Map<String, dynamic> item) {
    return GestureDetector(
      onTap: () => Get.toNamed('/detail-produk', arguments: item),
      child: Container(
        decoration: BoxDecoration(
          color: cardColor,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image
            Expanded(
              flex: 3,
              child: ClipRRect(
                borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
                child: Image.network(
                  item['image'],
                  width: double.infinity,
                  fit: BoxFit.cover,
                  errorBuilder: (c, e, s) => Container(
                    color: Colors.white10,
                    child: const Icon(Icons.coffee_rounded, color: accentColor),
                  ),
                ),
              ),
            ),
            // Text Details
            Expanded(
              flex: 2,
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      item['category']['name'],
                      style: const TextStyle(color: accentColor, fontSize: 10, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      item['name'],
                      style: const TextStyle(color: textColor, fontSize: 14, fontWeight: FontWeight.bold),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 5),
                    Text(
                      "Rp ${item['price']}",
                      style: const TextStyle(color: secondaryTextColor, fontSize: 13),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _confirmLogout(AuthController authC) {
    Get.defaultDialog(
      title: 'Logout',
      middleText: 'Yakin mau keluar?',
      backgroundColor: cardColor,
      titleStyle: const TextStyle(color: textColor),
      middleTextStyle: const TextStyle(color: secondaryTextColor),
      textConfirm: 'Ya',
      textCancel: 'Batal',
      confirmTextColor: cardColor,
      cancelTextColor: accentColor,
      buttonColor: accentColor,
      onConfirm: () {
        Get.back();
        authC.logout();
      },
    );
  }
}