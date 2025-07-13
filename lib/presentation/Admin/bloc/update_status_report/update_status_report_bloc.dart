import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:tilik_desa/data/model/request/admin/all_report_admin_request_model.dart';
import 'package:tilik_desa/data/repository/Admin/update_status_report_repository_admin.dart';


part 'update_status_report_event.dart';
part 'update_status_report_state.dart';

class UpdateStatusReportBloc extends Bloc<UpdateStatusReportEvent, UpdateStatusReportState> {
  final UpdateStatusRepository repository;

  UpdateStatusReportBloc(this.repository) : super(UpdateStatusReportInitial()) {
    on<SubmitUpdateStatusReport>((event, emit) async {
      emit(UpdateStatusReportLoading());

      final requestModel = UpdateStatusRequestModel(status: event.newStatus);

      final result = await repository.updateStatus(event.reportId, requestModel);

      result.fold(
        (error) => emit(UpdateStatusReportFailure(error)),
        (response) => emit(UpdateStatusReportSuccess(response.message)),
        
      );
    });
  }
}
