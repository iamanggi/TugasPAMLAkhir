import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tilik_desa/data/model/request/user/profil_update_user_request_model.dart';
import 'package:tilik_desa/data/model/response/user/profil_update_user_response_model.dart';
import 'package:tilik_desa/data/repository/User/profil_update_user_repository.dart';

part 'update_profil_user_event.dart';
part 'update_profil_user_state.dart';

class UpdateProfilUserBloc extends Bloc<UpdateProfilUserEvent, UpdateProfilUserState> {
  final UserProfileRepository profileUpdateRepository;

  UpdateProfilUserBloc(this.profileUpdateRepository) : super(UpdateProfilUserInitial()) {
    on<GetProfilUserRequested>(_onGetProfilUserRequested);
    on<UpdateProfilUserRequested>(_onUpdateProfilUserRequested);
    on<ResetUpdateProfilUserState>(_onResetUpdateProfilUserState);
  }

  Future<void> _onGetProfilUserRequested(
    GetProfilUserRequested event,
    Emitter<UpdateProfilUserState> emit,
  ) async {
    try {
      emit(ProfilUserGetLoading());

      final result = await profileUpdateRepository.getProfile();

      result.fold(
        (error) {
          log("Error getting profile: $error");
          emit(ProfilUserGetError(message: error));
        },
        (profile) {
          log("Successfully got profile: ${profile.data?.nama}");
          emit(ProfilUserGetSuccess(profile: profile));
        },
      );
    } catch (e) {
      log("Exception in _onGetProfilUserRequested: $e");
      emit(ProfilUserGetError(message: "Terjadi kesalahan tak terduga"));
    }
  }

  Future<void> _onUpdateProfilUserRequested(
    UpdateProfilUserRequested event,
    Emitter<UpdateProfilUserState> emit,
  ) async {
    try {
      emit(UpdateProfilUserLoading());

      // Validasi password confirmation jika password diisi
      if (event.request.password != null && event.request.password!.isNotEmpty) {
        if (event.request.passwordConfirmation == null || 
            event.request.passwordConfirmation!.isEmpty) {
          emit(UpdateProfilUserError(message: "Konfirmasi password harus diisi"));
          return;
        }
        
        if (event.request.password != event.request.passwordConfirmation) {
          emit(UpdateProfilUserError(message: "Password dan konfirmasi password tidak cocok"));
          return;
        }
      }

      // Validasi nama tidak boleh kosong
      if (event.request.nama == null || event.request.nama!.trim().isEmpty) {
        emit(UpdateProfilUserError(message: "Nama tidak boleh kosong"));
        return;
      }

      final result = await profileUpdateRepository.updateProfile(event.request);

      result.fold(
        (error) {
          log("Error updating profile: $error");
          emit(UpdateProfilUserError(message: error));
        },
        (profile) {
          log("Successfully updated profile: ${profile.data?.nama}");
          final message = profile.message ?? "Profil berhasil diperbarui";
          emit(UpdateProfilUserSuccess(
            profile: profile,
            message: message,
          ));
        },
      );
    } catch (e) {
      log("Exception in _onUpdateProfilUserRequested: $e");
      emit(UpdateProfilUserError(message: "Terjadi kesalahan tak terduga"));
    }
  }

  void _onResetUpdateProfilUserState(
    ResetUpdateProfilUserState event,
    Emitter<UpdateProfilUserState> emit,
  ) {
    emit(UpdateProfilUserInitial());
  }
}