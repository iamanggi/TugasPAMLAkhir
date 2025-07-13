import 'package:dartz/dartz.dart';
import 'package:tilik_desa/data/model/response/admin/all_report_response_admin_model.dart';
import 'package:tilik_desa/services/services_http_client.dart';

class AllReportRepository {
  final ServiceHttpClient client;

  AllReportRepository(this.client);

  Future<Either<String, List<Report>>> getAllReports() async {
    try {
      final response = await client.get('reports');

      if (response.statusCode == 200) {
        final parsed = AllReportResponseModel.fromJson(response.body);
        return Right(parsed.data);
      } else {
        return Left("Gagal memuat laporan: ${response.body}");
      }
    } catch (e) {
      return Left("Terjadi kesalahan: $e");
    }
  }
  
}
