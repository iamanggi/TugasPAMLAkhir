// dashboard_admin_state.dart
part of 'dashboard_admin_bloc.dart';

@immutable
abstract class DashboardAdminState {}

/// State awal
class DashboardAdminInitial extends DashboardAdminState {}

/// State ketika sedang loading
class DashboardAdminLoading extends DashboardAdminState {}

/// State ketika data berhasil dimuat
class DashboardAdminLoaded extends DashboardAdminState {
  final DashboardAdminResponseModel dashboard;

  DashboardAdminLoaded(this.dashboard);

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is DashboardAdminLoaded && other.dashboard == dashboard;
  }

  @override
  int get hashCode => dashboard.hashCode;
}

/// State ketika sedang refresh (masih menampilkan data lama)
class DashboardAdminRefreshing extends DashboardAdminState {
  final DashboardAdminResponseModel dashboard;

  DashboardAdminRefreshing(this.dashboard);

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is DashboardAdminRefreshing && other.dashboard == dashboard;
  }

  @override
  int get hashCode => dashboard.hashCode;
}

/// State ketika terjadi error
class DashboardAdminError extends DashboardAdminState {
  final String message;

  DashboardAdminError(this.message);

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is DashboardAdminError && other.message == message;
  }

  @override
  int get hashCode => message.hashCode;
}

/// State ketika refresh gagal tapi masih ada data sebelumnya
class DashboardAdminRefreshError extends DashboardAdminState {
  final String message;
  final DashboardAdminResponseModel dashboard;

  DashboardAdminRefreshError(this.message, this.dashboard);

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is DashboardAdminRefreshError && 
           other.message == message && 
           other.dashboard == dashboard;
  }

  @override
  int get hashCode => message.hashCode ^ dashboard.hashCode;
}

/// State ketika ada error pada bagian tertentu tapi data lain masih ada
class DashboardAdminPartialError extends DashboardAdminState {
  final String message;
  final DashboardAdminResponseModel dashboard;
  final String failedSection;

  DashboardAdminPartialError(this.message, this.dashboard, this.failedSection);

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is DashboardAdminPartialError && 
           other.message == message && 
           other.dashboard == dashboard &&
           other.failedSection == failedSection;
  }

  @override
  int get hashCode => message.hashCode ^ dashboard.hashCode ^ failedSection.hashCode;
}

/// State ketika sedang loading bagian tertentu
class DashboardAdminPartialLoading extends DashboardAdminState {
  final DashboardAdminResponseModel dashboard;
  final String loadingSection;

  DashboardAdminPartialLoading(this.dashboard, this.loadingSection);

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is DashboardAdminPartialLoading && 
           other.dashboard == dashboard &&
           other.loadingSection == loadingSection;
  }

  @override
  int get hashCode => dashboard.hashCode ^ loadingSection.hashCode;
}