import 'dart:convert';
import 'dart:developer';
import 'package:dartz/dartz.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:tilik_desa/data/model/request/user/riwayat_report_user_request_model.dart';
import 'package:tilik_desa/data/model/response/user/riwayat_report_response_user_model.dart';
import 'package:tilik_desa/services/services_http_client.dart';

class RiwayatReportRepository {
  final ServiceHttpClient _client;
  final _storage = const FlutterSecureStorage();

  RiwayatReportRepository(this._client);

  Future<Either<String, RiwayatReportResponseModel>> getReportsByUser(
      RiwayatReportRequestModel request) async {
    try {
      final response = await _client.get("reports");

      if (response.statusCode != 200) {
        return Left("Gagal mengambil data laporan");
      }

      final data = json.decode(response.body);
      return Right(RiwayatReportResponseModel.fromMap(data));
    } catch (e) {
      log("Error getReportsByUser: $e");
      return const Left("Terjadi kesalahan saat mengambil data laporan");
    }
  }

  // ✅ Tambahkan method ini untuk menghapus laporan
  Future<Either<String, bool>> deleteReport(int id) async {
    try {
      final response = await _client.deleteWithToken("reports/$id");

      if (response.statusCode != 200) {
        final data = json.decode(response.body);
        return Left(data['message'] ?? 'Gagal menghapus laporan');
      }

      return const Right(true);
    } catch (e) {
      log("Error deleteReport: $e");
      return const Left("Terjadi kesalahan saat menghapus laporan");
    }
  }

  // ✅ Tambahkan method ini untuk ambil ID user dari secure storage
  Future<int> getUserIdFromStorage() async {
    final idStr = await _storage.read(key: 'userId');
    return int.tryParse(idStr ?? '0') ?? 0;
  }
}
