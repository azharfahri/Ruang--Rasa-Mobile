class ProfileModel {
  final int? id;
  final String? name;
  final String? email;
  final String? googleId;
  final String? avatar;
  final int? branchId;
  final String? createdAt;
  final String? updatedAt;

  ProfileModel({
    this.id,
    this.name,
    this.email,
    this.googleId,
    this.avatar,
    this.branchId,
    this.createdAt,
    this.updatedAt,
  });

  factory ProfileModel.fromJson(Map<String, dynamic> json) {
    return ProfileModel(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      googleId: json['google_id'],
      avatar: json['avatar'],
      branchId: json['branch_id'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
    );
  }
}