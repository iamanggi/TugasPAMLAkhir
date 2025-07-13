import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:tilik_desa/data/model/response/admin/all_report_response_admin_model.dart';
import 'package:tilik_desa/data/repository/Admin/all_report_admin_repository.dart';


part 'all_reports_event.dart';
part 'all_reports_state.dart';

class AllReportsBloc extends Bloc<AllReportsEvent, AllReportsState> {
  final AllReportRepository repository;

  AllReportsBloc(this.repository) : super(AllReportsInitial()) {
    on<FetchAllReports>((event, emit) async {
      emit(AllReportsLoading());

      final result = await repository.getAllReports();

      result.fold(
        (errorMessage) => emit(AllReportsError(errorMessage)),
        (data) => emit(AllReportsLoaded(data)),
      );
    });
  }
}
