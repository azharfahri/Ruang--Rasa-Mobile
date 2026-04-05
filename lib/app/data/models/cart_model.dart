class CartModel {
  final int productId;
  final String name;
  final int price;
  final String? image;
  int qty;

  CartModel({
    required this.productId,
    required this.name,
    required this.price,
    this.image,
    this.qty = 1,
  });

  factory CartModel.fromJson(Map<String, dynamic> json) {
    return CartModel(
      productId: json['product_id'],
      name: json['name'],
      price: json['price'],
      image: json['image'],
      qty: json['qty'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "product_id": productId,
      "name": name,
      "price": price,
      "image": image,
      "qty": qty,
    };
  }
}