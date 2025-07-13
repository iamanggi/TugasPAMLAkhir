// Kelanjutan dari decoding response updatePemeliharaan
import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:http/http.dart' as http;
import 'package:tilik_desa/data/model/request/admin/pemeliharaan_admin_request_model.dart';
import 'package:tilik_desa/data/model/response/admin/pemeliharaan_admin_response_model.dart';
import 'package:tilik_desa/services/services_http_client.dart';

class PemeliharaanRepository {
  final ServiceHttpClient _serviceHttpClient;

  PemeliharaanRepository(this._serviceHttpClient);

  // Get List Pemeliharaan
  Future<Either<String, PemeliharaanListResponseModel>> getPemeliharaanList({
    PemeliharaanFilterRequestModel? filter,
  }) async {
    try {
      String endpoint = "admin/pemeliharaan";
      if (filter != null) {
        final queryParams = filter.toQueryParams();
        if (queryParams.isNotEmpty) {
          endpoint += "?${Uri(queryParameters: queryParams).query}";
        }
      }

      final response = await _serviceHttpClient.get(endpoint);

      if (response.body == null || response.body.isEmpty) {
        return const Left("Data tidak ditemukan");
      }

      final decoded = json.decode(response.body);
      if (decoded is! Map<String, dynamic>) {
        return const Left("Format data tidak valid");
      }

      if (response.statusCode == 200) {
        return Right(PemeliharaanListResponseModel.fromMap(decoded));
      } else {
        final msg = decoded['message'] as String? ?? "Gagal mengambil data pemeliharaan";
        return Left(msg);
      }
    } catch (e) {
      log("Error getPemeliharaanList: $e");
      return Left("Terjadi kesalahan saat mengambil data pemeliharaan");
    }
  }

  // Get Single Pemeliharaan
  Future<Either<String, PemeliharaanResponseModel>> getPemeliharaan(int id) async {
    try {
      final response = await _serviceHttpClient.get("admin/pemeliharaan/$id");

      if (response.body == null || response.body.isEmpty) {
        return const Left("Data tidak ditemukan");
      }

      final decoded = json.decode(response.body);
      if (decoded is! Map<String, dynamic>) {
        return const Left("Format data tidak valid");
      }

      if (response.statusCode == 200) {
        return Right(PemeliharaanResponseModel.fromMap(decoded));
      } else {
        final msg = decoded['message'] as String? ?? "Gagal mengambil detail pemeliharaan";
        return Left(msg);
      }
    } catch (e) {
      log("Error getPemeliharaan: $e");
      return Left("Terjadi kesalahan saat mengambil detail pemeliharaan");
    }
  }

  // Get Form Data untuk Create
  Future<Either<String, PemeliharaanFormResponseModel>> getCreateFormData() async {
    try {
      final response = await _serviceHttpClient.get("admin/pemeliharaan");

      if (response.body == null || response.body.isEmpty) {
        return const Left("Data tidak ditemukan");
      }

      final decoded = json.decode(response.body);
      if (decoded is! Map<String, dynamic>) {
        return const Left("Format data tidak valid");
      }

      if (response.statusCode == 200) {
        return Right(PemeliharaanFormResponseModel.fromMap(decoded));
      } else {
        final msg = decoded['message'] as String? ?? "Gagal mengambil data form";
        return Left(msg);
      }
    } catch (e) {
      log("Error getCreateFormData: $e");
      return Left("Terjadi kesalahan saat mengambil data form");
    }
  }

  // Get Form Data untuk Edit
  Future<Either<String, PemeliharaanFormResponseModel>> getEditFormData(int id) async {
    try {
      final response = await _serviceHttpClient.get("admin/pemeliharaan/$id/edit");

      if (response.body == null || response.body.isEmpty) {
        return const Left("Data tidak ditemukan");
      }

      final decoded = json.decode(response.body);
      if (decoded is! Map<String, dynamic>) {
        return const Left("Format data tidak valid");
      }

      if (response.statusCode == 200) {
        return Right(PemeliharaanFormResponseModel.fromMap(decoded));
      } else {
        final msg = decoded['message'] as String? ?? "Gagal mengambil data form edit";
        return Left(msg);
      }
    } catch (e) {
      log("Error getEditFormData: $e");
      return Left("Terjadi kesalahan saat mengambil data form edit");
    }
  }

  // Create Pemeliharaan
  Future<Either<String, PemeliharaanResponseModel>> createPemeliharaan(
    CreatePemeliharaanRequestModel request, {
    File? fotoFile,
  }) async {
    try {
      http.Response response;

      if (fotoFile != null) {
        // Multipart request untuk upload file
        response = await _serviceHttpClient.postMultipart(
          "admin/pemeliharaan",
          request.toMap(),
          files: {'foto': fotoFile},
        );
      } else {
        // Regular POST request
        response = await _serviceHttpClient.post(
          "admin/pemeliharaan",
          request.toMap(),
        );
      }

      if (response.body == null || response.body.isEmpty) {
        return const Left("Response kosong dari server");
      }

      final decoded = json.decode(response.body);
      if (decoded is! Map<String, dynamic>) {
        return const Left("Format response tidak valid");
      }

      if (response.statusCode == 201) {
        return Right(PemeliharaanResponseModel.fromMap(decoded));
      } else {
        final msg = decoded['message'] as String? ?? "Gagal menambahkan data pemeliharaan";
        return Left(msg);
      }
    } catch (e) {
      log("Error createPemeliharaan: $e");
      return Left("Terjadi kesalahan saat menambahkan data pemeliharaan");
    }
  }

  // Update Pemeliharaan
  Future<Either<String, PemeliharaanResponseModel>> updatePemeliharaan(
    int id,
    UpdatePemeliharaanRequestModel request, {
    File? fotoFile,
  }) async {
    try {
      http.Response response;

      if (fotoFile != null) {
        response = await _serviceHttpClient.putMultipart(
          "admin/pemeliharaan/$id",
          request.toMap(),
          files: {'foto': fotoFile},
        );
      } else {
        response = await _serviceHttpClient.put(
          "admin/pemeliharaan/$id",
          request.toMap(),
        );
      }

      if (response.body == null || response.body.isEmpty) {
        return const Left("Response kosong dari server");
      }

      final decoded = json.decode(response.body);
      if (decoded is! Map<String, dynamic>) {
        return const Left("Format response tidak valid");
      }

      if (response.statusCode == 200) {
        return Right(PemeliharaanResponseModel.fromMap(decoded));
      } else {
        final msg = decoded['message'] as String? ?? "Gagal memperbarui data pemeliharaan";
        return Left(msg);
      }
    } catch (e) {
      log("Error updatePemeliharaan: $e");
      return Left("Terjadi kesalahan saat memperbarui data pemeliharaan");
    }
  }

  // Delete Pemeliharaan
Future<Either<String, bool>> deletePemeliharaan(int id) async {
  try {
    final response = await _serviceHttpClient.delete("admin/pemeliharaan/$id");

    if (response.statusCode == 200) {
      return const Right(true);
    } else {
      final decoded = json.decode(response.body);
      final msg = decoded['message'] as String? ?? "Gagal menghapus data pemeliharaan";
      return Left(msg);
    }
  } catch (e) {
    log("Error deletePemeliharaan: $e");
    return Left("Terjadi kesalahan saat menghapus data pemeliharaan");
  }
}

}