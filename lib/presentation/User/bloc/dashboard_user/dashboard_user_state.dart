part of 'dashboard_user_bloc.dart';

sealed class DashboardUserState {}

final class DashboardUserInitial extends DashboardUserState {}

final class DashboardUserLoading extends DashboardUserState {}

final class DashboardUserLoaded extends DashboardUserState {
  final DashboardUserResponseModel dashboard;
  DashboardUserLoaded(this.dashboard);
}

final class DashboardUserError extends DashboardUserState {
  final String message;
  DashboardUserError(this.message);
}

final class UserNameLoaded extends DashboardUserState {
  final String name;
  UserNameLoaded(this.name);
}
