import 'dart:convert';

class LoginResponseModel {
  final bool? success;
  final String? message;
  final Data? data;

  LoginResponseModel({
    this.success,
    this.message,
    this.data,
  });

  factory LoginResponseModel.fromJson(String str) =>
      LoginResponseModel.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory LoginResponseModel.fromMap(Map<String, dynamic> json) =>
      LoginResponseModel(
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
  final int? idUser;
  final String? nama;
  final String? username;
  final String? email;
  final String? role;

  User({
    this.idUser,
    this.nama,
    this.username,
    this.email,
    this.role,
  });

  factory User.fromJson(String str) => User.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory User.fromMap(Map<String, dynamic> json) => User(
        idUser: json["id_user"],
        nama: json["nama"],
        username: json["username"],
        email: json["email"],
        role: json["role"],
      );

  Map<String, dynamic> toMap() => {
        "id_user": idUser,
        "nama": nama,
        "username": username,
        "email": email,
        "role": role,
      };
}
