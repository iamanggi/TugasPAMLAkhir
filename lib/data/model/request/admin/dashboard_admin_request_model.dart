import 'dart:convert';

class DashboardAdminRequestModel {
  final String? dateRange;
  final String? category;
  final String? status;
  final int? page;
  final int? limit;

  DashboardAdminRequestModel({
    this.dateRange,
    this.category,
    this.status,
    this.page,
    this.limit,
  });

  factory DashboardAdminRequestModel.fromJson(String str) =>
      DashboardAdminRequestModel.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory DashboardAdminRequestModel.fromMap(Map<String, dynamic> json) =>
      DashboardAdminRequestModel(
        dateRange: json["date_range"],
        category: json["category"],
        status: json["status"],
        page: json["page"],
        limit: json["limit"],
      );

  Map<String, dynamic> toMap() => {
        "date_range": dateRange,
        "category": category,
        "status": status,
        "page": page,
        "limit": limit,
      };

  // Tambahan opsional
  DashboardAdminRequestModel copyWith({
    String? dateRange,
    String? category,
    String? status,
    int? page,
    int? limit,
  }) {
    return DashboardAdminRequestModel(
      dateRange: dateRange ?? this.dateRange,
      category: category ?? this.category,
      status: status ?? this.status,
      page: page ?? this.page,
      limit: limit ?? this.limit,
    );
  }

  // Untuk kebutuhan URL query
  Map<String, String> toQueryParams() {
    final map = <String, String>{};
    if (dateRange != null) map["date_range"] = dateRange!;
    if (category != null) map["category"] = category!;
    if (status != null) map["status"] = status!;
    if (page != null) map["page"] = page.toString();
    if (limit != null) map["limit"] = limit.toString();
    return map;
  }

  factory DashboardAdminRequestModel.withDefault() {
    return DashboardAdminRequestModel(
      page: 1,
      limit: 10,
    );
  }
}
