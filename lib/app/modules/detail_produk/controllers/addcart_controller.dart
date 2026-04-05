import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:ruang_rasa_mobile/app/data/models/cart_model.dart';

class CartController extends GetxController {
  final box = GetStorage();

  var items = <CartModel>[].obs;

  // ================= SAVE =================
  void saveCart() {
    final userId = box.read('user_id');

    if (userId != null) {
      final data = items.map((e) => e.toJson()).toList();
      box.write('cart_$userId', data);
    }
  }

  // ================= LOAD =================
  void loadCart() {
    final userId = box.read('user_id');

    if (userId != null) {
      final data = box.read('cart_$userId');

      if (data != null) {
        items.value = (data as List)
            .map((e) => CartModel.fromJson(e))
            .toList();
      } else {
        items.clear();
      }
    }
  }

  // ================= ADD =================
  void addItem(CartModel item) {
    int index =
        items.indexWhere((i) => i.productId == item.productId);

    if (index != -1) {
      items[index].qty += item.qty;
    } else {
      items.add(item);
    }

    items.refresh();
    saveCart();
  }

  // ================= REMOVE =================
  void removeItem(int productId) {
    items.removeWhere((item) => item.productId == productId);
    saveCart();
  }

  // ================= INCREMENT =================
  void increment(CartModel item) {
    item.qty++;
    items.refresh();
    saveCart();
  }

  // ================= DECREMENT =================
  void decrement(CartModel item) {
    if (item.qty > 1) {
      item.qty--;
      items.refresh();
      saveCart();
    }
  }

  // ================= TOTAL ITEM =================
  int get totalItems {
    return items.fold(0, (sum, item) => sum + item.qty);
  }

  // ================= TOTAL PRICE =================
  int get totalPrice {
    return items.fold(0, (sum, item) => sum + item.price * item.qty);
  }

  // ================= CLEAR =================
  void clearCart() {
    items.clear();
    saveCart();
  }
}