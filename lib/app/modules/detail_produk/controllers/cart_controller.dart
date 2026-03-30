import 'package:get/get.dart';

class CartController extends GetxController {
  // list item keranjang
  var items = <Map<String, dynamic>>[].obs;

  // ================= TAMBAH ITEM =================
  void addItem(Map<String, dynamic> item) {
    // cek apakah produk sudah ada
    int index = items.indexWhere((i) => i['id'] == item['id']);

    if (index != -1) {
      // kalau sudah ada → tambah qty
      items[index]['qty'] += item['qty'];
    } else {
      // kalau belum → tambah baru
      items.add(item);
    }

    items.refresh();
  }

  // ================= HAPUS ITEM =================
  void removeItem(int id) {
    items.removeWhere((item) => item['id'] == id);
  }

  // ================= TOTAL ITEM =================
  int get totalItems {
    return items.fold(0, (sum, item) => sum + (item['qty'] as int));
  }

  // ================= TOTAL HARGA =================
  int get totalPrice {
    return items.fold(
      0,
      (sum, item) => sum + (item['price'] as int) * (item['qty'] as int),
    );
  }

  // ================= CLEAR =================
  void clearCart() {
    items.clear();
  }
}