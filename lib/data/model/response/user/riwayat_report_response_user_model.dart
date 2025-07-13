import 'dart:convert';

class RiwayatReportResponseModel {
  final bool success;
  final String? message;
  final List<Laporan> data;

  RiwayatReportResponseModel({
    required this.success,
    this.message,
    required this.data,
  });

  factory RiwayatReportResponseModel.fromJson(String str) =>
      RiwayatReportResponseModel.fromMap(json.decode(str));

  factory RiwayatReportResponseModel.fromMap(Map<String, dynamic> json) =>
      RiwayatReportResponseModel(
        success: json["success"],
        message: json["message"],
        data: List<Laporan>.from(json["data"].map((x) => Laporan.fromMap(x))),
      );
}

class Laporan {
  final int id;
  final int idUser;
  final int categoryId;
  final String title;
  final String description;
  final String latitude;
  final String longitude;
  final String address;
  final List<String>? photos;
  final String status;
  final String priority;
  final String? adminNotes;
  final DateTime? verifiedAt;
  final DateTime? processedAt;
  final DateTime? completedAt;
  final int? verifiedBy;
  final DateTime createdAt;
  final DateTime updatedAt;

  Laporan({
    required this.id,
    required this.idUser,
    required this.categoryId,
    required this.title,
    required this.description,
    required this.latitude,
    required this.longitude,
    required this.address,
    this.photos,
    required this.status,
    required this.priority,
    this.adminNotes,
    this.verifiedAt,
    this.processedAt,
    this.completedAt,
    this.verifiedBy,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Laporan.fromMap(Map<String, dynamic> map) {
    return Laporan(
      id: map['id'],
      idUser: map['id_user'],
      categoryId: map['category_id'],
      title: map['title'],
      description: map['description'],
      latitude: map['latitude'],
      longitude: map['longitude'],
      address: map['address'],
      photos: map['photos'] != null ? List<String>.from(map['photos']) : null,
      status: map['status'],
      priority: map['priority'],
      adminNotes: map['admin_notes'],
      verifiedAt:
          map['verified_at'] != null
              ? DateTime.tryParse(map['verified_at'])
              : null,
      processedAt:
          map['processed_at'] != null
              ? DateTime.tryParse(map['processed_at'])
              : null,
      completedAt:
          map['completed_at'] != null
              ? DateTime.tryParse(map['completed_at'])
              : null,
      verifiedBy: map['verified_by'],
      createdAt: DateTime.parse(map['created_at']),
      updatedAt: DateTime.parse(map['updated_at']),
    );
  }
}
