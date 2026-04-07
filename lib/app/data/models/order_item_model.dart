import 'package:ruang_rasa_mobile/app/data/models/order_detail_model.dart';
class OrderItemModel {
  final int? id;
  final int? productId;
  final int? quantity;
  final int? price;
  final int? subtotal;
  final String? note;
  final List<OrderDetailModel>? details;
  final String? productName;
  final String? productImage;

  OrderItemModel({
    this.id,
    this.productId,
    this.quantity,
    this.price,
    this.subtotal,
    this.note,
    this.details,
    this.productName,
    this.productImage,
  });

  factory OrderItemModel.fromJson(Map<String, dynamic> json) {
    return OrderItemModel(
      id: json['id'],
      productId: json['product_id'],
      quantity: json['quantity'],
      price: int.tryParse(json['price'].toString()),
      subtotal: json['subtotal'] != null 
        ? (num.tryParse(json['subtotal'].toString())?.toInt() ?? 0) 
        : 0,
      note: json['note'],
      details: (json['details'] as List)
          .map((e) => OrderDetailModel.fromJson(e))
          .toList(),
      productName: json['product']?['name'],
      productImage: json['product']?['image'],
    );
  }
}