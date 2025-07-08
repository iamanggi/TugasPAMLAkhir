part of 'update_profil_admin_dart_bloc.dart';

@immutable
sealed class UpdateProfilAdminDartEvent {}

class LoadProfilAdminEvent extends UpdateProfilAdminDartEvent {}

class UpdateProfilAdminEvent extends UpdateProfilAdminDartEvent {
  final AdminProfileUpdateRequestModel request;

  UpdateProfilAdminEvent(this.request);
}
