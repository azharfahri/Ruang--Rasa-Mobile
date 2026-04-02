import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class CartController extends GetxController {
  final box = GetStorage();
  // list item keranjang
  var items = <Map<String, dynamic>>[].obs;

  void saveCart() {
    final userId = box.read('user_id');
    print("SAVE CART USER: $userId");
print("ITEMS: $items");
    if (userId != null) {
      box.write('cart_$userId', items.toList());
    }
  }

  void loadCart() {
    final userId = box.read('user_id');
    print("LOAD CART USER: $userId");
print("DATA: ${box.read('cart_$userId')}");

    if (userId != null) {
      final data = box.read('cart_$userId');

      if (data != null) {
        items.value = List<Map<String, dynamic>>.from(data);
        items.refresh();
      } else {
        items.clear();
      }
    }
  }

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
    saveCart();
  }

  // ================= HAPUS ITEM =================
  void removeItem(int id) {
    items.removeWhere((item) => item['id'] == id);
    saveCart();
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
