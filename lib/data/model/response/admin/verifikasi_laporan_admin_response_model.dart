import 'dart:convert';

class VerifikasiLaporanResponseModel {
  final bool success;
  final String message;
  final VerifikasiLaporanData? data;

  VerifikasiLaporanResponseModel({
    required this.success,
    required this.message,
    this.data,
  });

  factory VerifikasiLaporanResponseModel.fromJson(String str) =>
      VerifikasiLaporanResponseModel.fromMap(json.decode(str));

  factory VerifikasiLaporanResponseModel.fromMap(Map<String, dynamic> json) =>
      VerifikasiLaporanResponseModel(
        success: json["success"],
        message: json["message"],
        data: json["data"] != null ? VerifikasiLaporanData.fromMap(json["data"]) : null,
      );
}

class VerifikasiLaporanData {
  final String laporanId;
  final String status;
  final String? alasan;

  VerifikasiLaporanData({
    required this.laporanId,
    required this.status,
    this.alasan,
  });

  factory VerifikasiLaporanData.fromMap(Map<String, dynamic> json) => VerifikasiLaporanData(
        laporanId: json["laporan_id"],
        status: json["status"],
        alasan: json["alasan"],
      );
}
