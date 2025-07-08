import 'dart:convert';
import 'dart:developer';

import 'package:dartz/dartz.dart';
import 'package:http/http.dart' as http;
import 'package:tilik_desa/data/model/request/user/profil_update_user_request_model.dart';
import 'package:tilik_desa/data/model/response/user/profil_update_user_response_model.dart';
import 'package:tilik_desa/services/services_http_client.dart';

class UserProfileRepository {
  final ServiceHttpClient _serviceHttpClient;

  UserProfileRepository(this._serviceHttpClient);

  /// Ambil profil user sendiri
  Future<Either<String, UserProfileUpdateResponseModel>> getMyProfile() async {
    try {
      // Endpoint: GET /profile (sesuai dengan backend)
      final response = await _serviceHttpClient.get("profile");

      return _handleResponse(
        response: response,
        onSuccess: (jsonResponse) => UserProfileUpdateResponseModel.fromMap(jsonResponse),
        errorContext: "mengambil data profil user",
      );
    } catch (e) {
      log("Error getMyProfile: $e");
      return const Left("Terjadi kesalahan saat mengambil data profil user");
    }
  }

  /// Ambil profil user (alias untuk getMyProfile untuk backward compatibility)
  Future<Either<String, UserProfileUpdateResponseModel>> getProfile() async {
    return getMyProfile();
  }

  /// Update profil user (alias untuk updateMyProfile untuk backward compatibility)
  Future<Either<String, UserProfileUpdateResponseModel>> updateProfile(
    UserProfileUpdateRequestModel request,
  ) async {
    return updateMyProfile(request);
  }

  /// Update profil user sendiri
  Future<Either<String, UserProfileUpdateResponseModel>> updateMyProfile(
    UserProfileUpdateRequestModel request,
  ) async {
    try {
      // PERBAIKAN: Ganti dari postWithToken ke putWithToken
      final response = await _serviceHttpClient.putWithToken(
        "profile",
        request.toMap(),
      );

      return _handleResponse(
        response: response,
        onSuccess: (jsonResponse) => UserProfileUpdateResponseModel.fromMap(jsonResponse),
        errorContext: "memperbarui profil user",
      );
    } catch (e) {
      log("Error updateMyProfile: $e");
      return const Left("Terjadi kesalahan saat memperbarui profil user");
    }
  }

  Future<Either<String, UserProfileUpdateResponseModel>> changePassword({
    required String currentPassword,
    required String newPassword,
    required String passwordConfirmation,
  }) async {
    try {
      final requestData = {
        'current_password': currentPassword,
        'password': newPassword,
        'password_confirmation': passwordConfirmation,
      };

      // CATATAN: Cek apakah endpoint change-password juga perlu PUT atau tetap POST
      // Jika error yang sama terjadi, ganti ke putWithToken
      final response = await _serviceHttpClient.postWithToken(
        "change-password",
        requestData,
      );

      return _handleResponse(
        response: response,
        onSuccess: (jsonResponse) => UserProfileUpdateResponseModel.fromMap(jsonResponse),
        errorContext: "mengubah password",
      );
    } catch (e) {
      log("Error changePassword: $e");
      return const Left("Terjadi kesalahan saat mengubah password");
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
      } else {
        // Handle error response dengan lebih detail
        String errorMessage = "Terjadi kesalahan saat $errorContext";
        
        // Ambil pesan error dari response
        if (jsonResponse.containsKey('message')) {
          errorMessage = jsonResponse['message'] as String;
        }
        
        // Handle specific status codes
        switch (response.statusCode) {
          case 400:
            errorMessage = jsonResponse['message'] ?? 'Data yang dikirim tidak valid';
            break;
          case 401:
            errorMessage = "Sesi Anda telah berakhir. Silakan login kembali";
            break;
          case 403:
            errorMessage = "Anda tidak memiliki izin untuk melakukan aksi ini";
            break;
          case 404:
            errorMessage = "Endpoint tidak ditemukan. Pastikan backend berjalan dan route sudah terdaftar";
            break;
          case 405:
            errorMessage = "Method tidak diizinkan untuk endpoint ini";
            break;
          case 422:
            if (jsonResponse.containsKey('errors')) {
              final errors = jsonResponse['errors'];
              if (errors is Map && errors.isNotEmpty) {
                final firstError = errors.values.first;
                if (firstError is List && firstError.isNotEmpty) {
                  errorMessage = firstError.first.toString();
                }
              }
            } else if (jsonResponse.containsKey('message')) {
              errorMessage = jsonResponse['message'] as String;
            }
            break;
          case 500:
            errorMessage = "Terjadi kesalahan pada server. Coba lagi nanti";
            break;
          default:
            if (jsonResponse.containsKey('message')) {
              errorMessage = jsonResponse['message'] as String;
            }
        }
        
        return Left(errorMessage);
      }
    } catch (e) {
      log("Error parsing response for $errorContext: $e");
      log("Raw response body: ${response.body}");
      return Left("Terjadi kesalahan saat memproses respons dari server");
    }
  }

  /// Method tambahan untuk debugging - cek apakah token valid
  Future<bool> checkTokenValidity() async {
    try {
      final response = await _serviceHttpClient.get("profile");
      return response.statusCode != 401;
    } catch (e) {
      log("Error checking token validity: $e");
      return false;
    }
  }
}