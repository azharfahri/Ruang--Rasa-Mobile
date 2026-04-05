import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:ruang_rasa_mobile/app/modules/checkoutpage/controllers/checkoutpage_controller.dart';
import 'package:ruang_rasa_mobile/app/modules/detail_produk/controllers/addcart_controller.dart';
import '../../home/controllers/home_controller.dart';

class CheckoutpageView extends GetView<CheckoutController> {
  const CheckoutpageView({super.key});

  static const bgColor = Color(0xFF004643);
  static const cardColor = Color(0xFF001E1D);
  static const accentColor = Color(0xFFF9BC60);

  @override
  Widget build(BuildContext context) {
    final cart = Get.find<CartController>();

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        title: const Text("Konfirmasi Pesanan"),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                _buildOutlet(),
                const SizedBox(height: 16),
                _buildCartList(cart),
              ],
            ),
          ),
          _buildBottomBar(cart),
        ],
      ),
    );
  }

  // ================= OUTLET =================
  Widget _buildOutlet() {
    final homeC = Get.find<HomeController>();

    return Obx(() {
      if (homeC.listCabang.isEmpty) return const SizedBox();

      final cabang = homeC.listCabang.firstWhere(
        (c) => c.id == homeC.selectedCabangId.value,
        orElse: () => homeC.listCabang.first,
      );

      return Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: cardColor,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          children: [
            const Icon(Icons.store, color: accentColor),
            const SizedBox(width: 12),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    cabang.name ?? "Cabang",
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    cabang.address ?? "-",
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: Colors.white70,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),

            GestureDetector(
              onTap: () => _showBranchPicker(homeC),
              child: const Text(
                "Ubah",
                style: TextStyle(
                  color: accentColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      );
    });
  }

  // ================= MODAL CABANG =================
  void _showBranchPicker(HomeController homeC) {
    Get.bottomSheet(
      Container(
        padding: const EdgeInsets.all(16),
        decoration: const BoxDecoration(
          color: cardColor,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Obx(() {
          return ListView(
            shrinkWrap: true,
            children: homeC.listCabang.map((branch) {
              return ListTile(
                title: Text(
                  branch.name ?? "",
                  style: const TextStyle(color: Colors.white),
                ),
                subtitle: Text(
                  branch.address ?? "",
                  style: const TextStyle(color: Colors.white70),
                ),
                trailing: homeC.selectedCabangId.value == branch.id
                    ? const Icon(Icons.check, color: accentColor)
                    : null,
                onTap: () {
                  homeC.changeCabang(branch.id);
                  Get.back();
                },
              );
            }).toList(),
          );
        }),
      ),
    );
  }

  // ================= CART =================
  Widget _buildCartList(CartController cart) {
    return Obx(() {
      return Column(
        children: cart.items.map((item) {
          return Container(
            margin: const EdgeInsets.only(bottom: 12),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: cardColor,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              children: [
                // IMAGE (optional)
                if (item.image != null)
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Image.network(
                      item.image!,
                      width: 50,
                      height: 50,
                      fit: BoxFit.cover,
                    ),
                  ),

                const SizedBox(width: 12),

                // INFO
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item.name,
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        "Rp ${NumberFormat('#,###').format(item.price)}",
                        style: const TextStyle(color: accentColor),
                      ),
                    ],
                  ),
                ),

                // QTY
                Row(
                  children: [
                    IconButton(
                      onPressed: () => cart.decrement(item),
                      icon: const Icon(Icons.remove, color: Colors.white),
                    ),
                    Text(
                      "${item.qty}",
                      style: const TextStyle(color: Colors.white),
                    ),
                    IconButton(
                      onPressed: () => cart.increment(item),
                      icon: const Icon(Icons.add, color: Colors.white),
                    ),
                  ],
                ),
              ],
            ),
          );
        }).toList(),
      );
    });
  }

  // ================= BOTTOM BAR =================
  Widget _buildBottomBar(CartController cart) {
    return Obx(() {
      return Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: cardColor,
          borderRadius: const BorderRadius.vertical(
            top: Radius.circular(20),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.4),
              blurRadius: 15,
              offset: const Offset(0, -5),
            ),
          ],
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Total",
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 12,
                    ),
                  ),
                  Text(
                    "Rp ${NumberFormat('#,###').format(cart.totalPrice)}",
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                ],
              ),
            ),

            Obx(() => ElevatedButton(
                  onPressed: controller.isLoading.value
                      ? null
                      : () => controller.createOrder(),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: accentColor,
                    foregroundColor: bgColor,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 24, vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  child: controller.isLoading.value
                      ? const SizedBox(
                          height: 18,
                          width: 18,
                          child: CircularProgressIndicator(
                            color: bgColor,
                            strokeWidth: 2,
                          ),
                        )
                      : const Text(
                          "Pesan Sekarang",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                ))
          ],
        ),
      );
    });
  }
}