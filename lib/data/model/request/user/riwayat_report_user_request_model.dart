import 'dart:convert';

class RiwayatReportRequestModel {
  final int idUser;

  RiwayatReportRequestModel({required this.idUser});

  factory RiwayatReportRequestModel.fromJson(String str) =>
      RiwayatReportRequestModel.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory RiwayatReportRequestModel.fromMap(Map<String, dynamic> json) =>
      RiwayatReportRequestModel(idUser: json["id_user"]);

  Map<String, dynamic> toMap() => {
        "id_user": idUser,
      };
}
