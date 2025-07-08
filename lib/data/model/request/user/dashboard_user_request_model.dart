import 'dart:convert';

// Request model untuk dashboard - biasanya berisi parameter query
class DashboardUserRequestModel {
  final String? userId;
  final int? page;
  final int? limit;
  final String? dateFrom;
  final String? dateTo;
  final List<String>? filters;

  DashboardUserRequestModel({
    this.userId,
    this.page,
    this.limit,
    this.dateFrom,
    this.dateTo,
    this.filters,
  });

  factory DashboardUserRequestModel.fromJson(String str) =>
      DashboardUserRequestModel.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory DashboardUserRequestModel.fromMap(Map<String, dynamic> json) =>
      DashboardUserRequestModel(
        userId: json["user_id"],
        page: json["page"],
        limit: json["limit"],
        dateFrom: json["date_from"],
        dateTo: json["date_to"],
        filters: json["filters"] == null
            ? null
            : List<String>.from(json["filters"]),
      );

  Map<String, dynamic> toMap() => {
        "user_id": userId,
        "page": page,
        "limit": limit,
        "date_from": dateFrom,
        "date_to": dateTo,
        "filters": filters,
      };
}

// Response model untuk dashboard - berisi data yang diterima
class DashboardUserResponseModel {
  final bool? success;
  final String? message;
  final Data? data;

  DashboardUserResponseModel({
    this.success,
    this.message,
    this.data,
  });

  factory DashboardUserResponseModel.fromJson(String str) =>
      DashboardUserResponseModel.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory DashboardUserResponseModel.fromMap(Map<String, dynamic> json) =>
      DashboardUserResponseModel(
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
  final Stats? stats;
  final List<Pemeliharaan>? pemeliharaan;

  Data({
    this.user,
    this.stats,
    this.pemeliharaan,
  });

  factory Data.fromJson(String str) => Data.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory Data.fromMap(Map<String, dynamic> json) => Data(
        user: json["user"] == null ? null : User.fromMap(json["user"]),
        stats: json["stats"] == null ? null : Stats.fromMap(json["stats"]),
        pemeliharaan: json["pemeliharaan"] == null
            ? null
            : List<Pemeliharaan>.from(
                json["pemeliharaan"].map((x) => Pemeliharaan.fromMap(x))),
      );


  Map<String, dynamic> toMap() => {
        "user": user?.toMap(),
        "stats": stats?.toMap(),
        "pemeliharaan": pemeliharaan?.map((x) => x.toMap()).toList(),
      };
}

class User {
  final String? nama;
  final String? photo;

  User({
    this.nama,
    this.photo,
  });

  factory User.fromJson(String str) => User.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory User.fromMap(Map<String, dynamic> json) => User(
        nama: json["nama"],
        photo: json["photo"],
      );

  Map<String, dynamic> toMap() => {
        "nama": nama,
        "photo": photo,
      };
}

class Stats {
  final int? totalReports;
  final int? pendingReports;
  final int? completedReports;
  final int? inProgressReports;

  Stats({
    this.totalReports,
    this.pendingReports,
    this.completedReports,
    this.inProgressReports,
  });

  factory Stats.fromJson(String str) => Stats.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory Stats.fromMap(Map<String, dynamic> json) => Stats(
        totalReports: json["total_reports"],
        pendingReports: json["pending_reports"],
        completedReports: json["completed_reports"],
        inProgressReports: json["in_progress_reports"],
      );

  Map<String, dynamic> toMap() => {
        "total_reports": totalReports,
        "pending_reports": pendingReports,
        "completed_reports": completedReports,
        "in_progress_reports": inProgressReports,
      };
}

class Pemeliharaan {
  final int? id;
  final String? namaFasilitas;
  final String? deskripsi;
  final String? tglPemeliharaan;
  final String? catatan;
  final String? foto;
  final String? laporanJudul;

  Pemeliharaan({
    this.id,
    this.namaFasilitas,
    this.deskripsi,
    this.tglPemeliharaan,
    this.catatan,
    this.foto,
    this.laporanJudul,
  });

  factory Pemeliharaan.fromJson(String str) =>
      Pemeliharaan.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory Pemeliharaan.fromMap(Map<String, dynamic> json) => Pemeliharaan(
        id: json["id"],
        namaFasilitas: json["nama_fasilitas"],
        deskripsi: json["deskripsi"],
        tglPemeliharaan: json["tgl_pemeliharaan"],
        catatan: json["catatan"],
        foto: json["foto"],
        laporanJudul: json["laporan_judul"],
      );

  Map<String, dynamic> toMap() => {
        "id": id,
        "nama_fasilitas": namaFasilitas,
        "deskripsi": deskripsi,
        "tgl_pemeliharaan": tglPemeliharaan,
        "catatan": catatan,
        "foto": foto,
        "laporan_judul": laporanJudul,
      };
}