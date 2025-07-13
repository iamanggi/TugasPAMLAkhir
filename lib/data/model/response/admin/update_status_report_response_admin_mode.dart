import 'dart:convert';

class UpdateStatusResponseModel {
  final bool success;
  final String message;

  UpdateStatusResponseModel({
    required this.success,
    required this.message,
  });

  factory UpdateStatusResponseModel.fromJson(String str) =>
      UpdateStatusResponseModel.fromMap(json.decode(str));

  factory UpdateStatusResponseModel.fromMap(Map<String, dynamic> json) =>
      UpdateStatusResponseModel(
        success: json["success"],
        message: json["message"] ?? '',
      );
}
