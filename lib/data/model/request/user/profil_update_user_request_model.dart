import 'dart:convert';
import 'dart:io';


class UserProfileUpdateRequestModel {
  final String? nama;
  final String? password;
  final String? passwordConfirmation;
  final String? phone;
  final String? address;
  final String? village;
  final String? subDistrict;
  final File? photoFile;

  UserProfileUpdateRequestModel({
    this.nama,
    this.password,
    this.passwordConfirmation,
    this.phone,
    this.address,
    this.village,
    this.subDistrict,
    this.photoFile,
  });

  factory UserProfileUpdateRequestModel.fromJson(String str) => 
      UserProfileUpdateRequestModel.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory UserProfileUpdateRequestModel.fromMap(Map<String, dynamic> json) => 
      UserProfileUpdateRequestModel(
        nama: json["nama"],
        password: json["password"],
        passwordConfirmation: json["password_confirmation"],
        phone: json["phone"],
        address: json["address"],
        village: json["village"],
        subDistrict: json["sub_district"],
      );

  Map<String, dynamic> toMap() {
    Map<String, dynamic> data = {};
    
    if (nama != null && nama!.isNotEmpty) data["nama"] = nama;
    if (password != null && password!.isNotEmpty) {
      data["password"] = password;
      data["password_confirmation"] = passwordConfirmation;
    }
    if (phone != null && phone!.isNotEmpty) data["phone"] = phone;
    if (address != null && address!.isNotEmpty) data["address"] = address;
    if (village != null && village!.isNotEmpty) data["village"] = village;
    if (subDistrict != null && subDistrict!.isNotEmpty) data["sub_district"] = subDistrict;
    
    return data;
  }

  UserProfileUpdateRequestModel copyWith({
    String? nama,
    String? password,
    String? passwordConfirmation,
    String? phone,
    String? address,
    String? village,
    String? subDistrict,
    File? photo,
  }) {
    return UserProfileUpdateRequestModel(
      nama: nama ?? this.nama,
      password: password ?? this.password,
      passwordConfirmation: passwordConfirmation ?? this.passwordConfirmation,
      phone: phone ?? this.phone,
      address: address ?? this.address,
      village: village ?? this.village,
      subDistrict: subDistrict ?? this.subDistrict,
      photoFile: photo ?? this.photoFile,
    );
  }
}