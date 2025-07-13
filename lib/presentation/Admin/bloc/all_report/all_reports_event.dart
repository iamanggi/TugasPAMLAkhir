part of 'all_reports_bloc.dart';

@immutable
sealed class AllReportsEvent {}

final class FetchAllReports extends AllReportsEvent {}
