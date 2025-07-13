import 'package:dartz/dartz.dart';
import 'package:tilik_desa/data/model/request/admin/all_report_admin_request_model.dart';
import 'package:tilik_desa/data/model/response/admin/update_status_report_response_admin_mode.dart';
import 'package:tilik_desa/services/services_http_client.dart';

class UpdateStatusRepository {
  final ServiceHttpClient client;

  UpdateStatusRepository(this.client);

  Future<Either<String, UpdateStatusResponseModel>> updateStatus(
      int reportId, UpdateStatusRequestModel request) async {
    try {
      final response = await client.putWithToken(
        'admin/reports/$reportId/status', // ✅ perbaikan URL
        request.toMap(),
      );

      if (response.statusCode == 200) {
        return Right(UpdateStatusResponseModel.fromJson(response.body));
      } else {
        return Left("Gagal update status: ${response.body}");
      }
    } catch (e) {
      return Left("Terjadi kesalahan: $e");
    }
  }
}
