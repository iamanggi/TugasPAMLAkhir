import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:tilik_desa/data/model/request/admin/verifikasi_laporan_admin_request_model.dart';
import 'package:tilik_desa/data/repository/Admin/verifikasi_laporan_admin_repository.dart';

part 'verifikasi_laporan_admin_event.dart';
part 'verifikasi_laporan_admin_state.dart';

class VerifikasiLaporanAdminBloc
    extends Bloc<VerifikasiLaporanAdminEvent, VerifikasiLaporanAdminState> {
  final LaporanRepository repository;

  VerifikasiLaporanAdminBloc({required this.repository})
      : super(VerifikasiLaporanAdminInitial()) {
    on<SubmitVerifikasiLaporanAdmin>(_onSubmitVerifikasi);
  }

  Future<void> _onSubmitVerifikasi(
    SubmitVerifikasiLaporanAdmin event,
    Emitter<VerifikasiLaporanAdminState> emit,
  ) async {
    emit(VerifikasiLaporanAdminLoading());
    try {
      await repository.verifikasiLaporan(event.laporanId, event.request);
      emit(VerifikasiLaporanAdminSuccess());
    } catch (e) {
      emit(VerifikasiLaporanAdminFailure(e.toString()));
    }
  }
}
