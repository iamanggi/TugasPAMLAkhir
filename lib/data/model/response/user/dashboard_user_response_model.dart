import 'dart:convert';

class DashboardUserResponseModel {
  final bool? success;
  final Data? data;

  DashboardUserResponseModel({
    this.success,
    this.data,
  });

  factory DashboardUserResponseModel.fromJson(String str) =>
      DashboardUserResponseModel.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory DashboardUserResponseModel.fromMap(Map<String, dynamic> json) =>
      DashboardUserResponseModel(
        success: json["success"],
        data: json["data"] == null ? null : Data.fromMap(json["data"]),
      );

  Map<String, dynamic> toMap() => {
        "success": success,
        "data": data?.toMap(),
      };
}

class Data {
  final User? user;
  final Stats? stats;
  final List<dynamic>? pemeliharaan; 
  final String? photoUrl;

  Data({
    this.user,
    this.stats,
    this.pemeliharaan,
    this.photoUrl,
  });

  factory Data.fromJson(String str) => Data.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory Data.fromMap(Map<String, dynamic> json) => Data(
        user: json["user"] == null ? null : User.fromMap(json["user"]),
        stats: json["stats"] == null ? null : Stats.fromMap(json["stats"]),
        pemeliharaan: json["pemeliharaan"] == null
            ? null
            : List<dynamic>.from(json["pemeliharaan"]),
             photoUrl: json["photo_url"],
      );

  Map<String, dynamic> toMap() => {
        "user": user?.toMap(),
        "stats": stats?.toMap(),
        "pemeliharaan": pemeliharaan,
        "photo_url": photoUrl,
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
