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

    factory RegisterResponseModel.fromJson(String str) => RegisterResponseModel.fromMap(json.decode(str));

    String toJson() => json.encode(toMap());

    factory RegisterResponseModel.fromMap(Map<String, dynamic> json) => RegisterResponseModel(
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
    final String? user;
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
        user: json["user"],
        token: json["token"],
        tokenType: json["token_type"],
    );

    Map<String, dynamic> toMap() => {
        "user": user,
        "token": token,
        "token_type": tokenType,
    };
}
  