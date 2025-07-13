// repositories/dashboard_admin_repository.dart
import 'dart:convert';
import 'dart:developer';

import 'package:dartz/dartz.dart';
import 'package:tilik_desa/data/model/response/admin/dashboard_admin_response_model.dart';
import 'package:tilik_desa/services/services_http_client.dart';

/// Repository untuk mengelola data dashboard admin
class DashboardAdminRepository {
  final ServiceHttpClient _serviceHttpClient;
  
  // Simple in-memory cache
  final Map<String, _CacheItem> _cache = {};
  static const Duration _cacheExpiration = Duration(minutes: 5);

  DashboardAdminRepository(this._serviceHttpClient);

  /// Mengambil data dashboard admin
  Future<Either<String, DashboardAdminResponseModel>> getDashboardData({
    bool forceRefresh = false,
  }) async {
    const cacheKey = 'dashboard_data';
    
    // Check cache first
    if (!forceRefresh && _isCacheValid(cacheKey)) {
      log('📦 Returning cached dashboard data');
      return Right(_cache[cacheKey]!.data as DashboardAdminResponseModel);
    }

    final result = await _getData<DashboardAdminResponseModel>(
      endpoint: "dashboard/admin/stats",
      parser: (json) => DashboardAdminResponseModel.fromMap(json),
      errorMessage: "Gagal mengambil data dashboard admin",
    );

    // Cache successful result
    result.fold(
      (error) => log('❌ Failed to get dashboard data: $error'),
      (data) {
        _cache[cacheKey] = _CacheItem(data, DateTime.now());
        log('✅ Dashboard data cached successfully');
      },
    );

    return result;
  }

  /// Refresh dashboard data (force refresh)
  Future<Either<String, DashboardAdminResponseModel>> refreshDashboard() async {
    log('🔄 Refreshing dashboard data...');
    _invalidateCache('dashboard_data');
    return getDashboardData(forceRefresh: true);
  }

  /// Mengambil statistik admin
  Future<Either<String, AdminStats>> getAdminStats({
    bool forceRefresh = false,
  }) async {
    const cacheKey = 'admin_stats';
    
    if (!forceRefresh && _isCacheValid(cacheKey)) {
      log('📦 Returning cached admin stats');
      return Right(_cache[cacheKey]!.data as AdminStats);
    }

    final result = await _getData<AdminStats>(
      endpoint: "dashboard/admin/stats",
      parser: (json) => AdminStats.fromMap(json['data']),
      errorMessage: "Gagal mengambil data statistik admin",
    );

    result.fold(
      (error) => log('❌ Failed to get admin stats: $error'),
      (data) {
        _cache[cacheKey] = _CacheItem(data, DateTime.now());
        log('✅ Admin stats cached successfully');
      },
    );

    return result;
  }

  /// Mengambil laporan berdasarkan kategori
  Future<Either<String, List<ReportsByCategory>>> getReportsByCategory({
    bool forceRefresh = false,
  }) async {
    const cacheKey = 'reports_by_category';
    
    if (!forceRefresh && _isCacheValid(cacheKey)) {
      log('📦 Returning cached reports by category');
      return Right(_cache[cacheKey]!.data as List<ReportsByCategory>);
    }

    final result = await _getListData<ReportsByCategory>(
      endpoint: "dashboard/admin/reports-by-category",
      parser: (e) => ReportsByCategory.fromMap(e),
      errorMessage: "Gagal mengambil data kategori laporan",
    );

    result.fold(
      (error) => log('❌ Failed to get reports by category: $error'),
      (data) {
        _cache[cacheKey] = _CacheItem(data, DateTime.now());
        log('✅ Reports by category cached successfully');
      },
    );

    return result;
  }

  /// Mengambil tren laporan
  Future<Either<String, List<ReportsTrend>>> getReportsTrend({
    bool forceRefresh = false,
    int? days,
  }) async {
    final cacheKey = 'reports_trend${days != null ? '_$days' : ''}';
    
    if (!forceRefresh && _isCacheValid(cacheKey)) {
      log('📦 Returning cached reports trend');
      return Right(_cache[cacheKey]!.data as List<ReportsTrend>);
    }

    String endpoint = "dashboard/admin/reports-trend";
    if (days != null) {
      endpoint += "?days=$days";
    }

    final result = await _getListData<ReportsTrend>(
      endpoint: endpoint,
      parser: (e) => ReportsTrend.fromMap(e),
      errorMessage: "Gagal mengambil data tren laporan",
    );

    result.fold(
      (error) => log('❌ Failed to get reports trend: $error'),
      (data) {
        _cache[cacheKey] = _CacheItem(data, DateTime.now());
        log('✅ Reports trend cached successfully');
      },
    );

    return result;
  }

  /// Mengambil area prioritas
  Future<Either<String, List<PriorityArea>>> getPriorityAreas({
    bool forceRefresh = false,
    int? limit,
  }) async {
    final cacheKey = 'priority_areas${limit != null ? '_$limit' : ''}';
    
    if (!forceRefresh && _isCacheValid(cacheKey)) {
      log('📦 Returning cached priority areas');
      return Right(_cache[cacheKey]!.data as List<PriorityArea>);
    }

    String endpoint = "dashboard/admin/priority-areas";
    if (limit != null) {
      endpoint += "?limit=$limit";
    }

    final result = await _getListData<PriorityArea>(
      endpoint: endpoint,
      parser: (e) => PriorityArea.fromMap(e),
      errorMessage: "Gagal mengambil data area prioritas",
    );

    result.fold(
      (error) => log('❌ Failed to get priority areas: $error'),
      (data) {
        _cache[cacheKey] = _CacheItem(data, DateTime.now());
        log('✅ Priority areas cached successfully');
      },
    );

    return result;
  }

  /// Mengambil laporan terbaru
  Future<Either<String, List<RecentReport>>> getRecentReports({
    bool forceRefresh = false,
    int? limit,
  }) async {
    final cacheKey = 'recent_reports${limit != null ? '_$limit' : ''}';
    
    if (!forceRefresh && _isCacheValid(cacheKey)) {
      log('📦 Returning cached recent reports');
      return Right(_cache[cacheKey]!.data as List<RecentReport>);
    }

    String endpoint = "dashboard/admin/recent-reports";
    if (limit != null) {
      endpoint += "?limit=$limit";
    }

    final result = await _getListData<RecentReport>(
      endpoint: endpoint,
      parser: (e) => RecentReport.fromMap(e),
      errorMessage: "Gagal mengambil data laporan terbaru",
    );

    result.fold(
      (error) => log('❌ Failed to get recent reports: $error'),
      (data) {
        _cache[cacheKey] = _CacheItem(data, DateTime.now());
        log('✅ Recent reports cached successfully');
      },
    );

    return result;
  }

  /// Mengambil metrik performa
  Future<Either<String, PerformanceMetrics>> getPerformanceMetrics({
    bool forceRefresh = false,
  }) async {
    const cacheKey = 'performance_metrics';
    
    if (!forceRefresh && _isCacheValid(cacheKey)) {
      log('📦 Returning cached performance metrics');
      return Right(_cache[cacheKey]!.data as PerformanceMetrics);
    }

    final result = await _getData<PerformanceMetrics>(
      endpoint: "dashboard/admin/performance-metrics",
      parser: (json) => PerformanceMetrics.fromMap(json['data']),
      errorMessage: "Gagal mengambil data metrik performa",
    );

    result.fold(
      (error) => log('❌ Failed to get performance metrics: $error'),
      (data) {
        _cache[cacheKey] = _CacheItem(data, DateTime.now());
        log('✅ Performance metrics cached successfully');
      },
    );

    return result;
  }

  /// Mengambil semua data dashboard sekaligus
  Future<Either<String, DashboardAdminResponseModel>> getAllDashboardData({
    bool forceRefresh = false,
  }) async {
    try {
      log('📊 Fetching all dashboard data...');
      
      final dashboardResult = await getDashboardData(forceRefresh: forceRefresh);
      
      return dashboardResult.fold(
        (error) => Left(error),
        (dashboard) async {
          // Optionally fetch additional data in parallel
          final futures = await Future.wait([
            getReportsByCategory(forceRefresh: forceRefresh),
            getReportsTrend(forceRefresh: forceRefresh),
            getPriorityAreas(forceRefresh: forceRefresh),
            getRecentReports(forceRefresh: forceRefresh),
            getPerformanceMetrics(forceRefresh: forceRefresh),
          ]);

          // Log any errors but still return the main dashboard data
          for (int i = 0; i < futures.length; i++) {
            futures[i].fold(
              (error) => log('⚠️  Warning: Additional data ${i + 1} failed: $error'),
              (data) => log('✅ Additional data ${i + 1} loaded successfully'),
            );
          }

          return Right(dashboard);
        },
      );
    } catch (e) {
      log('❌ Error fetching all dashboard data: $e');
      return Left('Terjadi kesalahan saat mengambil data dashboard');
    }
  }

  /// Clear all cache
  void clearCache() {
    _cache.clear();
    log('🗑️  Cache cleared');
  }

  /// Clear specific cache
  void clearCacheForKey(String key) {
    _cache.remove(key);
    log('🗑️  Cache cleared for key: $key');
  }

  /// Get cache statistics
  Map<String, dynamic> getCacheStats() {
    final now = DateTime.now();
    final validCacheCount = _cache.values
        .where((item) => now.difference(item.timestamp) < _cacheExpiration)
        .length;

    return {
      'total_cache_items': _cache.length,
      'valid_cache_items': validCacheCount,
      'expired_cache_items': _cache.length - validCacheCount,
      'cache_expiration_minutes': _cacheExpiration.inMinutes,
    };
  }

  // Private helper methods

  /// Generic method untuk mengambil single data
  Future<Either<String, T>> _getData<T>({
    required String endpoint,
    required T Function(Map<String, dynamic>) parser,
    required String errorMessage,
  }) async {
    try {
      log('🌐 Fetching data from: $endpoint');
      final response = await _serviceHttpClient.get(endpoint);

      if (response.body == null || response.body.isEmpty) {
        log('❌ Empty response body from: $endpoint');
        return const Left("Data tidak ditemukan");
      }

      final decoded = json.decode(response.body);
      if (decoded is! Map<String, dynamic>) {
        log('❌ Invalid response format from: $endpoint');
        return const Left("Format data tidak valid");
      }

      log('📊 Response status: ${response.statusCode} for: $endpoint');

      if (response.statusCode == 200) {
        final parsedData = parser(decoded);
        log('✅ Successfully parsed data from: $endpoint');
        return Right(parsedData);
      } else {
        final msg = decoded['message'] as String? ?? errorMessage;
        log('❌ API Error from $endpoint: $msg');
        return Left(msg);
      }
    } catch (e, stackTrace) {
      log('❌ Exception in _getData [$endpoint]: $e');
      log('Stack trace: $stackTrace');
      return Left("Terjadi kesalahan saat mengambil data");
    }
  }

  /// Generic method untuk mengambil list data
  Future<Either<String, List<T>>> _getListData<T>({
    required String endpoint,
    required T Function(dynamic) parser,
    required String errorMessage,
  }) async {
    try {
      log('🌐 Fetching list data from: $endpoint');
      final response = await _serviceHttpClient.get(endpoint);

      if (response.body == null || response.body.isEmpty) {
        log('❌ Empty response body from: $endpoint');
        return const Left("Data tidak ditemukan");
      }

      final decoded = json.decode(response.body);
      if (decoded is! Map<String, dynamic>) {
        log('❌ Invalid response format from: $endpoint');
        return const Left("Format data tidak valid");
      }

      log('📊 Response status: ${response.statusCode} for: $endpoint');

      if (response.statusCode == 200) {
        final dataList = decoded['data'];
        if (dataList is! List) {
          log('❌ Expected list but got: ${dataList.runtimeType}');
          return const Left("Format data tidak valid");
        }

        final list = dataList.map(parser).toList();
        log('✅ Successfully parsed ${list.length} items from: $endpoint');
        return Right(list);
      } else {
        final msg = decoded['message'] as String? ?? errorMessage;
        log('❌ API Error from $endpoint: $msg');
        return Left(msg);
      }
    } catch (e, stackTrace) {
      log('❌ Exception in _getListData [$endpoint]: $e');
      log('Stack trace: $stackTrace');
      return Left("Terjadi kesalahan saat mengambil data");
    }
  }

  /// Check if cache is valid
  bool _isCacheValid(String key) {
    final cacheItem = _cache[key];
    if (cacheItem == null) return false;

    final now = DateTime.now();
    final isValid = now.difference(cacheItem.timestamp) < _cacheExpiration;
    
    if (!isValid) {
      _cache.remove(key);
      log('🗑️  Expired cache removed for key: $key');
    }

    return isValid;
  }

  /// Invalidate specific cache
  void _invalidateCache(String key) {
    _cache.remove(key);
    log('🗑️  Cache invalidated for key: $key');
  }
}

/// Cache item wrapper
class _CacheItem {
  final dynamic data;
  final DateTime timestamp;

  _CacheItem(this.data, this.timestamp);
}

/// Extension untuk repository
extension DashboardAdminRepositoryExtension on DashboardAdminRepository {
  /// Mengambil data dashboard dengan retry mechanism
  Future<Either<String, DashboardAdminResponseModel>> getDashboardDataWithRetry({
    int maxRetries = 3,
    Duration retryDelay = const Duration(seconds: 2),
  }) async {
    for (int i = 0; i < maxRetries; i++) {
      final result = await getDashboardData();
      
      if (result.isRight()) {
        return result;
      }
      
      if (i < maxRetries - 1) {
        log('🔄 Retrying dashboard data fetch... (${i + 1}/$maxRetries)');
        await Future.delayed(retryDelay);
      }
    }
    
    return const Left('Gagal mengambil data setelah beberapa percobaan');
  }

  /// Batch update multiple data
  Future<Map<String, Either<String, dynamic>>> batchUpdateDashboard() async {
    final results = <String, Either<String, dynamic>>{};
    
    final futures = {
      'dashboard': getDashboardData(forceRefresh: true),
      'reports_by_category': getReportsByCategory(forceRefresh: true),
      'reports_trend': getReportsTrend(forceRefresh: true),
      'priority_areas': getPriorityAreas(forceRefresh: true),
      'recent_reports': getRecentReports(forceRefresh: true),
      'performance_metrics': getPerformanceMetrics(forceRefresh: true),
    };

    for (final entry in futures.entries) {
      try {
        results[entry.key] = await entry.value;
      } catch (e) {
        results[entry.key] = Left('Error: $e');
      }
    }

    return results;
  }
}