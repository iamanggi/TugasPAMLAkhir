part of 'update_status_report_bloc.dart';

@immutable
sealed class UpdateStatusReportEvent {}

final class SubmitUpdateStatusReport extends UpdateStatusReportEvent {
  final int reportId;
  final String newStatus;

  SubmitUpdateStatusReport({
    required this.reportId,
    required this.newStatus,
  });
  
}
