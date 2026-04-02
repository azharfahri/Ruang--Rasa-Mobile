class CategoryModel {
  final int? id;
  final String? name;
  final String? slug;

  CategoryModel({
    this.id,
    this.name,
    this.slug,
  });

  // =====================
  // FROM JSON
  // =====================
  factory CategoryModel.fromJson(Map<String, dynamic> json) {
    return CategoryModel(
      id: json['id'],
      name: json['name'],
      slug: json['slug'],
    );
  }

  // =====================
  // TO JSON (optional)
  // =====================
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'slug': slug,
    };
  }
}