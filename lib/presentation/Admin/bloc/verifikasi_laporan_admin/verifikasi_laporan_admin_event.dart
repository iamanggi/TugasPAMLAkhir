part of 'verifikasi_laporan_admin_bloc.dart';

@immutable
sealed class VerifikasiLaporanAdminEvent {}

class SubmitVerifikasiLaporanAdmin extends VerifikasiLaporanAdminEvent {
  final String laporanId;
  final VerifikasiLaporanRequestModel request;

  SubmitVerifikasiLaporanAdmin({
    required this.laporanId,
    required this.request,
  });
}
