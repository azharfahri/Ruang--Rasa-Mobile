import 'package:ruang_rasa_mobile/app/data/models/product_model.dart';

class CartModel {
  final int productId;
  final String name;
  final int price;
  final String? image;
  int qty;
  final int stock;

  List<Map<String,dynamic>>? variants;
  final ProductModel? product;

  CartModel({
    required this.productId,
    required this.name,
    required this.price,
    this.image,
    this.qty = 1,
    required this.stock, 
    this.variants,
    this.product,
  });

  // ================= FROM JSON =================
  factory CartModel.fromJson(Map<String, dynamic> json) {
    return CartModel(
      productId: json['product_id'],
      name: json['name'],
      price: json['price'],
      image: json['image'],
      qty: json['qty'] ?? 1,
      stock: json['stock'] ?? 0, 
      variants: json['variants'] != null
          ? List<Map<String, dynamic>>.from(json['variants'])
          : [],
    );
  }

  String get variantText {
  if (variants == null || product == null) return "";

  List<String> names = [];

  for (var v in variants!) {
    final typeId = v['variant_type_id'];
    final optionId = v['variant_option_id'];

    final type = product!.variantTypes
        ?.firstWhere((t) => t.id == typeId);

    final option = type?.variantOptions
        ?.firstWhere((o) => o.id == optionId);

    if (option?.optionName != null) {
      names.add(option!.optionName!);
    }
  }

  return names.join(", ");
}

  // ================= TO JSON =================
  Map<String, dynamic> toJson() {
    return {
      "product_id": productId,
      "name": name,
      "price": price,
      "image": image,
      "qty": qty,
      "stock": stock, 
      "variants": variants,
    };
  }
}