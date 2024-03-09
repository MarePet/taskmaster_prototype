class CategoryModel {
  final int categoryId;
  final String categoryName;
  CategoryModel(this.categoryId, this.categoryName);

  factory CategoryModel.fromJson(Map<String, dynamic> json) => CategoryModel(
        int.parse(json['category_id']),
        json['category_name'],
      );

  Map<String, dynamic> toJson() =>
      {'category_id': categoryId.toString(), 'category_name': categoryName};
  @override
  String toString() => "$categoryName";

  @override
  bool operator ==(Object other) {
    return other is CategoryModel && categoryName == other.categoryName;
  }

  @override
  // TODO: implement hashCode
  int get hashCode => super.hashCode;
}
