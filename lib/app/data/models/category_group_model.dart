import 'product_model.dart';
import 'category_model.dart';

class CategoryGroupModel {
  final CategoryModel category;
  final List<ProductModel> products;

  CategoryGroupModel({
    required this.category,
    required this.products,
  });
}