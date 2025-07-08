part of 'pemeliharaan_admin_bloc.dart';

sealed class PemeliharaanAdminState {}

final class PemeliharaanAdminInitial extends PemeliharaanAdminState {}

class PemeliharaanLoading extends PemeliharaanAdminState {}

class PemeliharaanListLoaded extends PemeliharaanAdminState {
  final PemeliharaanListResponseModel data;

  PemeliharaanListLoaded(this.data);
}

class PemeliharaanDetailLoaded extends PemeliharaanAdminState {
  final PemeliharaanResponseModel data;

  PemeliharaanDetailLoaded(this.data);
}

class PemeliharaanFormLoaded extends PemeliharaanAdminState {
  final PemeliharaanFormResponseModel form;

  PemeliharaanFormLoaded(this.form);
}

class PemeliharaanSuccess extends PemeliharaanAdminState {
  final String message;

  PemeliharaanSuccess(this.message);
}

class PemeliharaanFailure extends PemeliharaanAdminState {
  final String error;

  PemeliharaanFailure(this.error);
}