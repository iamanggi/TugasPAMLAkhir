part of 'update_profil_admin_dart_bloc.dart';

@immutable
sealed class UpdateProfilAdminDartState {}

class UpdateProfilAdminInitial extends UpdateProfilAdminDartState {}

class UpdateProfilAdminLoading extends UpdateProfilAdminDartState {}

class UpdateProfilAdminLoaded extends UpdateProfilAdminDartState {
  final AdminProfileUpdateResponseModel profile;

  UpdateProfilAdminLoaded(this.profile);
}

class UpdateProfilAdminSuccess extends UpdateProfilAdminDartState {
  final AdminProfileUpdateResponseModel response;

  UpdateProfilAdminSuccess(this.response);
}

class UpdateProfilAdminFailure extends UpdateProfilAdminDartState {
  final String message;

  UpdateProfilAdminFailure(this.message);
}
