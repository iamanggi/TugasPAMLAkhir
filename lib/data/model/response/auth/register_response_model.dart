import 'dart:convert';

class RegisterResponseModel {
  final bool? success;
  final String? message;
  final Data? data;

  RegisterResponseModel({
    this.success,
    this.message,
    this.data,
  });

  factory RegisterResponseModel.fromJson(String str) =>
      RegisterResponseModel.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory RegisterResponseModel.fromMap(Map<String, dynamic> json) =>
      RegisterResponseModel(
        success: json["success"],
        message: json["message"],
        data: json["data"] == null ? null : Data.fromMap(json["data"]),
      );

  Map<String, dynamic> toMap() => {
        "success": success,
        "message": message,
        "data": data?.toMap(),
      };
}

class Data {
  final User? user;
  final String? token;
  final String? tokenType;

  Data({
    this.user,
    this.token,
    this.tokenType,
  });

  factory Data.fromJson(String str) => Data.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory Data.fromMap(Map<String, dynamic> json) => Data(
        user: json["user"] == null ? null : User.fromMap(json["user"]),
        token: json["token"],
        tokenType: json["token_type"],
      );

  Map<String, dynamic> toMap() => {
        "user": user?.toMap(),
        "token": token,
        "token_type": tokenType,
      };
}

class User {
  final int? id;
  final String? nama;
  final String? email;
  final String? username;
  final String? role;

  User({
    this.id,
    this.nama,
    this.email,
    this.username,
    this.role,
  });

  factory User.fromJson(String str) => User.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory User.fromMap(Map<String, dynamic> json) => User(
        id: json["id"],
        nama: json["nama"],
        email: json["email"],
        username: json["username"],
        role: json["role"],
      );

  Map<String, dynamic> toMap() => {
        "id": id,
        "nama": nama,
        "email": email,
        "username": username,
        "role": role,
      };
}
