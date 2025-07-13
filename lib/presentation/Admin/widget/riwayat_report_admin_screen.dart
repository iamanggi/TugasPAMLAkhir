import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tilik_desa/data/model/response/admin/all_report_response_admin_model.dart';
import 'package:tilik_desa/presentation/Admin/bloc/all_report/all_reports_bloc.dart';
import 'package:tilik_desa/presentation/Admin/widget/detail_report_admin_screen.dart';
import 'package:intl/intl.dart';

class AdminReportListPage extends StatelessWidget {
  const AdminReportListPage({super.key});

  Color _getStatusColor(String? status) {
    switch (status?.toLowerCase()) {
      case 'selesai':
        return const Color(0xFF06D6A0);
      case 'diproses':
        return const Color(0xFFFFB700);
      case 'ditolak':
        return const Color(0xFFEF476F);
      default:
        return const Color(0xFF8B5CF6);
    }
  }

  IconData _getStatusIcon(String? status) {
    switch (status?.toLowerCase()) {
      case 'selesai':
        return Icons.check_circle;
      case 'diproses':
        return Icons.sync;
      case 'ditolak':
        return Icons.cancel;
      default:
        return Icons.help_outline;
    }
  }

  String _formatDate(DateTime? date) {
    if (date == null) return '-';
    return DateFormat('dd MMM yyyy, HH:mm').format(date);
  }

  // Method untuk navigate ke detail dan handle hasil
  void _navigateToDetail(BuildContext context, Report report) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => ReportDetailAdminPage(report: report),
      ),
    );
    
    // Jika ada perubahan (result == true), refresh data
    if (result == true) {
      context.read<AllReportsBloc>().add(FetchAllReports());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F8FC),
      appBar: AppBar(
        title: const Text("Semua Laporan"),
        centerTitle: true,
        elevation: 0,
        actions: [
          // Tombol refresh manual
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              context.read<AllReportsBloc>().add(FetchAllReports());
            },
          ),
        ],
      ),
      body: BlocBuilder<AllReportsBloc, AllReportsState>(
        builder: (context, state) {
          if (state is AllReportsLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is AllReportsLoaded) {
            final List<Report> reports = state.reports;

            if (reports.isEmpty) {
              return const Center(child: Text("Belum ada laporan."));
            }

            return RefreshIndicator(
              onRefresh: () async {
                context.read<AllReportsBloc>().add(FetchAllReports());
              },
              child: ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: reports.length,
                itemBuilder: (context, index) {
                  final report = reports[index];
                  return Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 10,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        borderRadius: BorderRadius.circular(16),
                        onTap: () => _navigateToDetail(context, report),
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                report.title,
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  color: Color(0xFF1A1D29),
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                report.description,
                                style: const TextStyle(
                                  fontSize: 13,
                                  color: Color(0xFF6B7280),
                                ),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(height: 12),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                    decoration: BoxDecoration(
                                      color: _getStatusColor(report.status).withOpacity(0.1),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Row(
                                      children: [
                                        Icon(
                                          _getStatusIcon(report.status),
                                          size: 14,
                                          color: _getStatusColor(report.status),
                                        ),
                                        const SizedBox(width: 6),
                                        Text(
                                          report.status.toUpperCase(),
                                          style: TextStyle(
                                            fontSize: 11,
                                            fontWeight: FontWeight.w600,
                                            color: _getStatusColor(report.status),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Row(
                                    children: [
                                      const Icon(Icons.schedule, size: 14, color: Color(0xFF9CA3AF)),
                                      const SizedBox(width: 4),
                                      Text(
                                        _formatDate(report.createdAt),
                                        style: const TextStyle(
                                          fontSize: 11,
                                          color: Color(0xFF9CA3AF),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            );
          } else if (state is AllReportsError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Gagal memuat laporan: ${state.message}"),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      context.read<AllReportsBloc>().add(FetchAllReports());
                    },
                    child: const Text("Coba Lagi"),
                  ),
                ],
              ),
            );
          }

          return const SizedBox();
        },
      ),
    );
  }
}