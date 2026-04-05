import 'package:ruang_rasa_mobile/app/data/models/order_item_model.dart';
class OrderModel {
  final int? id;
  final int? userId;
  final String? customerName;
  final int? branchId;
  final int? total;
  final String? status;
  final String? paymentStatus;
  final List<OrderItemModel>? items;

  OrderModel({
    this.id,
    this.userId,
    this.customerName,
    this.branchId,
    this.total,
    this.status,
    this.paymentStatus,
    this.items,
  });

  factory OrderModel.fromJson(Map<String, dynamic> json) {
    return OrderModel(
      id: json['id'],
      userId: json['user_id'],
      customerName: json['customer_name'],
      branchId: int.tryParse(json['branch_id'].toString()),
      total: json['total'],
      status: json['status'],
      paymentStatus: json['payment_status'],
      items: (json['items'] as List)
          .map((e) => OrderItemModel.fromJson(e))
          .toList(),
    );
  }
}