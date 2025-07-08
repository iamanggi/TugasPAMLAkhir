import 'dart:async';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:tilik_desa/data/model/request/admin/pemeliharaan_admin_request_model.dart';
import 'package:tilik_desa/data/model/response/admin/pemeliharaan_admin_response_model.dart';
import 'package:tilik_desa/data/repository/Admin/pemeliharaan_admin_repository.dart';

part 'pemeliharaan_admin_event.dart';
part 'pemeliharaan_admin_state.dart';

class PemeliharaanAdminBloc extends Bloc<PemeliharaanAdminEvent, PemeliharaanAdminState> {
  final PemeliharaanRepository repository;

  PemeliharaanAdminBloc({required this.repository}) : super(PemeliharaanAdminInitial()) {
    on<GetPemeliharaanList>(_onGetPemeliharaanList);
    on<GetPemeliharaanDetail>(_onGetPemeliharaanDetail);
    on<GetPemeliharaanCreateForm>(_onGetPemeliharaanFormCreate);
    on<GetPemeliharaanEditForm>(_onGetPemeliharaanFormEdit);
    on<CreatePemeliharaan>(_onCreatePemeliharaan);
    on<UpdatePemeliharaan>(_onUpdatePemeliharaan);
    on<DeletePemeliharaan>(_onDeletePemeliharaan);
  }

  Future<void> _onGetPemeliharaanList(GetPemeliharaanList event, Emitter<PemeliharaanAdminState> emit) async {
    emit(PemeliharaanLoading());
    final result = await repository.getPemeliharaanList(filter: event.filter);
    result.fold(
      (error) => emit(PemeliharaanFailure(error)),
      (data) => emit(PemeliharaanListLoaded(data)),
    );
  }

  Future<void> _onGetPemeliharaanDetail(GetPemeliharaanDetail event, Emitter<PemeliharaanAdminState> emit) async {
    emit(PemeliharaanLoading());
    final result = await repository.getPemeliharaan(event.id);
    result.fold(
      (error) => emit(PemeliharaanFailure(error)),
      (data) => emit(PemeliharaanDetailLoaded(data)),
    );
  }

  Future<void> _onGetPemeliharaanFormCreate(GetPemeliharaanCreateForm event, Emitter<PemeliharaanAdminState> emit) async {
    emit(PemeliharaanLoading());
    final result = await repository.getCreateFormData();
    result.fold(
      (error) => emit(PemeliharaanFailure(error)),
      (data) => emit(PemeliharaanFormLoaded(data)),
    );
  }

  Future<void> _onGetPemeliharaanFormEdit(GetPemeliharaanEditForm event, Emitter<PemeliharaanAdminState> emit) async {
    emit(PemeliharaanLoading());
    final result = await repository.getEditFormData(event.id);
    result.fold(
      (error) => emit(PemeliharaanFailure(error)),
      (data) => emit(PemeliharaanFormLoaded(data)),
    );
  }

  Future<void> _onCreatePemeliharaan(CreatePemeliharaan event, Emitter<PemeliharaanAdminState> emit) async {
    emit(PemeliharaanLoading());
    final result = await repository.createPemeliharaan(event.request, fotoFile: event.fotoFile);
    result.fold(
      (error) => emit(PemeliharaanFailure(error)),
      (data) => emit(PemeliharaanSuccess("Berhasil menambahkan data pemeliharaan")),
    );
  }

  Future<void> _onUpdatePemeliharaan(UpdatePemeliharaan event, Emitter<PemeliharaanAdminState> emit) async {
    emit(PemeliharaanLoading());
    final result = await repository.updatePemeliharaan(event.id, event.request, fotoFile: event.fotoFile);
    result.fold(
      (error) => emit(PemeliharaanFailure(error)),
      (data) => emit(PemeliharaanSuccess("Berhasil memperbarui data pemeliharaan")),
    );
  }
  
  Future<void> _onDeletePemeliharaan(DeletePemeliharaan event, Emitter<PemeliharaanAdminState> emit) async {
  emit(PemeliharaanLoading());
  final result = await repository.deletePemeliharaan(event.id);
  result.fold(
    (error) => emit(PemeliharaanFailure(error)),
    (_) => emit(PemeliharaanSuccess("Berhasil menghapus data pemeliharaan")),
  );
}

}
