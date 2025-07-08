import 'dart:developer';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tilik_desa/data/model/request/user/add_report_user_request_model.dart';
import 'package:tilik_desa/data/model/response/user/add_report_user_response_model.dart';
import 'package:tilik_desa/data/repository/User/report_user_repository.dart';

part 'report_user_event.dart';
part 'report_user_state.dart';

class ReportUserBloc extends Bloc<ReportUserEvent, ReportUserState> {
  final ReportRepository reportRepository;

  ReportUserBloc({required this.reportRepository}) : super(ReportUserInitial()) {
    on<ReportUserSubmitRequested>(_onReportUserSubmitRequested);
    on<ReportUserResetRequested>(_onReportUserResetRequested);
  }

  Future<void> _onReportUserSubmitRequested(
    ReportUserSubmitRequested event,
    Emitter<ReportUserState> emit,
  ) async {
    try {
      emit(ReportUserSubmitting());
      
      log('Submitting report with data: ${event.requestModel.toMap()}');
      
      final result = await reportRepository.createReport(event.requestModel);
      
      result.fold(
        (failure) {
          log('Report submission failed: $failure');
          emit(ReportUserSubmissionFailure(message: failure));
        },
        (success) {
          log('Report submission success: ${success.id}');
          emit(ReportUserSubmissionSuccess(
            data: success,
            message: 'Laporan berhasil dikirim!',
          ));
        },
      );
    } catch (e) {
      log('Unexpected error in ReportUserBloc: $e');
      emit(const ReportUserSubmissionFailure(
        message: 'Terjadi kesalahan yang tidak terduga',
      ));
    }
  }

  void _onReportUserResetRequested(
    ReportUserResetRequested event,
    Emitter<ReportUserState> emit,
  ) {
    emit(ReportUserInitial());
  }
}