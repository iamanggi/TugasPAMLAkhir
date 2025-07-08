// File: pemeliharaan_admin_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

import 'package:tilik_desa/data/model/request/admin/pemeliharaan_admin_request_model.dart';
import 'package:tilik_desa/data/model/response/admin/pemeliharaan_admin_response_model.dart';
import 'package:tilik_desa/presentation/Admin/bloc/pemeliharaan_admin/pemeliharaan_admin_bloc.dart';
import 'package:tilik_desa/presentation/Admin/widget/add_pemeliharaan_admin_screen.dart';

class PemeliharaanAdminScreen extends StatefulWidget {
  const PemeliharaanAdminScreen({super.key});

  @override
  State<PemeliharaanAdminScreen> createState() => _PemeliharaanAdminScreenState();
}

class _PemeliharaanAdminScreenState extends State<PemeliharaanAdminScreen> {
  @override
  void initState() {
    super.initState();
    context.read<PemeliharaanAdminBloc>().add(GetPemeliharaanList());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text(
          'Kelola Pemeliharaan Fasilitas',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.teal,
        foregroundColor: Colors.white,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              context.read<PemeliharaanAdminBloc>().add(GetPemeliharaanList());
            },
          ),
        ],
      ),
      body: BlocBuilder<PemeliharaanAdminBloc, PemeliharaanAdminState>(
        builder: (context, state) {
          if (state is PemeliharaanLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is PemeliharaanListLoaded) {
            final data = state.data.data ?? [];

            if (data.isEmpty) {
              return const Center(child: Text('Belum ada data pemeliharaan.'));
            }

            return ListView.builder(
              itemCount: data.length,
              itemBuilder: (context, index) {
                final item = data[index];
                return ListTile(
                  title: Text(item.judul ?? '-'),
                  subtitle: Text(item.lokasi?.namaLokasi ?? '-'),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.edit),
                        onPressed: () {
                          context.read<PemeliharaanAdminBloc>().add(
                            GetPemeliharaanEditForm(item.id!),
                          );
                          Get.to(() => const PemeliharaanFormScreen(isEdit: true));
                        },
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete),
                        onPressed: () {
                          context.read<PemeliharaanAdminBloc>().add(
                            DeletePemeliharaan(item.id!),
                          );
                        },
                      ),
                    ],
                  ),
                );
              },
            );
          } else if (state is PemeliharaanFailure) {
            return Center(child: Text('Gagal memuat data: ${state.error}'));
          }
          return const SizedBox();
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          context.read<PemeliharaanAdminBloc>().add(GetPemeliharaanCreateForm());
          Get.to(() => const PemeliharaanFormScreen(isEdit: false));
        },
        label: const Text("Tambah Pemeliharaan"),
        icon: const Icon(Icons.add),
        backgroundColor: Colors.teal,
      ),
    );
  }
}
