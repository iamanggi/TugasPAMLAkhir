import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tilik_desa/data/model/response/admin/all_report_response_admin_model.dart';
import 'package:tilik_desa/presentation/Admin/bloc/update_status_report/update_status_report_bloc.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';

class ReportDetailAdminPage extends StatefulWidget {
  final Report report;

  const ReportDetailAdminPage({super.key, required this.report});

  @override
  State<ReportDetailAdminPage> createState() => _ReportDetailAdminPageState();
}

class _ReportDetailAdminPageState extends State<ReportDetailAdminPage> {
  late String selectedStatus;
  final statusOptions = ['baru', 'diproses', 'selesai', 'ditolak'];
  bool _isLocaleInitialized = false;

  @override
  void initState() {
    super.initState();
    selectedStatus = widget.report.status;
    _initializeLocale();
  }

  void _initializeLocale() async {
    await initializeDateFormatting('id_ID', null);
    if (mounted) {
      setState(() {
        _isLocaleInitialized = true;
      });
    }
  }

  void _submitUpdateStatus() {
    context.read<UpdateStatusReportBloc>().add(
      SubmitUpdateStatusReport(
        reportId: widget.report.id,
        newStatus: selectedStatus,
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'baru':
        return Colors.orange;
      case 'diproses':
        return Colors.blue;
      case 'selesai':
        return Colors.green;
      case 'ditolak':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  IconData _getStatusIcon(String status) {
    switch (status.toLowerCase()) {
      case 'baru':
        return Icons.fiber_new_rounded;
      case 'diproses':
        return Icons.hourglass_empty_rounded;
      case 'selesai':
        return Icons.check_circle_rounded;
      case 'ditolak':
        return Icons.cancel_rounded;
      default:
        return Icons.help_outline_rounded;
    }
  }

  String _formatDate(DateTime date) {
    try {
      final formatter = DateFormat('dd MMMM yyyy HH:mm', 'id_ID');
      return formatter.format(date);
    } catch (e) {
      final fallback = DateFormat('dd/MM/yyyy HH:mm');
      return fallback.format(date);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!_isLocaleInitialized) {
      return const Scaffold(
        backgroundColor: Colors.white,
        body: Center(child: CircularProgressIndicator()),
      );
    }

    final report = widget.report;
    final photoUrl = (report.photos != null && report.photos!.isNotEmpty)
        ? 'http://192.168.0.111:8888/Storage/${report.photos!.first}'
        : null;

    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.5,
        iconTheme: const IconThemeData(color: Colors.black87),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Detail Laporan',
              style: TextStyle(
                color: Colors.black87,
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: _getStatusColor(report.status),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                report.status.toUpperCase(),
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 11,
                  fontWeight: FontWeight.w500,
                ),
              ),
            )
          ],
        ),
      ),
      body: BlocListener<UpdateStatusReportBloc, UpdateStatusReportState>(
        listener: (context, state) {
          if (state is UpdateStatusReportSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Row(
                  children: [
                    const Icon(Icons.check_circle, color: Colors.white, size: 20),
                    const SizedBox(width: 8),
                    Text(state.message),
                  ],
                ),
                backgroundColor: Colors.green,
                behavior: SnackBarBehavior.floating,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                margin: const EdgeInsets.all(16),
              ),
            );
            Navigator.pop(context, true);
          } else if (state is UpdateStatusReportFailure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Row(
                  children: [
                    const Icon(Icons.error, color: Colors.white, size: 20),
                    const SizedBox(width: 8),
                    Expanded(child: Text(state.error)),
                  ],
                ),
                backgroundColor: Colors.red,
                behavior: SnackBarBehavior.floating,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                margin: const EdgeInsets.all(16),
              ),
            );
          }
        },
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Photo Display - similar to user version
              if (photoUrl != null)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: SizedBox(
                      height: 200,
                      width: double.infinity,
                      child: Image.network(
                        photoUrl,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) => Container(
                          decoration: BoxDecoration(
                            color: Colors.grey[200],
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: const Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.broken_image_rounded,
                                  size: 48,
                                  color: Colors.grey,
                                ),
                                SizedBox(height: 8),
                                Text(
                                  "Gagal memuat gambar",
                                  style: TextStyle(color: Colors.grey),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              
              Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Title
                    Text(
                      report.title,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    
                    // Report ID Card
                    Card(
                      child: ListTile(
                        leading: const Icon(Icons.receipt_long),
                        title: const Text("ID Laporan"),
                        subtitle: Text(report.id.toString()),
                      ),
                    ),
                    const SizedBox(height: 16),
                    
                    // Address Card
                    Card(
                      child: ListTile(
                        leading: const Icon(Icons.location_on),
                        title: const Text("Alamat"),
                        subtitle: Text(report.address),
                      ),
                    ),
                    const SizedBox(height: 16),
                    
                    // Description Card
                    Card(
                      child: ListTile(
                        leading: const Icon(Icons.description_outlined),
                        title: const Text("Deskripsi"),
                        subtitle: Text(report.description),
                      ),
                    ),
                    const SizedBox(height: 16),
                    
                    // Created At Card
                    if (report.createdAt != null)
                      Card(
                        child: ListTile(
                          leading: const Icon(Icons.calendar_today),
                          title: const Text("Tanggal Laporan"),
                          subtitle: Text(_formatDate(report.createdAt!)),
                        ),
                      ),
                    const SizedBox(height: 24),
                    
                    // Status Update Section
                    Card(
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                const Icon(Icons.edit_rounded, color: Colors.blue),
                                const SizedBox(width: 8),
                                const Text(
                                  'UPDATE STATUS',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),
                            DropdownButtonFormField<String>(
                              value: selectedStatus,
                              items: statusOptions.map((status) {
                                return DropdownMenuItem(
                                  value: status,
                                  child: Row(
                                    children: [
                                      Icon(
                                        _getStatusIcon(status),
                                        size: 16,
                                        color: _getStatusColor(status),
                                      ),
                                      const SizedBox(width: 8),
                                      Text(
                                        status.toUpperCase(),
                                        style: TextStyle(
                                          color: _getStatusColor(status),
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              }).toList(),
                              decoration: InputDecoration(
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 14,
                                ),
                                hintText: 'Pilih status',
                              ),
                              onChanged: (val) {
                                if (val != null) {
                                  setState(() => selectedStatus = val);
                                }
                              },
                            ),
                            const SizedBox(height: 16),
                            BlocBuilder<UpdateStatusReportBloc, UpdateStatusReportState>(
                              builder: (context, state) {
                                return SizedBox(
                                  width: double.infinity,
                                  child: ElevatedButton.icon(
                                    onPressed: state is UpdateStatusReportLoading 
                                        ? null 
                                        : _submitUpdateStatus,
                                    icon: state is UpdateStatusReportLoading
                                        ? const SizedBox(
                                            width: 16,
                                            height: 16,
                                            child: CircularProgressIndicator(
                                              strokeWidth: 2,
                                              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                                            ),
                                          )
                                        : const Icon(Icons.save_rounded, color: Colors.white,),
                                    label: Text(
                                      state is UpdateStatusReportLoading
                                          ? 'Memproses...'
                                          : 'Update Status',
                                    ),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.blue,
                                      foregroundColor: Colors.white,
                                      padding: const EdgeInsets.symmetric(vertical: 16),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}