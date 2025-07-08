import 'package:http/http.dart' as http;
import 'package:tilik_desa/data/model/request/admin/verifikasi_laporan_admin_request_model.dart';

class LaporanRepository {
  final String baseUrl;

  LaporanRepository({required this.baseUrl});

  Future<void> verifikasiLaporan(String laporanId, VerifikasiLaporanRequestModel request) async {
    final response = await http.put(
      Uri.parse('$baseUrl/laporan/$laporanId/verifikasi'),
      headers: {'Content-Type': 'application/json'},
      body: request.toJson(),
    );

    if (response.statusCode != 200) {
      throw Exception('Gagal memverifikasi laporan');
    }
  }
}
