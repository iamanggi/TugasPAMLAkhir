part of 'update_status_report_bloc.dart';

@immutable
sealed class UpdateStatusReportState {}

final class UpdateStatusReportInitial extends UpdateStatusReportState {}

final class UpdateStatusReportLoading extends UpdateStatusReportState {}

final class UpdateStatusReportSuccess extends UpdateStatusReportState {
  final String message;

  UpdateStatusReportSuccess(this.message);
}

final class UpdateStatusReportFailure extends UpdateStatusReportState {
  final String error;

  UpdateStatusReportFailure(this.error);
}
