import 'dart:convert';

class ReportStoreRequestModel {
  final String title;
  final String description;
  final String? photoPath; 
  final int categoryId;
  final String? fullAddress;
  final double? latitude;
  final double? longitude;
  final String? locationDetail;
  final bool isUrgent;

  ReportStoreRequestModel({
    required this.title,
    required this.description,
    this.photoPath,
    required this.categoryId,
    this.fullAddress,
    this.latitude,
    this.longitude,
    this.locationDetail,
    this.isUrgent = false,
  });

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'description': description,
      'category_id': categoryId,
      'address': fullAddress,
      'latitude': latitude,
      'longitude': longitude,
      'location_detail': locationDetail,
      'is_urgent': isUrgent,
    };
  }
}

class CategoryModel {
  final int id;
  final String name;
  final String? description;
  final String? icon;
  final String? color;
  final bool? isActive; 

  CategoryModel({
    required this.id,
    required this.name,
    this.description,
    this.icon,
    this.color,
    this.isActive, 
  });

  factory CategoryModel.fromMap(Map<String, dynamic> map) {
    return CategoryModel(
      id: map['id'] ?? 0,
      name: map['name'] ?? '',
      description: map['description'],
      icon: map['icon'],
      color: map['color'],
      isActive: map['is_active'], 
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'icon': icon,
      'color': color,
      'is_active': isActive, 
    };
  }
}

class LocationModel {
  final int id;
  final String name;
  final String? description;
  final String? village;
  final String? district;

  LocationModel({
    required this.id,
    required this.name,
    this.description,
    this.village,
    this.district,
  });

  factory LocationModel.fromMap(Map<String, dynamic> map) {
    return LocationModel(
      id: map['id'] ?? 0,
      name: map['name'] ?? '',
      description: map['description'],
      village: map['village'],
      district: map['district'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'village': village,
      'district': district,
    };
  }
}