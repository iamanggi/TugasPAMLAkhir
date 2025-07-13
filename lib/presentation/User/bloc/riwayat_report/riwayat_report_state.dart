part of 'riwayat_report_bloc.dart';

@immutable
sealed class RiwayatReportState {}

final class RiwayatReportInitial extends RiwayatReportState {}

final class RiwayatReportLoading extends RiwayatReportState {}

final class RiwayatReportLoaded extends RiwayatReportState {
  final List<Laporan> laporanList;

  RiwayatReportLoaded(this.laporanList);
}

final class RiwayatReportError extends RiwayatReportState {
  final String message;

  RiwayatReportError(this.message);
}
