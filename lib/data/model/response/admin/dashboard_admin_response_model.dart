// dashboard_admin_response_model.dart

class User {
  final String? nama;
  final String? email;
  
  User({this.nama, this.email});
  
  factory User.fromMap(Map<String, dynamic> json) {
    return User(
      nama: json['nama'] as String?,
      email: json['email'] as String?,
    );
  }
  
  factory User.fromJson(Map<String, dynamic> json) => User.fromMap(json);
  
  Map<String, dynamic> toJson() {
    return {
      'nama': nama,
      'email': email,
    };
  }
  
  Map<String, dynamic> toMap() => toJson();
}

class AdminDashboardData {
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
  final User? user;

  AdminDashboardData({
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
    this.user,
  });

  factory AdminDashboardData.fromMap(Map<String, dynamic> json) {
    return AdminDashboardData(
      totalReports: json['total_reports'] as int?,
      totalUsers: json['total_users'] as int?,
      totalCategories: json['total_categories'] as int?,
      pendingReports: json['pending_reports'] as int?,
      verifiedReports: json['verified_reports'] as int?,
      inProgressReports: json['in_progress_reports'] as int?,
      completedReports: json['completed_reports'] as int?,
      rejectedReports: json['rejected_reports'] as int?,
      reportsToday: json['reports_today'] as int?,
      newUsersToday: json['new_users_today'] as int?,
      reportsThisWeek: json['reports_this_week'] as int?,
      reportsThisMonth: json['reports_this_month'] as int?,
      averageRating: (json['average_rating'] as num?)?.toDouble(),
      totalRatings: json['total_ratings'] as int?,
      user: json['user'] != null ? User.fromMap(json['user']) : null,
    );
  }

  factory AdminDashboardData.fromJson(Map<String, dynamic> json) => AdminDashboardData.fromMap(json);

  Map<String, dynamic> toJson() {
    return {
      'total_reports': totalReports,
      'total_users': totalUsers,
      'total_categories': totalCategories,
      'pending_reports': pendingReports,
      'verified_reports': verifiedReports,
      'in_progress_reports': inProgressReports,
      'completed_reports': completedReports,
      'rejected_reports': rejectedReports,
      'reports_today': reportsToday,
      'new_users_today': newUsersToday,
      'reports_this_week': reportsThisWeek,
      'reports_this_month': reportsThisMonth,
      'average_rating': averageRating,
      'total_ratings': totalRatings,
      'user': user?.toJson(),
    };
  }
  
  Map<String, dynamic> toMap() => toJson();
}

// Create AdminStats as an alias for backward compatibility
class AdminStats extends AdminDashboardData {
  AdminStats({
    super.totalReports,
    super.totalUsers,
    super.totalCategories,
    super.pendingReports,
    super.verifiedReports,
    super.inProgressReports,
    super.completedReports,
    super.rejectedReports,
    super.reportsToday,
    super.newUsersToday,
    super.reportsThisWeek,
    super.reportsThisMonth,
    super.averageRating,
    super.totalRatings,
    super.user,
  });

  factory AdminStats.fromMap(Map<String, dynamic> json) {
    return AdminStats(
      totalReports: json['total_reports'] as int?,
      totalUsers: json['total_users'] as int?,
      totalCategories: json['total_categories'] as int?,
      pendingReports: json['pending_reports'] as int?,
      verifiedReports: json['verified_reports'] as int?,
      inProgressReports: json['in_progress_reports'] as int?,
      completedReports: json['completed_reports'] as int?,
      rejectedReports: json['rejected_reports'] as int?,
      reportsToday: json['reports_today'] as int?,
      newUsersToday: json['new_users_today'] as int?,
      reportsThisWeek: json['reports_this_week'] as int?,
      reportsThisMonth: json['reports_this_month'] as int?,
      averageRating: (json['average_rating'] as num?)?.toDouble(),
      totalRatings: json['total_ratings'] as int?,
      user: json['user'] != null ? User.fromMap(json['user']) : null,
    );
  }

  factory AdminStats.fromJson(Map<String, dynamic> json) => AdminStats.fromMap(json);
}

class ReportsByCategory {
  final String? categoryName;
  final int? reportCount;
  final double? percentage;
  final String? categoryId;

  ReportsByCategory({
    this.categoryName,
    this.reportCount,
    this.percentage,
    this.categoryId,
  });

  factory ReportsByCategory.fromMap(Map<String, dynamic> json) {
    return ReportsByCategory(
      categoryName: json['category_name'] as String?,
      reportCount: json['report_count'] as int?,
      percentage: (json['percentage'] as num?)?.toDouble(),
      categoryId: json['category_id'] as String?,
    );
  }

  factory ReportsByCategory.fromJson(Map<String, dynamic> json) => ReportsByCategory.fromMap(json);

  Map<String, dynamic> toJson() {
    return {
      'category_name': categoryName,
      'report_count': reportCount,
      'percentage': percentage,
      'category_id': categoryId,
    };
  }
  
  Map<String, dynamic> toMap() => toJson();
}

class ReportsTrend {
  final String? date;
  final int? reportCount;
  final String? period;

  ReportsTrend({
    this.date,
    this.reportCount,
    this.period,
  });

  factory ReportsTrend.fromMap(Map<String, dynamic> json) {
    return ReportsTrend(
      date: json['date'] as String?,
      reportCount: json['report_count'] as int?,
      period: json['period'] as String?,
    );
  }

  factory ReportsTrend.fromJson(Map<String, dynamic> json) => ReportsTrend.fromMap(json);

  Map<String, dynamic> toJson() {
    return {
      'date': date,
      'report_count': reportCount,
      'period': period,
    };
  }
  
  Map<String, dynamic> toMap() => toJson();
}

class PriorityArea {
  final String? areaName;
  final int? reportCount;
  final String? priority;
  final double? latitude;
  final double? longitude;

  PriorityArea({
    this.areaName,
    this.reportCount,
    this.priority,
    this.latitude,
    this.longitude,
  });

  factory PriorityArea.fromMap(Map<String, dynamic> json) {
    return PriorityArea(
      areaName: json['area_name'] as String?,
      reportCount: json['report_count'] as int?,
      priority: json['priority'] as String?,
      latitude: (json['latitude'] as num?)?.toDouble(),
      longitude: (json['longitude'] as num?)?.toDouble(),
    );
  }

  factory PriorityArea.fromJson(Map<String, dynamic> json) => PriorityArea.fromMap(json);

  Map<String, dynamic> toJson() {
    return {
      'area_name': areaName,
      'report_count': reportCount,
      'priority': priority,
      'latitude': latitude,
      'longitude': longitude,
    };
  }
  
  Map<String, dynamic> toMap() => toJson();
}

class RecentReport {
  final String? id;
  final String? title;
  final String? description;
  final String? status;
  final String? category;
  final String? createdAt;
  final String? location;
  final String? reporterName;

  RecentReport({
    this.id,
    this.title,
    this.description,
    this.status,
    this.category,
    this.createdAt,
    this.location,
    this.reporterName,
  });

  factory RecentReport.fromMap(Map<String, dynamic> json) {
    return RecentReport(
      id: json['id'] as String?,
      title: json['title'] as String?,
      description: json['description'] as String?,
      status: json['status'] as String?,
      category: json['category'] as String?,
      createdAt: json['created_at'] as String?,
      location: json['location'] as String?,
      reporterName: json['reporter_name'] as String?,
    );
  }

  factory RecentReport.fromJson(Map<String, dynamic> json) => RecentReport.fromMap(json);

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'status': status,
      'category': category,
      'created_at': createdAt,
      'location': location,
      'reporter_name': reporterName,
    };
  }
  
  Map<String, dynamic> toMap() => toJson();
}

class PerformanceMetrics {
  final double? averageResponseTime;
  final double? resolutionRate;
  final int? activeUsers;
  final double? userSatisfaction;
  final int? totalInteractions;

  PerformanceMetrics({
    this.averageResponseTime,
    this.resolutionRate,
    this.activeUsers,
    this.userSatisfaction,
    this.totalInteractions,
  });

  factory PerformanceMetrics.fromMap(Map<String, dynamic> json) {
    return PerformanceMetrics(
      averageResponseTime: (json['average_response_time'] as num?)?.toDouble(),
      resolutionRate: (json['resolution_rate'] as num?)?.toDouble(),
      activeUsers: json['active_users'] as int?,
      userSatisfaction: (json['user_satisfaction'] as num?)?.toDouble(),
      totalInteractions: json['total_interactions'] as int?,
    );
  }

  factory PerformanceMetrics.fromJson(Map<String, dynamic> json) => PerformanceMetrics.fromMap(json);

  Map<String, dynamic> toJson() {
    return {
      'average_response_time': averageResponseTime,
      'resolution_rate': resolutionRate,
      'active_users': activeUsers,
      'user_satisfaction': userSatisfaction,
      'total_interactions': totalInteractions,
    };
  }
  
  Map<String, dynamic> toMap() => toJson();
}

class DashboardAdminResponseModel {
  final bool success;
  final AdminDashboardData? data;
  final String? message;

  DashboardAdminResponseModel({
    required this.success,
    this.data,
    this.message,
  });

  factory DashboardAdminResponseModel.fromMap(Map<String, dynamic> json) {
    return DashboardAdminResponseModel(
      success: json['success'] as bool? ?? false,
      data: json['data'] != null ? AdminDashboardData.fromMap(json['data']) : null,
      message: json['message'] as String?,
    );
  }

  factory DashboardAdminResponseModel.fromJson(Map<String, dynamic> json) => DashboardAdminResponseModel.fromMap(json);

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'data': data?.toJson(),
      'message': message,
    };
  }
  
  Map<String, dynamic> toMap() => toJson();
}