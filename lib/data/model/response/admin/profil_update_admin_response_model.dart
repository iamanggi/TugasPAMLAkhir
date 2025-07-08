import 'dart:convert';
import 'dart:io';

class AdminProfileUpdateResponseModel {
  final bool success;
  final String message;
  final AdminProfileData? data;
  final Map<String, dynamic>? errors;

  AdminProfileUpdateResponseModel({
    required this.success,
    required this.message,
    this.data,
    this.errors,
  });

  factory AdminProfileUpdateResponseModel.fromJson(String str) =>
      AdminProfileUpdateResponseModel.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory AdminProfileUpdateResponseModel.fromMap(
    Map<String, dynamic> json,
  ) => AdminProfileUpdateResponseModel(
    success: json["success"] ?? false,
    message: json["message"] ?? "",
    data: json["data"] != null ? AdminProfileData.fromMap(json["data"]) : null,
    errors: json["errors"],
  );

  Map<String, dynamic> toMap() => {
    "success": success,
    "message": message,
    "data": data?.toMap(),
    "errors": errors,
  };
}

class AdminProfileData {
  final int id;
  final String nama;
  final String email;
  final String username;
  final String role;
  final bool isActive;

  final String? phone;
  final String? address;
  final String? village;
  final String? subDistrict;
  final File? photo;
  final String? bahasa;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final DateTime? emailVerifiedAt;

  AdminProfileData({
    required this.id,
    required this.nama,
    required this.email,
    required this.username,
    required this.role,
    required this.isActive,
    this.phone,
    this.address,
    this.village,
    this.subDistrict,
    this.photo,
    this.bahasa,
    this.createdAt,
    this.updatedAt,
    this.emailVerifiedAt,
  });

  factory AdminProfileData.fromMap(Map<String, dynamic> json) =>
      AdminProfileData(
        id: json["id_user"],
        nama: json["nama"],
        email: json["email"],
        username: json["username"],
        role: json["role"],
        isActive: json["is_active"] == 1 || json["is_active"] == true,
        phone: json["phone"],
        address: json["address"],
        village: json["village"],
        subDistrict: json["sub_district"],
        photo: json["photo"],
        bahasa: json["bahasa"],
        createdAt:
            json["created_at"] != null
                ? DateTime.tryParse(json["created_at"])
                : null,
        updatedAt:
            json["updated_at"] != null
                ? DateTime.tryParse(json["updated_at"])
                : null,
        emailVerifiedAt:
            json["email_verified_at"] != null
                ? DateTime.tryParse(json["email_verified_at"])
                : null,
      );

  Map<String, dynamic> toMap() => {
    "id_user": id,
    "nama": nama,
    "email": email,
    "username": username,
    "role": role,
    "is_active": isActive,
    "phone": phone,
    "address": address,
    "village": village,
    "sub_district": subDistrict,
    "photo": photo,
    "bahasa": bahasa,
    "created_at": createdAt?.toIso8601String(),
    "updated_at": updatedAt?.toIso8601String(),
    "email_verified_at": emailVerifiedAt?.toIso8601String(),
  };
}
