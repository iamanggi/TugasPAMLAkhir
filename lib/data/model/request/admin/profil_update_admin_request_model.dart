import 'dart:convert';
import 'dart:io';

class AdminProfileUpdateRequestModel {
  final String? nama;
  final String? email;
  final String? username;
  final String? password;
  final String? passwordConfirmation;
  final String? phone;
  final String? address;
  final String? village;
  final String? subDistrict;
  final String? role;
  final bool? isActive;
  final File? photoFile;

  AdminProfileUpdateRequestModel({
    this.nama,
    this.email,
    this.username,
    this.password,
    this.passwordConfirmation,
    this.phone,
    this.address,
    this.village,
    this.subDistrict,
    this.role,
    this.isActive,
    this.photoFile,
  });

  factory AdminProfileUpdateRequestModel.fromJson(String str) =>
      AdminProfileUpdateRequestModel.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory AdminProfileUpdateRequestModel.fromMap(Map<String, dynamic> json) =>
      AdminProfileUpdateRequestModel(
        nama: json["nama"],
        email: json["email"],
        username: json["username"],
        password: json["password"],
        passwordConfirmation: json["password_confirmation"],
        phone: json["phone"],
        address: json["address"],
        village: json["village"],
        subDistrict: json["sub_district"],
        role: json["role"],
        isActive: json["is_active"],
      );

  Map<String, dynamic> toMap() {
    Map<String, dynamic> data = {};

    if (nama != null && nama!.isNotEmpty) data["nama"] = nama;
    if (email != null && email!.isNotEmpty) data["email"] = email;
    if (username != null && username!.isNotEmpty) data["username"] = username;
    if (password != null && password!.isNotEmpty) {
      data["password"] = password;
      data["password_confirmation"] = passwordConfirmation;
    }
    if (phone != null && phone!.isNotEmpty) data["phone"] = phone;
    if (address != null && address!.isNotEmpty) data["address"] = address;
    if (village != null && village!.isNotEmpty) data["village"] = village;
    if (subDistrict != null && subDistrict!.isNotEmpty)
      data["sub_district"] = subDistrict;
    if (role != null && role!.isNotEmpty) data["role"] = role;
    if (isActive != null) data["is_active"] = isActive;

    return data;
  }

  AdminProfileUpdateRequestModel copyWith({
    String? nama,
    String? email,
    String? username,
    String? password,
    String? passwordConfirmation,
    String? phone,
    String? address,
    String? village,
    String? subDistrict,
    String? role,
    bool? isActive,
    File? photo,
  }) {
    return AdminProfileUpdateRequestModel(
      nama: nama ?? this.nama,
      email: email ?? this.email,
      username: username ?? this.username,
      password: password ?? this.password,
      passwordConfirmation: passwordConfirmation ?? this.passwordConfirmation,
      phone: phone ?? this.phone,
      address: address ?? this.address,
      village: village ?? this.village,
      subDistrict: subDistrict ?? this.subDistrict,
      role: role ?? this.role,
      isActive: isActive ?? this.isActive,
      photoFile: photo ?? this.photoFile,
    );
  }
}
