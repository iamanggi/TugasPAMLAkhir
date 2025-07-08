import 'dart:convert';

class CategoryRequestModel {
  final String name;
  final String slug;
  final String description;
  final String icon;
  final String color;
  final bool isActive;

  CategoryRequestModel({
    required this.name,
    required this.slug,
    required this.description,
    required this.icon,
    required this.color,
    required this.isActive,
  });

  String toJson() => json.encode(toMap());

  Map<String, dynamic> toMap() => {
        "name": name,
        "slug": slug,
        "description": description,
        "icon": icon,
        "color": color,
        "is_active": isActive,
      };
}
