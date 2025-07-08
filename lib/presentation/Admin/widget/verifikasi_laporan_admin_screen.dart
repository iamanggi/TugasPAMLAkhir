import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tilik_desa/data/model/request/admin/verifikasi_laporan_admin_request_model.dart';
import 'package:tilik_desa/presentation/Admin/bloc/verifikasi_laporan_admin/verifikasi_laporan_admin_bloc.dart';

class VerifikasiLaporanAdminScreen extends StatefulWidget {
  final String laporanId;

  const VerifikasiLaporanAdminScreen({Key? key, required this.laporanId}) : super(key: key);

  @override
  State<VerifikasiLaporanAdminScreen> createState() => _VerifikasiLaporanAdminScreenState();
}

class _VerifikasiLaporanAdminScreenState extends State<VerifikasiLaporanAdminScreen> {
  bool? isAccepted;
  final TextEditingController alasanController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  void _submit(BuildContext context) {
    if (isAccepted == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Silakan pilih status terlebih dahulu.")),
      );
      return;
    }

    if (isAccepted == false && alasanController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Alasan wajib diisi jika ditolak.")),
      );
      return;
    }

    final request = VerifikasiLaporanRequestModel(
      isAccepted: isAccepted!,
      alasan: isAccepted! ? null : alasanController.text.trim(),
    );

    context.read<VerifikasiLaporanAdminBloc>().add(
          SubmitVerifikasiLaporanAdmin(
            laporanId: widget.laporanId,
            request: request,
          ),
        );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Verifikasi Laporan")),
      body: BlocConsumer<VerifikasiLaporanAdminBloc, VerifikasiLaporanAdminState>(
        listener: (context, state) {
          if (state is VerifikasiLaporanAdminSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("Laporan berhasil diverifikasi")),
            );
            Navigator.pop(context); // Kembali ke layar sebelumnya
          } else if (state is VerifikasiLaporanAdminFailure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text("Gagal: ${state.message}")),
            );
          }
        },
        builder: (context, state) {
          return Padding(
            padding: const EdgeInsets.all(16),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  DropdownButtonFormField<bool>(
                    value: isAccepted,
                    decoration: const InputDecoration(
                      labelText: "Status Verifikasi",
                      border: OutlineInputBorder(),
                    ),
                    items: const [
                      DropdownMenuItem(value: true, child: Text("Terima")),
                      DropdownMenuItem(value: false, child: Text("Tolak")),
                    ],
                    onChanged: (value) {
                      setState(() => isAccepted = value);
                    },
                    validator: (value) => value == null ? 'Wajib pilih status' : null,
                  ),
                  const SizedBox(height: 16),
                  if (isAccepted == false)
                    TextFormField(
                      controller: alasanController,
                      maxLines: 3,
                      decoration: const InputDecoration(
                        labelText: "Alasan Penolakan",
                        border: OutlineInputBorder(),
                      ),
                    ),
                  const SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: state is VerifikasiLaporanAdminLoading ? null : () => _submit(context),
                      child: state is VerifikasiLaporanAdminLoading
                          ? const CircularProgressIndicator(color: Colors.white)
                          : const Text("Kirim Verifikasi"),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
