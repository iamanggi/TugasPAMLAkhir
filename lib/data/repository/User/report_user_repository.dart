import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:tilik_desa/data/model/request/user/add_report_user_request_model.dart';
import 'package:tilik_desa/data/model/response/user/add_report_user_response_model.dart';
import 'package:tilik_desa/services/services_http_client.dart';

class ReportRepository {
  final ServiceHttpClient _httpClient;
  final secureStorage = const FlutterSecureStorage();

  ReportRepository(this._httpClient);

  Future<Either<String, ReportData>> createReport(
    ReportStoreRequestModel requestModel,
  ) async {
    try {
      final Map<String, dynamic> fields = {
        'title': requestModel.title,
        'description': requestModel.description,
        'category_id': requestModel.categoryId.toString(),
        'is_urgent': requestModel.isUrgent.toString(),
      };

      if (requestModel.village != null) {
        fields['village'] = requestModel.village;
      }
      if (requestModel.district != null) {
        fields['district'] = requestModel.district;
      }
      if (requestModel.fullAddress != null) {
        fields['full_address'] = requestModel.fullAddress;
      }
      if (requestModel.latitude != null) {
        fields['latitude'] = requestModel.latitude.toString();
      }
      if (requestModel.longitude != null) {
        fields['longitude'] = requestModel.longitude.toString();
      }
      if (requestModel.locationDetail != null) {
        fields['location_detail'] = requestModel.locationDetail;
      }

      final Map<String, File> files = {};
      if (requestModel.photoPath != null &&
          requestModel.photoPath!.isNotEmpty) {
        final file = File(requestModel.photoPath!);
        if (await file.exists()) {
          files['photo'] = file;
        }
      }

      final http.Response response = await _httpClient.postMultipart(
        'reports',
        fields,
        files: files,
      );
      log("createReport - Status: ${response.statusCode}");
      log("createReport - Body: ${response.body}");

      if (response.statusCode == 200 || response.statusCode == 201) {
        final jsonData = json.decode(response.body);
        final responseData = ReportStoreResponseModel.fromJson(jsonData);
        if (responseData.success && responseData.data != null) {
          return Right(responseData.data!);
        } else {
          return Left(responseData.message ?? 'Gagal membuat laporan');
        }
      } else {
        return Left(_handleErrorResponse(response));
      }
    } catch (e, stacktrace) {
      log("createReport - Exception: $e\n$stacktrace");
      return Left('Terjadi kesalahan: ${e.toString()}');
    }
  }

  Future<Either<String, List<CategoryData>>> getCategories() async {
    try {
      final response = await _httpClient.getWithoutToken('categories');
      log('getCategories - Status: ${response.statusCode}');
      log('getCategories - Body: ${response.body}');

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        final responseData = CategoriesResponseModel.fromJson(jsonData);
        if (responseData.success && responseData.data != null) {
          return Right(responseData.data!);
        } else {
          return Left(responseData.message ?? 'Gagal mengambil data kategori');
        }
      } else {
        return Left(_handleErrorResponse(response));
      }
    } catch (e, stacktrace) {
      log('getCategories - Exception: $e\n$stacktrace');
      return Left('Terjadi kesalahan: ${e.toString()}');
    }
  }

  Future<Either<String, List<LocationData>>> getLocations() async {
    try {
      final response = await _httpClient.getWithoutToken('locations');
      log('getLocations - Status: ${response.statusCode}');
      log('getLocations - Body: ${response.body}');

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        final responseData = LocationsResponseModel.fromJson(jsonData);
        if (responseData.success && responseData.data != null) {
          return Right(responseData.data!);
        } else {
          return Left(responseData.message ?? 'Gagal mengambil data lokasi');
        }
      } else {
        return Left(_handleErrorResponse(response));
      }
    } catch (e, stacktrace) {
      log('getLocations - Exception: $e\n$stacktrace');
      return Left('Terjadi kesalahan: ${e.toString()}');
    }
  }

  Future<Either<String, ReportData>> getReportById(int id) async {
    try {
      final response = await _httpClient.getWithoutToken('reports/$id');
      log('getReportById - Status: ${response.statusCode}');
      log('getReportById - Body: ${response.body}');

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        final responseData = ReportStoreResponseModel.fromJson(jsonData);
        if (responseData.success && responseData.data != null) {
          return Right(responseData.data!);
        } else {
          return Left(responseData.message ?? 'Gagal mengambil detail laporan');
        }
      } else {
        return Left(_handleErrorResponse(response));
      }
    } catch (e, stacktrace) {
      log('getReportById - Exception: $e\n$stacktrace');
      return Left('Terjadi kesalahan: ${e.toString()}');
    }
  }

  Future<Either<String, List<ReportData>>> getReports({
    String? status,
    String? village,
    String? district,
    bool? isUrgent,
    int? categoryId,
    int page = 1,
    int limit = 10,
  }) async {
    try {
      final Map<String, String> queryParams = {
        'page': page.toString(),
        'limit': limit.toString(),
      };
      
      if (status != null) queryParams['status'] = status;
      if (village != null) queryParams['village'] = village;
      if (district != null) queryParams['district'] = district;
      if (isUrgent != null) queryParams['is_urgent'] = isUrgent.toString();
      if (categoryId != null) {
        queryParams['category_id'] = categoryId.toString();
      }

      final uri = 'reports?' + Uri(queryParameters: queryParams).query;
      final response = await _httpClient.getWithoutToken(uri);

      log('getReports - Status: ${response.statusCode}');
      log('getReports - Body: ${response.body}');

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['success'] == true && data['data'] != null) {
          final reports = (data['data'] as List)
              .map((report) => ReportData.fromMap(report))
              .toList();
          return Right(reports);
        } else {
          return Left(data['message'] ?? 'Gagal mengambil data laporan');
        }
      } else {
        return Left(_handleErrorResponse(response));
      }
    } catch (e, stacktrace) {
      log('getReports - Exception: $e\n$stacktrace');
      return Left('Terjadi kesalahan: ${e.toString()}');
    }
  }

  String _handleErrorResponse(http.Response response) {
    try {
      final errorData = json.decode(response.body);
      if (errorData['message'] != null) {
        return errorData['message'];
      } else if (errorData['errors'] != null) {
        final errors = errorData['errors'] as Map<String, dynamic>;
        final errorMessages = errors.values
            .expand((e) => e is List ? e : [e])
            .join(', ');
        return errorMessages;
      }
    } catch (e) {
      log('Error parsing error response: $e');
    }
    return 'Terjadi kesalahan pada server. Status: ${response.statusCode}';
  }
}