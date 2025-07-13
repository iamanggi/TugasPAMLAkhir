part of 'riwayat_report_bloc.dart';


sealed class RiwayatReportEvent {}

final class FetchRiwayatReport extends RiwayatReportEvent {
  final int idUser;

  FetchRiwayatReport(this.idUser);
}

class DeleteRiwayatReport extends RiwayatReportEvent {
  final int id;
  DeleteRiwayatReport(this.id);
}
