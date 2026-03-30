import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart'; // Untuk format rupiah
import 'package:ruang_rasa_mobile/app/modules/detail_produk/controllers/cart_controller.dart';
import '../../auth/controllers/auth_controller.dart';
import '../controllers/home_controller.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({super.key});

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
          style: TextStyle(color: textColor, fontWeight: FontWeight.bold, fontSize: 20),
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
              child: const Text('Masuk',
                  style: TextStyle(color: accentColor, fontWeight: FontWeight.bold)),
            );
          }),
        ],
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator(color: accentColor));
        }

        return Stack(
          children: [
            RefreshIndicator(
              onRefresh: () => controller.fetchDataAwal(),
              color: accentColor,
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                children: [
                  const SizedBox(height: 10),
                  const Text(
                    'Selamat Datang di',
                    style: TextStyle(color: secondaryTextColor, fontSize: 14),
                  ),
                  const Text(
                    'Ruang Rasa Coffee',
                    style: TextStyle(
                        color: textColor,
                        fontSize: 26,
                        fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 25),

                  // LOKASI CABANG
                  _buildSectionTitle('Pilih Lokasi Cabang', null),
                  const SizedBox(height: 12),
                  _buildBranchDropdown(),

                  const SizedBox(height: 30),

                  // MENU SPESIAL
                  _buildSectionTitle('Menu Spesial', 'Lihat Semua'),
                  const SizedBox(height: 16),

                  // GRID PRODUK (Dibatasi misal 4-6 produk saja)
                  GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    // Menampilkan maksimal 6 produk untuk tampilan "Spesial"
                    itemCount: controller.listProduk.length > 6 ? 6 : controller.listProduk.length,
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 0.68, // Disesuaikan agar teks tidak terpotong
                      crossAxisSpacing: 16,
                      mainAxisSpacing: 16,
                    ),
                    itemBuilder: (context, index) {
                      final item = controller.listProduk[index];
                      return _buildProductCard(item);
                    },
                  ),

                  const SizedBox(height: 120), 
                ],
              ),
            ),

            Positioned(
              bottom: 25,
              left: 20,
              right: 20,
              child: CartBar(),
            ),
          ],
        );
      }),
    );
  }

  // Helper untuk Judul Section
  Widget _buildSectionTitle(String title, String? actionText) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: const TextStyle(
              color: textColor, fontSize: 18, fontWeight: FontWeight.bold),
        ),
        if (actionText != null)
          Text(
            actionText,
            style: const TextStyle(color: accentColor, fontSize: 13, fontWeight: FontWeight.w500),
          ),
      ],
    );
  }

  // Dropdown Cabang yang lebih bersih
  Widget _buildBranchDropdown() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: accentColor.withOpacity(0.2)),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<int>(
          dropdownColor: cardColor,
          isExpanded: true,
          value: controller.selectedCabangId.value,
          icon: const Icon(Icons.keyboard_arrow_down_rounded, color: accentColor),
          items: controller.listCabang.map((cabang) {
            return DropdownMenuItem<int>(
              value: cabang['id'],
              child: Text(cabang['name'],
                  style: const TextStyle(color: textColor, fontSize: 14)),
            );
          }).toList(),
          onChanged: (val) => controller.changeCabang(val),
        ),
      ),
    );
  }

  // UPDATE PRODUCT CARD YANG LEBIH RAPI
  Widget _buildProductCard(Map<String, dynamic> item) {
    return GestureDetector(
      onTap: () => Get.toNamed('/detail-produk', arguments: item),
      child: Container(
        decoration: BoxDecoration(
          color: cardColor,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, 5),
            )
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Gambar Produk (dengan ClipRRect agar melengkung di atas saja)
            ClipRRect(
              borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
              child: AspectRatio(
                aspectRatio: 1, // Agar gambar kotak sempurna
                child: Image.network(
                  item['image'] ?? 'https://via.placeholder.com/150',
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) =>
                      const Icon(Icons.image_not_supported, color: Colors.grey),
                ),
              ),
            ),
            
            // Info Produk
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Kategori
                  Text(
                    item['category']['name'], // Pastikan key 'category' ada di map produk kamu
                    style: const TextStyle(
                      color: accentColor, 
                      fontSize: 10, 
                      fontWeight: FontWeight.bold,
                      letterSpacing: 0.8,
                    ),
                  ),
                  const SizedBox(height: 4),
                  
                  // Nama Produk
                  Text(
                    item['name'],
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                        color: textColor, 
                        fontSize: 15, 
                        fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  
                  // Harga
                  Text(
                    "Rp ${NumberFormat('#,###').format(item['price'])}", // Format: Rp 15,000
                    style: const TextStyle(
                      color: secondaryTextColor, 
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  void _confirmLogout(AuthController authC) {
    Get.defaultDialog(
      title: 'Keluar',
      middleText: 'Apakah kamu yakin ingin keluar dari aplikasi?',
      textConfirm: 'Ya, Keluar',
      textCancel: 'Batal',
      confirmTextColor: bgColor,
      buttonColor: accentColor,
      onConfirm: () {
        Get.back();
        authC.logout();
      },
    );
  }
}
class CartBar extends StatelessWidget {
  final cart = Get.find<CartController>();

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (cart.items.isEmpty) return const SizedBox.shrink();

      return GestureDetector(
        onTap: () => Get.toNamed('/cart'),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          decoration: BoxDecoration(
            color: const Color(0xFFF9BC60),
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.3),
                blurRadius: 15,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Row(
            children: [
              Stack(
                clipBehavior: Clip.none,
                children: [
                  const Icon(Icons.shopping_bag_rounded, color: Color(0xFF001E1D), size: 28),
                  Positioned(
                    right: -4,
                    top: -4,
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: const BoxDecoration(
                        color: Color(0xFF004643),
                        shape: BoxShape.circle,
                      ),
                      child: Text(
                        "${cart.totalItems}",
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Total Pesanan",
                      style: TextStyle(
                        color: Color(0xFF001E1D),
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Text(
                      "Rp ${NumberFormat('#,###').format(cart.totalPrice)}",
                      style: const TextStyle(
                        color: Color(0xFF001E1D),
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              const Text(
                "Cek Keranjang",
                style: TextStyle(
                  color: Color(0xFF001E1D),
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
              const Icon(Icons.arrow_forward_ios_rounded, color: Color(0xFF001E1D), size: 14),
            ],
          ),
        ),
      );
    });
  }
}