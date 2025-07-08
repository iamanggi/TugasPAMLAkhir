import 'dart:convert';

class DashboardAdminResponseModel {
  final bool? success;
  final AdminDashboardData? data;

  DashboardAdminResponseModel({
    this.success,
    this.data,
  });

  factory DashboardAdminResponseModel.fromJson(String str) =>
      DashboardAdminResponseModel.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory DashboardAdminResponseModel.fromMap(Map<String, dynamic> json) =>
      DashboardAdminResponseModel(
        success: json["success"],
        data: json["data"] == null ? null : AdminDashboardData.fromMap(json["data"]),
      );

  Map<String, dynamic> toMap() => {
        "success": success,
        "data": data?.toMap(),
      };
}

class AdminDashboardData {
  final AdminUser? user; // ✅ DITAMBAHKAN
  final AdminStats? stats;
  final List<ReportsByCategory>? reportsByCategory;
  final List<ReportsTrend>? reportsTrend;
  final List<MonthlyReports>? monthlyReports;
  final List<RecentReport>? recentReports;
  final List<PriorityArea>? priorityAreas;
  final PerformanceMetrics? performanceMetrics;

  AdminDashboardData({
    this.user,
    this.stats,
    this.reportsByCategory,
    this.reportsTrend,
    this.monthlyReports,
    this.recentReports,
    this.priorityAreas,
    this.performanceMetrics,
  });

  factory AdminDashboardData.fromJson(String str) =>
      AdminDashboardData.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory AdminDashboardData.fromMap(Map<String, dynamic> json) =>
      AdminDashboardData(
        user: json["user"] == null ? null : AdminUser.fromMap(json["user"]),
        stats: json["stats"] == null ? null : AdminStats.fromMap(json["stats"]),
        reportsByCategory: json["reportsByCategory"] == null
            ? null
            : List<ReportsByCategory>.from(
                json["reportsByCategory"].map((x) => ReportsByCategory.fromMap(x))),
        reportsTrend: json["reportsTrend"] == null
            ? null
            : List<ReportsTrend>.from(
                json["reportsTrend"].map((x) => ReportsTrend.fromMap(x))),
        monthlyReports: json["monthlyReports"] == null
            ? null
            : List<MonthlyReports>.from(
                json["monthlyReports"].map((x) => MonthlyReports.fromMap(x))),
        recentReports: json["recentReports"] == null
            ? null
            : List<RecentReport>.from(
                json["recentReports"].map((x) => RecentReport.fromMap(x))),
        priorityAreas: json["priorityAreas"] == null
            ? null
            : List<PriorityArea>.from(
                json["priorityAreas"].map((x) => PriorityArea.fromMap(x))),
        performanceMetrics: json["performanceMetrics"] == null 
            ? null 
            : PerformanceMetrics.fromMap(json["performanceMetrics"]),
      );

  Map<String, dynamic> toMap() => {
        "user": user?.toMap(),
        "stats": stats?.toMap(),
        "reportsByCategory": reportsByCategory?.map((x) => x.toMap()).toList(),
        "reportsTrend": reportsTrend?.map((x) => x.toMap()).toList(),
        "monthlyReports": monthlyReports?.map((x) => x.toMap()).toList(),
        "recentReports": recentReports?.map((x) => x.toMap()).toList(),
        "priorityAreas": priorityAreas?.map((x) => x.toMap()).toList(),
        "performanceMetrics": performanceMetrics?.toMap(),
      };
}

class AdminStats {
  final int? totalReports;
  final int? totalUsers;
  final int? totalCategories;
  final int? pendingReports;
  final int? verifiedReports;
  final int? inProgressReports;
  final int? completedReports;
  final int? rejectedReports;
  final int? reportsToday;
  final int? newUsersToday;
  final int? reportsThisWeek;
  final int? reportsThisMonth;
  final double? averageRating;
  final int? totalRatings;

  AdminStats({
    this.totalReports,
    this.totalUsers,
    this.totalCategories,
    this.pendingReports,
    this.verifiedReports,
    this.inProgressReports,
    this.completedReports,
    this.rejectedReports,
    this.reportsToday,
    this.newUsersToday,
    this.reportsThisWeek,
    this.reportsThisMonth,
    this.averageRating,
    this.totalRatings,
  });

  factory AdminStats.fromMap(Map<String, dynamic> json) => AdminStats(
        totalReports: json["total_reports"],
        totalUsers: json["total_users"],
        totalCategories: json["total_categories"],
        pendingReports: json["pending_reports"],
        verifiedReports: json["verified_reports"],
        inProgressReports: json["in_progress_reports"],
        completedReports: json["completed_reports"],
        rejectedReports: json["rejected_reports"],
        reportsToday: json["reports_today"],
        newUsersToday: json["new_users_today"],
        reportsThisWeek: json["reports_this_week"],
        reportsThisMonth: json["reports_this_month"],
        averageRating: json["average_rating"]?.toDouble(),
        totalRatings: json["total_ratings"],
      );

  Map<String, dynamic> toMap() => {
        "total_reports": totalReports,
        "total_users": totalUsers,
        "total_categories": totalCategories,
        "pending_reports": pendingReports,
        "verified_reports": verifiedReports,
        "in_progress_reports": inProgressReports,
        "completed_reports": completedReports,
        "rejected_reports": rejectedReports,
        "reports_today": reportsToday,
        "new_users_today": newUsersToday,
        "reports_this_week": reportsThisWeek,
        "reports_this_month": reportsThisMonth,
        "average_rating": averageRating,
        "total_ratings": totalRatings,
      };
}

class ReportsByCategory {
  final String? category;
  final int? count;
  final String? color;

  ReportsByCategory({
    this.category,
    this.count,
    this.color,
  });

  factory ReportsByCategory.fromMap(Map<String, dynamic> json) => ReportsByCategory(
        category: json["category"],
        count: json["count"],
        color: json["color"],
      );

  Map<String, dynamic> toMap() => {
        "category": category,
        "count": count,
        "color": color,
      };
}

class ReportsTrend {
  final String? date;
  final String? day;
  final int? count;

  ReportsTrend({
    this.date,
    this.day,
    this.count,
  });

  factory ReportsTrend.fromMap(Map<String, dynamic> json) => ReportsTrend(
        date: json["date"],
        day: json["day"],
        count: json["count"],
      );

  get total => null;
  get bulan => null;

  Map<String, dynamic> toMap() => {
        "date": date,
        "day": day,
        "count": count,
      };
}

class MonthlyReports {
  final String? month;
  final int? count;

  MonthlyReports({
    this.month,
    this.count,
  });

  factory MonthlyReports.fromMap(Map<String, dynamic> json) => MonthlyReports(
        month: json["month"],
        count: json["count"],
      );

  Map<String, dynamic> toMap() => {
        "month": month,
        "count": count,
      };
}

class RecentReport {
  final int? id;
  final String? title;
  final String? status;
  final String? category;
  final String? user;
  final String? createdAt;
  final String? location;

  RecentReport({
    this.id,
    this.title,
    this.status,
    this.category,
    this.user,
    this.createdAt,
    this.location,
  });

  factory RecentReport.fromMap(Map<String, dynamic> json) => RecentReport(
        id: json["id"],
        title: json["title"],
        status: json["status"],
        category: json["category"],
        user: json["user"],
        createdAt: json["created_at"],
        location: json["location"],
      );

  Map<String, dynamic> toMap() => {
        "id": id,
        "title": title,
        "status": status,
        "category": category,
        "user": user,
        "created_at": createdAt,
        "location": location,
      };
}

class PriorityArea {
  final String? village;
  final int? reportCount;

  PriorityArea({
    this.village,
    this.reportCount,
  });

  factory PriorityArea.fromMap(Map<String, dynamic> json) => PriorityArea(
        village: json["village"],
        reportCount: json["report_count"],
      );

  get judul => null;
  get deskripsi => null;

  Map<String, dynamic> toMap() => {
        "village": village,
        "report_count": reportCount,
      };
}

class PerformanceMetrics {
  final double? completionRate;
  final double? avgResolutionTimeDays;
  final double? customerSatisfaction;
  final double? responseRate;
  final int? totalPemeliharaan;

  PerformanceMetrics({
    this.completionRate,
    this.avgResolutionTimeDays,
    this.customerSatisfaction,
    this.responseRate,
    this.totalPemeliharaan,
  });

  factory PerformanceMetrics.fromMap(Map<String, dynamic> json) => PerformanceMetrics(
        completionRate: json["completion_rate"]?.toDouble(),
        avgResolutionTimeDays: json["avg_resolution_time_days"]?.toDouble(),
        customerSatisfaction: json["customer_satisfaction"]?.toDouble(),
        responseRate: json["response_rate"]?.toDouble(),
        totalPemeliharaan: json["total_pemeliharaan"],
      );

  Map<String, dynamic> toMap() => {
        "completion_rate": completionRate,
        "avg_resolution_time_days": avgResolutionTimeDays,
        "customer_satisfaction": customerSatisfaction,
        "response_rate": responseRate,
        "total_pemeliharaan": totalPemeliharaan,
      };
}

class AdminUser {
  final int? idUser;
  final String? nama;
  final String? username;
  final String? email;
  final String? role;
  final String? photo;
  final String? bahasa;
  final String? phone;
  final String? address;
  final String? village;
  final String? subDistrict;
  final int? isActive;
  final String? createdAt;
  final String? updatedAt;

  AdminUser({
    this.idUser,
    this.nama,
    this.username,
    this.email,
    this.role,
    this.photo,
    this.bahasa,
    this.phone,
    this.address,
    this.village,
    this.subDistrict,
    this.isActive,
    this.createdAt,
    this.updatedAt,
  });

  factory AdminUser.fromMap(Map<String, dynamic> json) => AdminUser(
        idUser: json["id_user"],
        nama: json["nama"],
        username: json["username"],
        email: json["email"],
        role: json["role"],
        photo: json["photo"],
        bahasa: json["bahasa"],
        phone: json["phone"],
        address: json["address"],
        village: json["village"],
        subDistrict: json["sub_district"],
        isActive: json["is_active"],
        createdAt: json["created_at"],
        updatedAt: json["updated_at"],
      );

  Map<String, dynamic> toMap() => {
        "id_user": idUser,
        "nama": nama,
        "username": username,
        "email": email,
        "role": role,
        "photo": photo,
        "bahasa": bahasa,
        "phone": phone,
        "address": address,
        "village": village,
        "sub_district": subDistrict,
        "is_active": isActive,
        "created_at": createdAt,
        "updated_at": updatedAt,
      };
      Map<String, dynamic> toJson() => toMap();
}
