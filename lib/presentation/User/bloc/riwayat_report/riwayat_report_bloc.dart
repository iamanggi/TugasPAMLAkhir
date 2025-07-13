import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:tilik_desa/data/model/request/user/riwayat_report_user_request_model.dart';
import 'package:tilik_desa/data/model/response/user/riwayat_report_response_user_model.dart';
import 'package:tilik_desa/data/repository/User/riwayat_report_user_repository.dart';


part 'riwayat_report_event.dart';
part 'riwayat_report_state.dart';

class RiwayatReportBloc extends Bloc<RiwayatReportEvent, RiwayatReportState> {
  final RiwayatReportRepository repository;

  RiwayatReportBloc(this.repository) : super(RiwayatReportInitial()) {
    on<FetchRiwayatReport>((event, emit) async {
      emit(RiwayatReportLoading());

      final request = RiwayatReportRequestModel(idUser: event.idUser);
      final result = await repository.getReportsByUser(request);

      result.fold(
        (error) => emit(RiwayatReportError(error)),
        (response) => emit(RiwayatReportLoaded(response.data)),
      );
    });
    on<DeleteRiwayatReport>((event, emit) async {
      emit(RiwayatReportLoading());

      try {
        final result = await repository.deleteReport(event.id);
        result.fold(
          (error) => emit(RiwayatReportError(error)),
          (_) async {
            final idUser = await repository.getUserIdFromStorage();
            add(FetchRiwayatReport(idUser));
          },
        );
      } catch (e) {
        emit( RiwayatReportError("Gagal menghapus laporan"));
      }
    });
  } 
}