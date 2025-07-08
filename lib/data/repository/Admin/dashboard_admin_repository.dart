// repositories/dashboard_admin_repository.dart
import 'dart:convert';
import 'dart:developer';

import 'package:dartz/dartz.dart';
import 'package:tilik_desa/data/model/response/admin/dashboard_admin_response_model.dart';
import 'package:tilik_desa/services/services_http_client.dart';

class DashboardAdminRepository {
  final ServiceHttpClient _serviceHttpClient;

  DashboardAdminRepository(this._serviceHttpClient);

  Future<Either<String, DashboardAdminResponseModel>> getDashboardData() async {
    return _getData<DashboardAdminResponseModel>(
      endpoint: "dashboard/admin/stats",
      parser: (json) => DashboardAdminResponseModel.fromMap(json),
      errorMessage: "Gagal mengambil data dashboard admin",
    );
  }

  Future<Either<String, DashboardAdminResponseModel>> refreshDashboard() async {
    return getDashboardData();
  }

  Future<Either<String, AdminStats>> getAdminStats() async {
    return _getData<AdminStats>(
      endpoint: "dashboard/admin/stats",
      parser: (json) => AdminStats.fromMap(json['data']),
      errorMessage: "Gagal mengambil data statistik admin",
    );
  }

  Future<Either<String, List<ReportsByCategory>>> getReportsByCategory() async {
    return _getListData<ReportsByCategory>(
      endpoint: "dashboard/admin/reports-by-category",
      parser: (e) => ReportsByCategory.fromMap(e),
      errorMessage: "Gagal mengambil data kategori laporan",
    );
  }

  Future<Either<String, List<ReportsTrend>>> getReportsTrend() async {
    return _getListData<ReportsTrend>(
      endpoint: "dashboard/admin/reports-trend",
      parser: (e) => ReportsTrend.fromMap(e),
      errorMessage: "Gagal mengambil data tren laporan",
    );
  }

  Future<Either<String, List<PriorityArea>>> getPriorityAreas() async {
    return _getListData<PriorityArea>(
      endpoint: "dashboard/admin/priority-areas",
      parser: (e) => PriorityArea.fromMap(e),
      errorMessage: "Gagal mengambil data area prioritas",
    );
  }

  Future<Either<String, List<RecentReport>>> getRecentReports() async {
    return _getListData<RecentReport>(
      endpoint: "dashboard/admin/recent-reports",
      parser: (e) => RecentReport.fromMap(e),
      errorMessage: "Gagal mengambil data laporan terbaru",
    );
  }

  Future<Either<String, PerformanceMetrics>> getPerformanceMetrics() async {
    return _getData<PerformanceMetrics>(
      endpoint: "dashboard/admin/performance-metrics",
      parser: (json) => PerformanceMetrics.fromMap(json['data']),
      errorMessage: "Gagal mengambil data metrik performa",
    );
  }

  Future<Either<String, T>> _getData<T>({
    required String endpoint,
    required T Function(Map<String, dynamic>) parser,
    required String errorMessage,
  }) async {
    try {
      final response = await _serviceHttpClient.get(endpoint);

      if (response.body == null || response.body.isEmpty) {
        return const Left("Data tidak ditemukan");
      }

      final decoded = json.decode(response.body);
      if (decoded is! Map<String, dynamic>) {
        return const Left("Format data tidak valid");
      }

      if (response.statusCode == 200) {
        return Right(parser(decoded));
      } else {
        final msg = decoded['message'] as String? ?? errorMessage;
        return Left(msg);
      }
    } catch (e) {
      log("Error [$endpoint]: $e");
      return Left("Terjadi kesalahan saat mengambil data");
    }
  }

  Future<Either<String, List<T>>> _getListData<T>({
    required String endpoint,
    required T Function(dynamic) parser,
    required String errorMessage,
  }) async {
    try {
      final response = await _serviceHttpClient.get(endpoint);

      if (response.body == null || response.body.isEmpty) {
        return const Left("Data tidak ditemukan");
      }

      final decoded = json.decode(response.body);
      if (decoded is! Map<String, dynamic>) {
        return const Left("Format data tidak valid");
      }

      if (response.statusCode == 200) {
        final list = (decoded['data'] as List).map(parser).toList();
        return Right(list);
      } else {
        final msg = decoded['message'] as String? ?? errorMessage;
        return Left(msg);
      }
    } catch (e) {
      log("Error [$endpoint]: $e");
      return Left("Terjadi kesalahan saat mengambil data");
    }
  }
}