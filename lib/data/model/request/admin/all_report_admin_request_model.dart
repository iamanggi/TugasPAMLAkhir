import 'dart:convert';

class UpdateStatusRequestModel {
  final String status;

  UpdateStatusRequestModel({required this.status});

  Map<String, dynamic> toMap() => {
        "status": status,
      };

  String toJson() => json.encode(toMap());
}
