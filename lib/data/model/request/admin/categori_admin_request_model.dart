class CategoryRequestModel {
  final String name;
  final String? description;
  final bool? isActive;

  CategoryRequestModel({
    required this.name,
    this.description,
    this.isActive,
  });

  Map<String, dynamic> toMap() {
    final Map<String, dynamic> data = {
      'name': name,
    };
    if (description != null && description!.isNotEmpty) {
      data['description'] = description;
    }
    
    if (isActive != null) {
      data['is_active'] = isActive;
    }

    return data;
  }

  factory CategoryRequestModel.fromMap(Map<String, dynamic> map) {
    return CategoryRequestModel(
      name: map['name'] ?? '',
      description: map['description'],
      isActive: map['is_active'],
    );
  }
}