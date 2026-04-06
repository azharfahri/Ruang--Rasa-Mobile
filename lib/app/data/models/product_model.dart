class ProductModel {
  int? id;
  String? name;
  String? description;
  int? price;
  int? stock;
  String? image;
  Category? category;
  List<VariantType>? variantTypes;

  ProductModel({
    this.id,
    this.name,
    this.description,
    this.price,
    this.stock,
    this.image,
    this.category,
    this.variantTypes,
  });

  ProductModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    description = json['description'];
    price = json['price'];
    stock = json['stock'];
    image = json['image'];
    category = json['category'] != null
        ? Category.fromJson(json['category'])
        : null;
    if (json['variant_types'] != null) {
      variantTypes = <VariantType>[];
      json['variant_types'].forEach((v) {
        variantTypes!.add(VariantType.fromJson(v));
      });
    }
  }
}

class Category {
  int? id;
  String? name;

  Category({this.id, this.name});

  Category.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
  }
}

class VariantType {
  int? id;
  String? name;
  String? inputType;
  List<VariantOption>? variantOptions;

  VariantType({this.id, this.name, this.inputType, this.variantOptions});

  VariantType.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    inputType = json['input_type'];
    if (json['variant_options'] != null) {
      variantOptions = <VariantOption>[];
      json['variant_options'].forEach((v) {
        variantOptions!.add(VariantOption.fromJson(v));
      });
    }
  }
}

class VariantOption {
  int? id;
  String? optionName;
  int? priceImpact;

  VariantOption({this.id, this.optionName, this.priceImpact});

  VariantOption.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    optionName = json['option_name'];
    priceImpact = json['price_impact'];
  }
}
