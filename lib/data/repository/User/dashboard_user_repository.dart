import 'dart:convert';
import 'dart:developer';

import 'package:dartz/dartz.dart';
import 'package:tilik_desa/data/model/response/user/dashboard_user_response_model.dart';
import 'package:tilik_desa/services/services_http_client.dart';

class DashboardUserRepository {
  final ServiceHttpClient _serviceHttpClient;

  DashboardUserRepository(this._serviceHttpClient);

  Future<Either<String, DashboardUserResponseModel>> getDashboardUser() async {
    try {
      final response = await _serviceHttpClient.get("dashboard/user");

      // Validasi response body tidak null/kosong
      if (response.body == null || response.body.isEmpty) {
        log("Response body kosong");
        return const Left("Data tidak ditemukan");
      }

      // Parse JSON dengan error handling
      final Map<String, dynamic> jsonResponse;
      try {
        final decoded = json.decode(response.body);
        if (decoded is Map<String, dynamic>) {
          jsonResponse = decoded;
        } else {
          log("Response bukan format JSON yang valid");
          return const Left("Format data tidak valid");
        }
      } catch (jsonError) {
        log("Error parsing JSON: $jsonError");
        return const Left("Format data tidak valid");
      }

      if (response.statusCode == 200) {
        try {
          final dashboardData = DashboardUserResponseModel.fromMap(jsonResponse);
          return Right(dashboardData);
        } catch (modelError) {
          log("Error parsing model: $modelError");
          return const Left("Gagal memproses data dashboard");
        }
      } else {
        final errorMessage = jsonResponse['message'] as String? ?? 
                           "Gagal mengambil data dashboard user";
        log("Gagal mengambil data dashboard user: $errorMessage");
        return Left(errorMessage);
      }
    } catch (e) {
      log("Error getDashboardUser: $e");
      return const Left("Terjadi kesalahan saat mengambil data dashboard");
    }
  }
}