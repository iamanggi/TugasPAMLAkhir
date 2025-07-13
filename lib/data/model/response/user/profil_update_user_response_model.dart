import 'dart:convert';
import 'dart:io';

class UserProfileUpdateResponseModel {
  final bool success;
  final String message;
  final UserProfileData? data;
  final Map<String, dynamic>? errors;

  UserProfileUpdateResponseModel({
    required this.success,
    required this.message,
    this.data,
    this.errors,
  });

  factory UserProfileUpdateResponseModel.fromJson(String str) =>
      UserProfileUpdateResponseModel.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory UserProfileUpdateResponseModel.fromMap(Map<String, dynamic> json) =>
      UserProfileUpdateResponseModel(
        success: json["success"] ?? false,
        message: json["message"] ?? "",
        data: json["data"] != null ? UserProfileData.fromMap(json["data"]) : null,
        errors: json["errors"],
      );

  Map<String, dynamic> toMap() => {
        "success": success,
        "message": message,
        "data": data?.toMap(),
        "errors": errors,
      };
}

class UserProfileData {
  final int id;
  final String nama;
  final String email;
  final String username;
  final String? phone;
  final String? address;
  final String? village;
  final String? subDistrict;
  final String role;
  final String? photo;
  final bool isActive;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  UserProfileData({
    required this.id,
    required this.nama,
    required this.email,
    required this.username,
    this.phone,
    this.address,
    this.village,
    this.subDistrict,
    required this.role,
    this.photo,
    required this.isActive,
    this.createdAt,
    this.updatedAt,
  });

  factory UserProfileData.fromMap(Map<String, dynamic> json) => UserProfileData(
        id: json["id_user"] ?? 0, // Sesuai respons server
        nama: json["nama"] ?? '',
        email: json["email"] ?? '',
        username: json["username"] ?? '',
        phone: json["phone"]?.toString(),
        address: json["address"]?.toString(),
        village: json["village"]?.toString(),
        subDistrict: json["sub_district"]?.toString(),
        role: json["role"] ?? '',
        photo: json["photo"]?.toString(),
        isActive: json["is_active"] == 1 || json["is_active"] == true,
        createdAt: json["created_at"] != null ? DateTime.tryParse(json["created_at"]) : null,
        updatedAt: json["updated_at"] != null ? DateTime.tryParse(json["updated_at"]) : null,
      );

  Map<String, dynamic> toMap() => {
        "id_user": id,
        "nama": nama,
        "email": email,
        "username": username,
        "phone": phone,
        "address": address,
        "village": village,
        "sub_district": subDistrict,
        "role": role,
        "photo": photo,
        "is_active": isActive,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
      };
}
