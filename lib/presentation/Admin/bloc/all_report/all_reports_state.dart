part of 'all_reports_bloc.dart';

@immutable
sealed class AllReportsState {}

final class AllReportsInitial extends AllReportsState {}

final class AllReportsLoading extends AllReportsState {}

final class AllReportsLoaded extends AllReportsState {
  final List<Report> reports; 
  AllReportsLoaded(this.reports);
}

final class AllReportsError extends AllReportsState {
  final String message;

  AllReportsError(this.message);
}
