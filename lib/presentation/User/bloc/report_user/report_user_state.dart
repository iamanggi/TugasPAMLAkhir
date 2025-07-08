part of 'report_user_bloc.dart';

@immutable
abstract class ReportUserState {
  const ReportUserState();
}

class ReportUserInitial extends ReportUserState {}

class ReportUserSubmitting extends ReportUserState {}

class ReportUserSubmissionSuccess extends ReportUserState {
  final ReportData data;
  final String message;

  const ReportUserSubmissionSuccess({
    required this.data,
    required this.message,
  });
}

class ReportUserSubmissionFailure extends ReportUserState {
  final String message;

  const ReportUserSubmissionFailure({required this.message});
}