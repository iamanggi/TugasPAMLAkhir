// dashboard_admin_event.dart
part of 'dashboard_admin_bloc.dart';

@immutable
abstract class DashboardAdminEvent {}

/// Event untuk load dashboard admin pertama kali
class LoadDashboardAdmin extends DashboardAdminEvent {}

/// Event untuk refresh dashboard admin
class RefreshDashboardAdmin extends DashboardAdminEvent {}

/// Event untuk load admin statistics secara terpisah
class LoadAdminStats extends DashboardAdminEvent {}

/// Event untuk load reports trend secara terpisah
class LoadReportsTrend extends DashboardAdminEvent {}

/// Event untuk load reports by category
class LoadReportsByCategory extends DashboardAdminEvent {}

/// Event untuk load priority areas secara terpisah
class LoadPriorityAreas extends DashboardAdminEvent {}

/// Event untuk load recent reports
class LoadRecentReports extends DashboardAdminEvent {}

/// Event untuk load performance metrics
class LoadPerformanceMetrics extends DashboardAdminEvent {}

/// Event untuk retry ketika ada error
class RetryLoadDashboard extends DashboardAdminEvent {}

/// Event untuk clear error state
class ClearDashboardError extends DashboardAdminEvent {}