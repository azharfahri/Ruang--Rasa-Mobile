import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:ruang_rasa_mobile/app/data/models/cart_model.dart';
import 'package:ruang_rasa_mobile/app/modules/detail_produk/controllers/addcart_controller.dart';
import 'package:ruang_rasa_mobile/app/modules/detail_produk/controllers/detail_produk_controller.dart';

class DetailProdukView extends GetView<DetailProdukController> {
  const DetailProdukView({super.key});

  // Palette Ruang Rasa
  static const Color bgColor = Color(0xFF004643);
  static const Color accentColor = Color(0xFFF9BC60);
  static const Color cardColor = Color(0xFF001E1D);
  static const Color textColor = Color(0xFFFFFFFE);

  @override
  Widget build(BuildContext context) {
    // Kita panggil product dari controller, BUKAN dari Get.arguments lagi
    final product = controller.product;
    final args = Get.arguments;
    final isEdit = args is Map ? args['isEdit'] == true : false;
    final cartItem = args is Map ? args['cartItem'] : null;

    return Scaffold(
      backgroundColor: bgColor,
      body: Stack(
        children: [
          // 1. CONTENT (Scrollable)
          SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Gambar Produk
                Container(
                  height: 350,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: cardColor, // Background placeholder jika gambar null
                    image: product.image != null
                        ? DecorationImage(
                            image: NetworkImage(product.image!),
                            fit: BoxFit.cover,
                          )
                        : null,
                  ),
                  child: product.image == null
                      ? const Icon(
                          Icons.image_not_supported,
                          size: 50,
                          color: Colors.white54,
                        )
                      : null,
                ),

                Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Nama & Harga
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              product.name ?? 'Nama Produk',
                              style: const TextStyle(
                                color: textColor,
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          Text(
                            "Rp ${product.price ?? 0}",
                            style: const TextStyle(
                              color: accentColor,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      // Deskripsi
                      Text(
                        product.description ?? 'Tidak ada deskripsi.',
                        style: const TextStyle(
                          color: Color(0xFFABD1C6),
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(height: 30),

                      // --- DYNAMIC SELECTION (Membaca dari Database) ---
                      if (product.variantTypes != null)
                        ...product.variantTypes!.map((type) {
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _buildOptionTitle(type.name ?? ""),

                              // Menggunakan Wrap agar opsi otomatis turun ke bawah jika layar tidak muat
                              Wrap(
                                spacing: 15,
                                runSpacing: 15,
                                children:
                                    type.variantOptions?.map((option) {
                                      return Obx(() {
                                        // Tentukan apakah opsi ini sedang dipilih
                                        bool isSelected = false;
                                        if (type.inputType == 'radio') {
                                          isSelected =
                                              controller.selectedRadios[type
                                                  .id] ==
                                              option.id;
                                        } else {
                                          isSelected =
                                              controller
                                                  .selectedCheckboxes[option
                                                  .id] ==
                                              true;
                                        }

                                        // Format label (tampilkan penambahan harga jika ada)
                                        String label = option.optionName ?? "";
                                        if (option.priceImpact != null &&
                                            option.priceImpact! > 0) {
                                          label +=
                                              "\n(+ Rp ${option.priceImpact})";
                                        }

                                        return GestureDetector(
                                          onTap: () {
                                            if (type.inputType == 'radio') {
                                              controller.selectRadio(
                                                type.id!,
                                                option.id!,
                                              );
                                            } else {
                                              controller.toggleCheckbox(
                                                option.id!,
                                              );
                                            }
                                          },
                                          // Lebar diatur agar pas (tidak pakai Expanded lagi di dalam Wrap)
                                          child: SizedBox(
                                            width:
                                                (Get.width / 2) -
                                                28, // Dibagi 2 kolom dengan margin
                                            child: _buildSelectBox(
                                              label,
                                              null,
                                              isSelected,
                                            ),
                                          ),
                                        );
                                      });
                                    }).toList() ??
                                    [],
                              ),
                              const SizedBox(height: 25),
                            ],
                          );
                        }).toList(),

                      const SizedBox(
                        height: 100,
                      ), // Space agar tidak tertutup bottom bar
                    ],
                  ),
                ),
              ],
            ),
          ),

          // 2. FLOATING BACK BUTTON
          Positioned(
            top: 40,
            left: 20,
            child: GestureDetector(
              onTap: () => Get.back(),
              child: Container(
                padding: const EdgeInsets.all(8),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.arrow_back, color: Colors.black),
              ),
            ),
          ),

          // 3. BOTTOM BAR (Quantity & Add to Cart)
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
              decoration: const BoxDecoration(
                color: cardColor,
                borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
              ),
              child: Row(
                children: [
                  // Quantity Counter
                  Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: accentColor),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Row(
                      children: [
                        IconButton(
                          onPressed: () => controller.decrement(),
                          icon: const Icon(Icons.remove, color: accentColor),
                        ),
                        Obx(
                          () => Text(
                            "${controller.quantity.value}",
                            style: const TextStyle(
                              color: textColor,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        IconButton(
                          onPressed: () => controller.increment(),
                          icon: const Icon(Icons.add, color: accentColor),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 15),
                  // Add to Cart Button Dinamis
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        final box = GetStorage();
                        final isLogin = box.read('token');

                        if (isLogin == null) {
                          Get.snackbar(
                            "Login terlebih dahulu",
                            "Agar bisa pesan kopi kamu",
                            snackPosition: SnackPosition.BOTTOM,
                          );

                          Get.toNamed('/login');
                          return;
                        }

                        final cart = Get.find<CartController>();

                        if (isEdit && cartItem != null) {
                          // 🔥 MODE EDIT
                          int index = cart.items.indexWhere(
                            (i) => i.productId == cartItem.productId,
                          );

                          if (index != -1) {
                            cart.items[index] = CartModel(
                              productId: cartItem.productId,
                              name: cartItem.name,
                              price: controller.totalPrice,
                              image: cartItem.image,
                              qty: controller.quantity.value,
                              stock: cartItem.stock,
                              variants: controller.getSelectedVariants(),
                              product:
                                  cartItem.product, // 🔥 penting biar ga null
                            );

                            cart.items.refresh();
                            cart.saveCart();
                          }

                          Get.back();
                        } else {
                          // 🔥 MODE NORMAL
                          cart.addItem(
                            CartModel(
                              productId: product.id ?? 0,
                              name: product.name ?? "Produk",
                              price: controller.totalPrice,
                              image: product.image,
                              qty: controller.quantity.value,
                              stock: product.stock ?? 0,
                              variants: controller.getSelectedVariants(),
                              product: product,
                            ),
                          );

                          Get.back();
                        }
                      },

                      // ❌ HAPUS Obx DI SINI
                      child: Text(
                        isEdit
                            ? "Simpan Konfigurasi"
                            : "+ Keranjang Rp ${controller.totalPrice}",
                        style: const TextStyle(
                          color: cardColor,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOptionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Text(
        title,
        style: const TextStyle(
          color: textColor,
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  // NOTE: Saya menghapus widget Expanded di sini agar bisa ditaruh di dalam Widget Wrap()
  Widget _buildSelectBox(String label, IconData? icon, bool isSelected) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 8),
      decoration: BoxDecoration(
        color: isSelected ? accentColor.withOpacity(0.1) : cardColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isSelected ? accentColor : Colors.transparent,
          width: 2,
        ),
      ),
      child: Column(
        children: [
          if (icon != null)
            Icon(icon, color: isSelected ? accentColor : Colors.grey, size: 30),
          if (icon != null) const SizedBox(height: 5),
          Text(
            label,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: isSelected ? accentColor : Colors.grey,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
