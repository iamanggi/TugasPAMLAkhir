part of 'pemeliharaan_admin_bloc.dart';


sealed class PemeliharaanAdminEvent {}

class GetPemeliharaanList extends PemeliharaanAdminEvent {
  final PemeliharaanFilterRequestModel? filter;

  GetPemeliharaanList({this.filter});
}

/// Event untuk mengambil detail satu pemeliharaan
class GetPemeliharaanDetail extends PemeliharaanAdminEvent {
  final int id;

  GetPemeliharaanDetail(this.id);
}

/// Event untuk mengambil data form create
class GetPemeliharaanCreateForm extends PemeliharaanAdminEvent {}

/// Event untuk mengambil data form edit
class GetPemeliharaanEditForm extends PemeliharaanAdminEvent {
  final int id;

  GetPemeliharaanEditForm(this.id);
}

/// Event untuk membuat pemeliharaan baru
class CreatePemeliharaan extends PemeliharaanAdminEvent {
  final CreatePemeliharaanRequestModel request;
  final File? fotoFile;

  CreatePemeliharaan({required this.request, this.fotoFile});
}

/// Event untuk mengubah data pemeliharaan
class UpdatePemeliharaan extends PemeliharaanAdminEvent {
  final int id;
  final UpdatePemeliharaanRequestModel request;
  final File? fotoFile;

  UpdatePemeliharaan({
    required this.id,
    required this.request,
    this.fotoFile,
  });
}

class DeletePemeliharaan extends PemeliharaanAdminEvent {
  final int id;

  DeletePemeliharaan(this.id);
}
