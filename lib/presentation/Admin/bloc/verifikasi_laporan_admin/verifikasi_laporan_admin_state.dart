part of 'verifikasi_laporan_admin_bloc.dart';

@immutable
sealed class VerifikasiLaporanAdminState {}

final class VerifikasiLaporanAdminInitial extends VerifikasiLaporanAdminState {}

final class VerifikasiLaporanAdminLoading extends VerifikasiLaporanAdminState {}

final class VerifikasiLaporanAdminSuccess extends VerifikasiLaporanAdminState {}

final class VerifikasiLaporanAdminFailure extends VerifikasiLaporanAdminState {
  final String message;

  VerifikasiLaporanAdminFailure(this.message);
}
