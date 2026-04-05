class OrderDetailModel {
  final int? id;
  final String? optionName;
  final int? priceImpact;

  OrderDetailModel({
    this.id,
    this.optionName,
    this.priceImpact,
  });

  factory OrderDetailModel.fromJson(Map<String, dynamic> json) {
    return OrderDetailModel(
      id: json['id'],
      optionName: json['variant_option']?['option_name'],
      priceImpact:
          int.tryParse(json['variant_option']?['price_impact'].toString() ?? "0"),
    );
  }
}