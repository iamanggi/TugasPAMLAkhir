import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';
import 'package:tilik_desa/data/model/response/admin/dashboard_admin_response_model.dart';
import 'package:tilik_desa/data/repository/Admin/dashboard_admin_repository.dart';

part 'dashboard_admin_event.dart';
part 'dashboard_admin_state.dart';

class DashboardAdminBloc extends Bloc<DashboardAdminEvent, DashboardAdminState> {
  final DashboardAdminRepository repository;

  DashboardAdminBloc({required this.repository}) : super(DashboardAdminInitial()) {
    on<LoadDashboardAdmin>(_onLoadDashboard);
    on<RefreshDashboardAdmin>(_onRefreshDashboard);
    on<LoadAdminStats>(_onLoadAdminStats);
    on<LoadReportsTrend>(_onLoadReportsTrend);
    on<LoadPriorityAreas>(_onLoadPriorityAreas);
  }

  Future<void> _onLoadDashboard(
    LoadDashboardAdmin event,
    Emitter<DashboardAdminState> emit,
  ) async {
    emit(DashboardAdminLoading());
    
    final result = await repository.getDashboardData();
    
    result.fold(
      (error) => emit(DashboardAdminError(error)),
      (dashboard) => emit(DashboardAdminLoaded(dashboard)),
    );
  }

  Future<void> _onRefreshDashboard(
    RefreshDashboardAdmin event,
    Emitter<DashboardAdminState> emit,
  ) async {
    // Emit refreshing state untuk menunjukkan bahwa sedang refresh
    // tapi tetap menampilkan data yang ada
    if (state is DashboardAdminLoaded) {
      emit(DashboardAdminRefreshing((state as DashboardAdminLoaded).dashboard));
    } else {
      emit(DashboardAdminLoading());
    }
    
    final result = await repository.refreshDashboard();
    
    result.fold(
      (error) {
        // Jika refresh gagal dan ada data sebelumnya, kembali ke loaded state
        if (state is DashboardAdminRefreshing) {
          final previousData = (state as DashboardAdminRefreshing).dashboard;
          emit(DashboardAdminLoaded(previousData));
          // Emit error sebagai event terpisah atau gunakan snackbar
          emit(DashboardAdminRefreshError(error, previousData));
        } else {
          emit(DashboardAdminError(error));
        }
      },
      (dashboard) => emit(DashboardAdminLoaded(dashboard)),
    );
  }

  Future<void> _onLoadAdminStats(
    LoadAdminStats event,
    Emitter<DashboardAdminState> emit,
  ) async {
    if (state is! DashboardAdminLoaded) {
      emit(DashboardAdminLoading());
    }
    
    final result = await repository.getAdminStats();
    
    result.fold(
      (error) => emit(DashboardAdminError(error)),
      (stats) {
        // Update state dengan stats baru jika diperlukan
        // Implementasi tergantung bagaimana Anda ingin menangani partial updates
        if (state is DashboardAdminLoaded) {
          final currentDashboard = (state as DashboardAdminLoaded).dashboard;
          // Buat dashboard baru dengan stats yang diupdate
          // final updatedDashboard = currentDashboard.copyWith(stats: stats);
          // emit(DashboardAdminLoaded(updatedDashboard));
        }
      },
    );
  }

  Future<void> _onLoadReportsTrend(
    LoadReportsTrend event,
    Emitter<DashboardAdminState> emit,
  ) async {
    final result = await repository.getReportsTrend();
    
    result.fold(
      (error) {
        // Handle error untuk reports trend secara spesifik
        if (state is DashboardAdminLoaded) {
          // Tetap di loaded state tapi bisa emit warning
          emit(DashboardAdminPartialError(
            error, 
            (state as DashboardAdminLoaded).dashboard,
            'reports_trend'
          ));
        } else {
          emit(DashboardAdminError(error));
        }
      },
      (trends) {
        // Update dashboard dengan trends baru
        if (state is DashboardAdminLoaded) {
          final currentDashboard = (state as DashboardAdminLoaded).dashboard;
          // Update dashboard dengan trends baru
          // final updatedDashboard = currentDashboard.copyWith(reportsTrend: trends);
          // emit(DashboardAdminLoaded(updatedDashboard));
        }
      },
    );
  }

  Future<void> _onLoadPriorityAreas(
    LoadPriorityAreas event,
    Emitter<DashboardAdminState> emit,
  ) async {
    final result = await repository.getPriorityAreas();
    
    result.fold(
      (error) {
        if (state is DashboardAdminLoaded) {
          emit(DashboardAdminPartialError(
            error, 
            (state as DashboardAdminLoaded).dashboard,
            'priority_areas'
          ));
        } else {
          emit(DashboardAdminError(error));
        }
      },
      (areas) {
        if (state is DashboardAdminLoaded) {
          final currentDashboard = (state as DashboardAdminLoaded).dashboard;
          // Update dashboard dengan priority areas baru
          // final updatedDashboard = currentDashboard.copyWith(priorityAreas: areas);
          // emit(DashboardAdminLoaded(updatedDashboard));
        }
      },
    );
  }

  // Method helper untuk retry
  void retry() {
    add(LoadDashboardAdmin());
  }

  // Method helper untuk refresh
  void refresh() {
    add(RefreshDashboardAdmin());
  }

  // Method untuk load specific data
  void loadStats() {
    add(LoadAdminStats());
  }

  void loadTrends() {
    add(LoadReportsTrend());
  }

  void loadPriorityAreas() {
    add(LoadPriorityAreas());
  }
}