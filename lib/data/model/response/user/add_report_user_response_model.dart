import 'dart:convert';

class ReportStoreResponseModel {
  final bool success;
  final String message;
  final ReportData? data;
  final Map<String, dynamic>? errors;

  ReportStoreResponseModel({
    required this.success,
    required this.message,
    this.data,
    this.errors,
  });

  factory ReportStoreResponseModel.fromJson(Map<String, dynamic> json) {
    return ReportStoreResponseModel(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      data: json['data'] != null ? ReportData.fromMap(json['data']) : null,
      errors: json['errors'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'message': message,
      'data': data?.toMap(),
      'errors': errors,
    };
  }
}

class ReportData {
  final int id;
  final String reportNumber;
  final String title;
  final String description;
  final String status;
  final String? photoUrl;
  final String? village;
  final String? district;
  final String? fullAddress;
  final double? latitude;
  final double? longitude;
  final String? locationDetail;
  final bool isUrgent;
  final bool isVerified;
  final DateTime createdAt;
  final DateTime? verifiedAt;
  final DateTime? processedAt;
  final DateTime? completedAt;
  final CategoryData? category;
  final UserData? user;

  ReportData({
    required this.id,
    required this.reportNumber,
    required this.title,
    required this.description,
    required this.status,
    this.photoUrl,
    this.village,
    this.district,
    this.fullAddress,
    this.latitude,
    this.longitude,
    this.locationDetail,
    this.isUrgent = false,
    this.isVerified = false,
    required this.createdAt,
    this.verifiedAt,
    this.processedAt,
    this.completedAt,
    this.category,
    this.user,
  });

  factory ReportData.fromMap(Map<String, dynamic> map) {
    return ReportData(
      id: map['id'] ?? 0,
      reportNumber: map['report_number'] ?? '',
      title: map['title'] ?? '',
      description: map['description'] ?? '',
      status: map['status'] ?? 'baru',
      photoUrl: map['photo_url'],
      village: map['village'],
      district: map['district'],
      fullAddress: map['full_address'],
      latitude: map['latitude']?.toDouble(),
      longitude: map['longitude']?.toDouble(),
      locationDetail: map['location_detail'],
      isUrgent: map['is_urgent'] ?? false,
      isVerified: map['is_verified'] ?? false,
      createdAt: DateTime.tryParse(map['created_at'] ?? '') ?? DateTime.now(),
      verifiedAt: map['verified_at'] != null 
          ? DateTime.tryParse(map['verified_at']) 
          : null,
      processedAt: map['processed_at'] != null 
          ? DateTime.tryParse(map['processed_at']) 
          : null,
      completedAt: map['completed_at'] != null 
          ? DateTime.tryParse(map['completed_at']) 
          : null,
      category: map['category'] != null 
          ? CategoryData.fromMap(map['category']) 
          : null,
      user: map['user'] != null 
          ? UserData.fromMap(map['user']) 
          : null,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'report_number': reportNumber,
      'title': title,
      'description': description,
      'status': status,
      'photo_url': photoUrl,
      'village': village,
      'district': district,
      'full_address': fullAddress,
      'latitude': latitude,
      'longitude': longitude,
      'location_detail': locationDetail,
      'is_urgent': isUrgent,
      'is_verified': isVerified,
      'created_at': createdAt.toIso8601String(),
      'verified_at': verifiedAt?.toIso8601String(),
      'processed_at': processedAt?.toIso8601String(),
      'completed_at': completedAt?.toIso8601String(),
      'category': category?.toMap(),
      'user': user?.toMap(),
    };
  }
}

class CategoryData {
  final int id;
  final String name;
  final String? description;
  final String? icon;
  final String? color;

  CategoryData({
    required this.id,
    required this.name,
    this.description,
    this.icon,
    this.color,
  });

  factory CategoryData.fromMap(Map<String, dynamic> map) {
    return CategoryData(
      id: map['id'] ?? 0,
      name: map['name'] ?? '',
      description: map['description'],
      icon: map['icon'],
      color: map['color'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'icon': icon,
      'color': color,
    };
  }
}

class UserData {
  final int id;
  final String name;
  final String email;
  final String? phone;
  final String? avatar;

  UserData({
    required this.id,
    required this.name,
    required this.email,
    this.phone,
    this.avatar,
  });

  factory UserData.fromMap(Map<String, dynamic> map) {
    return UserData(
      id: map['id'] ?? 0,
      name: map['name'] ?? '',
      email: map['email'] ?? '',
      phone: map['phone'],
      avatar: map['avatar'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'phone': phone,
      'avatar': avatar,
    };
  }
}

class CategoriesResponseModel {
  final bool success;
  final String message;
  final List<CategoryData>? data;

  CategoriesResponseModel({
    required this.success,
    required this.message,
    this.data,
  });

  factory CategoriesResponseModel.fromJson(String jsonString) {
    final Map<String, dynamic> json = jsonDecode(jsonString);
    return CategoriesResponseModel(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      data: json['data'] != null 
          ? (json['data'] as List)
              .map((item) => CategoryData.fromMap(item))
              .toList()
          : null,
    );
  }
}

class LocationsResponseModel {
  final bool success;
  final String message;
  final List<LocationData>? data;

  LocationsResponseModel({
    required this.success,
    required this.message,
    this.data,
  });

  factory LocationsResponseModel.fromJson(String jsonString) {
    final Map<String, dynamic> json = jsonDecode(jsonString);
    return LocationsResponseModel(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      data: json['data'] != null 
          ? (json['data'] as List)
              .map((item) => LocationData.fromMap(item))
              .toList()
          : null,
    );
  }
}

class LocationData {
  final int id;
  final String name;
  final String? description;
  final String? village;
  final String? district;

  LocationData({
    required this.id,
    required this.name,
    this.description,
    this.village,
    this.district,
  });

  factory LocationData.fromMap(Map<String, dynamic> map) {
    return LocationData(
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
