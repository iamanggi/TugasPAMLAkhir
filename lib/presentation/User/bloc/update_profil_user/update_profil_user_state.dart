part of 'update_profil_user_bloc.dart';

sealed class UpdateProfilUserState {}

final class UpdateProfilUserInitial extends UpdateProfilUserState {}

final class UpdateProfilUserLoading extends UpdateProfilUserState {}

final class ProfilUserGetLoading extends UpdateProfilUserState {}

final class ProfilUserGetSuccess extends UpdateProfilUserState {
  final UserProfileUpdateResponseModel profile;

  ProfilUserGetSuccess({required this.profile});
}

final class UpdateProfilUserSuccess extends UpdateProfilUserState {
  final UserProfileUpdateResponseModel profile;
  final String message;

  UpdateProfilUserSuccess({required this.profile, required this.message});

}

final class UpdateProfilUserError extends UpdateProfilUserState {
  final String message;

  UpdateProfilUserError({required this.message});

}

final class ProfilUserGetError extends UpdateProfilUserState {
  final String message;

  ProfilUserGetError({required this.message});

}