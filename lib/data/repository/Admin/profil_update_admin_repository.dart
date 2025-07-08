import 'dart:convert';
import 'dart:developer';

import 'package:dartz/dartz.dart';
import 'package:http/http.dart' as http;
import 'package:tilik_desa/data/model/request/admin/profil_update_admin_request_model.dart';
import 'package:tilik_desa/data/model/response/admin/profil_update_admin_response_model.dart';
import 'package:tilik_desa/services/services_http_client.dart';

class AdminProfileRepository {
  final ServiceHttpClient _client;

  AdminProfileRepository(this._client);

  /// Ambil profil admin sendiri
  Future<Either<String, AdminProfileUpdateResponseModel>> getMyProfile() async {
    try {
      // Endpoint: GET /profile (sesuai dengan backend)
      final response = await _client.get("profile");

      return _handleResponse(
        response: response,
        onSuccess: (json) => AdminProfileUpdateResponseModel.fromMap(json),
        errorContext: "mengambil data profil admin",
      );
    } catch (e) {
      log("Error getMyProfile: $e");
      return const Left("Terjadi kesalahan saat mengambil data profil admin");
    }
  }

  /// Update profil admin sendiri
  Future<Either<String, AdminProfileUpdateResponseModel>> updateMyProfile(
      AdminProfileUpdateRequestModel request) async {
    try {
      // PERBAIKAN: Gunakan endpoint "profile" bukan "admin/profile"
      // Karena backend endpoint adalah /profile
      final response = await _client.putWithToken(
        "profile", // Ubah dari "admin/profile" ke "profile"
        request.toMap(),
      );

      return _handleResponse(
        response: response,
        onSuccess: (json) => AdminProfileUpdateResponseModel.fromMap(json),
        errorContext: "memperbarui profil admin",
      );
    } catch (e) {
      log("Error updateMyProfile: $e");
      return const Left("Terjadi kesalahan saat memperbarui profil admin");
    }
  }

  /// Handler response umum dengan logging yang lebih detail
  Either<String, T> _handleResponse<T>({
    required http.Response response,
    required T Function(Map<String, dynamic>) onSuccess,
    required String errorContext,
  }) {
    try {
      // Log request URL untuk debugging
      log("[$errorContext] Request URL: ${response.request?.url}");
      log("[$errorContext] Status: ${response.statusCode}");
      log("[$errorContext] Body: ${response.body}");

      final jsonResponse = json.decode(response.body) as Map<String, dynamic>;

      if (response.statusCode >= 200 && response.statusCode < 300) {
        return Right(onSuccess(jsonResponse));
      }

      // Ambil pesan error dari response
      String errorMessage = jsonResponse['message'] ?? 'Terjadi kesalahan saat $errorContext';

      // Tangani error validasi
      if (response.statusCode == 422 && jsonResponse.containsKey('errors')) {
        final errors = jsonResponse['errors'];
        if (errors is Map && errors.isNotEmpty) {
          final firstError = errors.values.first;
          if (firstError is List && firstError.isNotEmpty) {
            errorMessage = firstError.first;
          }
        }
      }

      // Tangani error khusus
      switch (response.statusCode) {
        case 401:
          errorMessage = "Token tidak valid atau sudah expired";
          break;
        case 403:
          errorMessage = "Tidak memiliki akses untuk melakukan aksi ini";
          break;
        case 404:
          errorMessage = "Endpoint tidak ditemukan. Pastikan backend berjalan dan route sudah terdaftar";
          break;
        case 500:
          errorMessage = "Terjadi kesalahan pada server";
          break;
      }

      return Left(errorMessage);
    } catch (e) {
      log("Error parsing response ($errorContext): $e");
      log("Raw response body: ${response.body}");
      return Left("Terjadi kesalahan saat memproses respons dari server");
    }
  }

  /// Method tambahan untuk debugging - cek apakah token valid
  Future<bool> checkTokenValidity() async {
    try {
      final response = await _client.get("profile");
      return response.statusCode != 401;
    } catch (e) {
      log("Error checking token validity: $e");
      return false;
    }
  }
}