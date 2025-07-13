import 'dart:convert';
import 'dart:developer';
import 'dart:io';
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
      final response = await _serviceHttpClient.get("profile");

      return _handleResponse(
        response: response,
        onSuccess: (jsonResponse) =>
            UserProfileUpdateResponseModel.fromMap(jsonResponse),
        errorContext: "mengambil data profil user",
      );
    } catch (e) {
      log("Error getMyProfile: $e");
      return const Left("Terjadi kesalahan saat mengambil data profil user");
    }
  }

  Future<Either<String, UserProfileUpdateResponseModel>> getProfile() async {
    return getMyProfile();
  }

  /// Update profil user sendiri
  Future<Either<String, UserProfileUpdateResponseModel>> updateMyProfile(
  UserProfileUpdateRequestModel request,
) async {
  try {
    http.Response response;

    // Cek apakah ada file foto
    if (request.photoFile != null) {
      response = await _serviceHttpClient.postMultipartWithToken(
        "profile",
        fields: request.toMap(), // semua data string (nama, alamat, dll)
       photoFile: request.photoFile, // File? dari ImagePicker
      );
    } else {
      response = await _serviceHttpClient.postWithToken(
        "profile",
        request.toMap(),
      );
    }

    return _handleResponse(
      response: response,
      onSuccess: (jsonResponse) =>
          UserProfileUpdateResponseModel.fromMap(jsonResponse),
      errorContext: "memperbarui profil user",
    );
  } catch (e) {
    log("Error updateMyProfile: $e");
    return const Left("Terjadi kesalahan saat memperbarui profil user");
  }
}


  Future<Either<String, UserProfileUpdateResponseModel>> updateProfile(
    UserProfileUpdateRequestModel request,
  ) async {
    return updateMyProfile(request);
  }

  /// Ubah password
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

      final response =
          await _serviceHttpClient.postWithToken("change-password", requestData);

      return _handleResponse(
        response: response,
        onSuccess: (jsonResponse) =>
            UserProfileUpdateResponseModel.fromMap(jsonResponse),
        errorContext: "mengubah password",
      );
    } catch (e) {
      log("Error changePassword: $e");
      return const Left("Terjadi kesalahan saat mengubah password");
    }
  }

  /// Handle response standar
  Either<String, T> _handleResponse<T>({
    required http.Response response,
    required T Function(Map<String, dynamic>) onSuccess,
    required String errorContext,
  }) {
    try {
      log("[$errorContext] Request URL: ${response.request?.url}");
      log("[$errorContext] Status: ${response.statusCode}");
      log("[$errorContext] Body: ${response.body}");

      final jsonResponse = json.decode(response.body) as Map<String, dynamic>;

      if (response.statusCode >= 200 && response.statusCode < 300) {
        return Right(onSuccess(jsonResponse));
      } else {
        String errorMessage = "Terjadi kesalahan saat $errorContext";

        if (jsonResponse.containsKey('message')) {
          errorMessage = jsonResponse['message'] as String;
        }

        switch (response.statusCode) {
          case 400:
            errorMessage = jsonResponse['message'] ?? 'Data tidak valid';
            break;
          case 401:
            errorMessage = "Sesi Anda telah berakhir. Silakan login kembali";
            break;
          case 403:
            errorMessage = "Anda tidak memiliki izin";
            break;
          case 404:
            errorMessage = "Endpoint tidak ditemukan";
            break;
          case 405:
            errorMessage = "Method tidak diizinkan";
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
            }
            break;
          case 500:
            errorMessage = "Terjadi kesalahan server";
            break;
        }

        return Left(errorMessage);
      }
    } catch (e) {
      log("Error parsing response for $errorContext: $e");
      return Left("Gagal memproses respons server");
    }
  }

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
