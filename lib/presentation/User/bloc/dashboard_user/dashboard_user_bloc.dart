import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:tilik_desa/data/model/response/user/dashboard_user_response_model.dart';
import 'package:tilik_desa/data/repository/User/dashboard_user_repository.dart';

part 'dashboard_user_event.dart';
part 'dashboard_user_state.dart';

class DashboardUserBloc extends Bloc<DashboardUserEvent, DashboardUserState> {
  final DashboardUserRepository dashboardUserRepository;
  static const FlutterSecureStorage _storage = FlutterSecureStorage();

  DashboardUserBloc({required this.dashboardUserRepository}) : super(DashboardUserInitial()) {
    on<LoadDashboardUser>(_onLoadDashboardUserData);
    on<LoadUserName>(_onLoadUserName);
  }

  Future<void> _onLoadDashboardUserData(
    LoadDashboardUser event,
    Emitter<DashboardUserState> emit,
  ) async {
    emit(DashboardUserLoading());
    
    try {
      final result = await dashboardUserRepository.getDashboardUser();
      result.fold(
        (error) => emit(DashboardUserError(error)),
        (data) => emit(DashboardUserLoaded(data)),
      );
    } catch (e) {
      emit(DashboardUserError("Terjadi kesalahan tidak terduga: ${e.toString()}"));
    }
  }

  Future<void> _onLoadUserName(
    LoadUserName event,
    Emitter<DashboardUserState> emit,
  ) async {
    try {
      final name = await _storage.read(key: "userName") ?? "Pengguna";
      emit(UserNameLoaded(name));
    } catch (e) {
      emit(DashboardUserError("Gagal memuat nama pengguna: ${e.toString()}"));
    }
  }

  // Optional: Method untuk clear data
  Future<void> clearUserData() async {
    try {
      await _storage.delete(key: "userName");
    } catch (e) {
      // Handle error silently atau log
    }
  }

  @override
  Future<void> close() {
    // Cleanup jika diperlukan
    return super.close();
  }
}