part of 'report_user_bloc.dart';

@immutable
abstract class ReportUserEvent {}

class ReportUserSubmitRequested extends ReportUserEvent {
  final ReportStoreRequestModel requestModel;

  ReportUserSubmitRequested(this.requestModel);
}

class ReportUserResetRequested extends ReportUserEvent {}
