class BranchModel {
  final int? id;
  final String? name;
  final String? address;
  final double? latitude;
  final double? longitude;
  final String? openTime;
  final String? closeTime;
  final String? createdAt;
  final String? updatedAt;

  BranchModel({
    this.id,
    this.name,
    this.address,
    this.latitude,
    this.longitude,
    this.openTime,
    this.closeTime,
    this.createdAt,
    this.updatedAt,
  });

  // =====================
  // FROM JSON
  // =====================
  factory BranchModel.fromJson(Map<String, dynamic> json) {
    return BranchModel(
      id: json['id'],
      name: json['name'],
      address: json['address'],
      latitude: double.tryParse(json['latitude'].toString()),
      longitude: double.tryParse(json['longitude'].toString()),
      openTime: json['open_time'],
      closeTime: json['close_time'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
    );
  }

  // =====================
  // TO JSON (optional)
  // =====================
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'address': address,
      'latitude': latitude,
      'longitude': longitude,
      'open_time': openTime,
      'close_time': closeTime,
      'created_at': createdAt,
      'updated_at': updatedAt,
    };
  }
}