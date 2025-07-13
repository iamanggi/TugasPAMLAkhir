part of 'update_profil_admin_dart_bloc.dart';

@immutable
sealed class UpdateProfilAdminDartEvent {}

class LoadProfilAdminEvent extends UpdateProfilAdminDartEvent {}

final class UpdateProfilAdminEvent extends UpdateProfilAdminDartEvent {
  final AdminProfileUpdateRequestModel request;

  UpdateProfilAdminEvent({required this.request});
}

final class ResetUpdateProfilAdminState extends UpdateProfilAdminDartEvent {}