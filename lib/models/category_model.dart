
class CategoryModel {
  int idCategory;
  String category;

  CategoryModel({
    this.idCategory,
    this.category,
  });

  factory CategoryModel.fromJson(Map<String, dynamic> json) => CategoryModel(
    idCategory: json["_idCategory"],
    category: json["_category"],
  );

  Map<String, dynamic> toJson() => {
    "_idCategory": idCategory,
    "_category": category,
  };
}