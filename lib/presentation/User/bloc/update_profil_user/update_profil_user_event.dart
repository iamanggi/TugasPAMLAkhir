part of 'update_profil_user_bloc.dart';


sealed class UpdateProfilUserEvent {}

final class GetProfilUserRequested extends UpdateProfilUserEvent {}

final class UpdateProfilUserRequested extends UpdateProfilUserEvent {
  final UserProfileUpdateRequestModel request;

  UpdateProfilUserRequested({required this.request});

}

final class ResetUpdateProfilUserState extends UpdateProfilUserEvent {}