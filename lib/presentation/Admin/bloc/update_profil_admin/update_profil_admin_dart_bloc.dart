import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:tilik_desa/data/model/request/admin/profil_update_admin_request_model.dart';
import 'package:tilik_desa/data/model/response/admin/profil_update_admin_response_model.dart';
import 'package:tilik_desa/data/repository/Admin/profil_update_admin_repository.dart';

part 'update_profil_admin_dart_event.dart';
part 'update_profil_admin_dart_state.dart';

class UpdateProfilAdminDartBloc extends Bloc<UpdateProfilAdminDartEvent, UpdateProfilAdminDartState> {
  final AdminProfileRepository repository;

  UpdateProfilAdminDartBloc(this.repository) : super(UpdateProfilAdminInitial()) {
    on<LoadProfilAdminEvent>(_onLoadProfile);
    on<UpdateProfilAdminEvent>(_onUpdateProfile);
  }

  Future<void> _onLoadProfile(
    LoadProfilAdminEvent event,
    Emitter<UpdateProfilAdminDartState> emit,
  ) async {
    emit(UpdateProfilAdminLoading());
    final result = await repository.getMyProfile();

    result.fold(
      (failure) => emit(UpdateProfilAdminFailure(failure)),
      (success) => emit(UpdateProfilAdminLoaded(success)),
    );
  }

  Future<void> _onUpdateProfile(
    UpdateProfilAdminEvent event,
    Emitter<UpdateProfilAdminDartState> emit,
  ) async {
    emit(UpdateProfilAdminLoading());
    final result = await repository.updateMyProfile(event.request);

    result.fold(
      (failure) => emit(UpdateProfilAdminFailure(failure)),
      (success) => emit(UpdateProfilAdminSuccess(success)),
    );
  }
}
