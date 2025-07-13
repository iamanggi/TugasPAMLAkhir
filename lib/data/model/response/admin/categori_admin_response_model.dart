import 'dart:convert';

class CategoryDataModel {
  final int id;
  final String name;
  final String? description;
  final bool? isActive;

  CategoryDataModel({
    required this.id,
    required this.name,
    this.description,
    this.isActive,
  });

  factory CategoryDataModel.fromMap(Map<String, dynamic> map) {
    return CategoryDataModel(
      id: map['id'],
      name: map['name'],
      description: map['description'],
      isActive: map['is_active'],
    );
  }
  
  factory CategoryDataModel.fromJson(String source) =>
      CategoryDataModel.fromMap(json.decode(source));
}
