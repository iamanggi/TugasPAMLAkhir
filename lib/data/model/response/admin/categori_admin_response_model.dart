import 'dart:convert';

class CategoryDataModel {
  final int id;
  final String name;
  final String? slug;
  final String? description;
  final String? icon;
  final String? color;
  final bool? isActive;

  CategoryDataModel({
    required this.id,
    required this.name,
    this.slug,
    this.description,
    this.icon,
    this.color,
    this.isActive,
  });

  factory CategoryDataModel.fromMap(Map<String, dynamic> map) {
    return CategoryDataModel(
      id: map['id'],
      name: map['name'],
      slug: map['slug'],
      description: map['description'],
      icon: map['icon'],
      color: map['color'],
      isActive: map['is_active'],
    );
  }

  /// ✅ Tambahkan ini kalau ingin pakai fromJson langsung dari response.body
  factory CategoryDataModel.fromJson(String source) =>
      CategoryDataModel.fromMap(json.decode(source));
}
