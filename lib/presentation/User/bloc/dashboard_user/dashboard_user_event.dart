part of 'dashboard_user_bloc.dart';


sealed class DashboardUserEvent {}

class LoadDashboardUser extends DashboardUserEvent {}

class LoadUserName extends DashboardUserEvent {}

