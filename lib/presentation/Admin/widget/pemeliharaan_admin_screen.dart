import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
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
    _loadData();
  }

  void _loadData() {
    try {
      context.read<PemeliharaanAdminBloc>().add(GetPemeliharaanList());
    } catch (e) {
      debugPrint('Error loading data: $e');
    }
  }

  void _showDeleteConfirmation(BuildContext context, int id) {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: const Text('Konfirmasi Hapus'),
          content: const Text('Apakah Anda yakin ingin menghapus data pemeliharaan ini?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(),
              child: const Text('Batal'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(dialogContext).pop();
                context.read<PemeliharaanAdminBloc>().add(DeletePemeliharaan(id));
                
                // Show loading and success feedback
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Menghapus data...'),
                    duration: Duration(seconds: 2),
                  ),
                );
                
                // Reload data after a short delay
                Future.delayed(const Duration(seconds: 1), () {
                  _loadData();
                });
              },
              style: TextButton.styleFrom(foregroundColor: Colors.red),
              child: const Text('Hapus'),
            ),
          ],
        );
      },
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.construction,
            size: 64,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 16),
          Text(
            'Belum ada data pemeliharaan',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w500,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Tambahkan data pemeliharaan baru',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[500],
            ),
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: () {
              try {
                context.read<PemeliharaanAdminBloc>().add(GetPemeliharaanCreateForm());
                Get.to(() => const PemeliharaanFormScreen(isEdit: false));
              } catch (e) {
                debugPrint('Error navigating to create form: $e');
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Gagal membuka form: ${e.toString()}'),
                    backgroundColor: Colors.red,
                  ),
                );
              }
            },
            icon: const Icon(Icons.add),
            label: const Text('Tambah Pemeliharaan'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.teal,
              foregroundColor: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState(String error) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.error_outline,
            size: 64,
            color: Colors.red[400],
          ),
          const SizedBox(height: 16),
          const Text(
            'Gagal memuat data',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.all(16),
            margin: const EdgeInsets.symmetric(horizontal: 32),
            decoration: BoxDecoration(
              color: Colors.red[50],
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.red[200]!),
            ),
            child: Text(
              error,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.red[700],
                fontSize: 14,
              ),
            ),
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: _loadData,
            icon: const Icon(Icons.refresh),
            label: const Text('Coba Lagi'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.teal,
              foregroundColor: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLoadingState() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(Colors.teal),
          ),
          SizedBox(height: 16),
          Text(
            'Memuat data...',
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildListItem(dynamic item, int index) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.all(16),
        leading: CircleAvatar(
          backgroundColor: Colors.teal[100],
          child: Icon(
            Icons.construction,
            color: Colors.teal[700],
          ),
        ),
        title: Text(
          item.judul ?? 'Tidak ada judul',
          style: const TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 16,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 4),
            Row(
              children: [
                Icon(
                  Icons.location_on,
                  size: 16,
                  color: Colors.grey[600],
                ),
                const SizedBox(width: 4),
                Expanded(
                  child: Text(
                    item.lokasi?.namaLokasi ?? 'Lokasi tidak tersedia',
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 14,
                    ),
                  ),
                ),
              ],
            ),
            if (item.tanggal != null) ...[
              const SizedBox(height: 4),
              Row(
                children: [
                  Icon(
                    Icons.calendar_today,
                    size: 16,
                    color: Colors.grey[600],
                  ),
                  const SizedBox(width: 4),
                  Text(
                    item.tanggal.toString(),
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ],
          ],
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: const Icon(Icons.edit),
              color: Colors.blue,
              tooltip: 'Edit',
              onPressed: item.id != null ? () {
                try {
                  context.read<PemeliharaanAdminBloc>().add(
                    GetPemeliharaanEditForm(item.id!),
                  );
                  Get.to(() => const PemeliharaanFormScreen(isEdit: true));
                } catch (e) {
                  debugPrint('Error navigating to edit form: $e');
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Gagal membuka form edit: ${e.toString()}'),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
              } : null,
            ),
            IconButton(
              icon: const Icon(Icons.delete),
              color: Colors.red,
              tooltip: 'Hapus',
              onPressed: item.id != null ? () {
                _showDeleteConfirmation(context, item.id!);
              } : null,
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text(
          'Kelola Pemeliharaan Fasilitas',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        backgroundColor: Colors.teal,
        foregroundColor: Colors.white,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            tooltip: 'Refresh Data',
            onPressed: _loadData,
          ),
        ],
      ),
      body: BlocConsumer<PemeliharaanAdminBloc, PemeliharaanAdminState>(
        listener: (context, state) {
          if (state is PemeliharaanFailure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Error: ${state.error}'),
                backgroundColor: Colors.red,
              ),
            );
          }
        },
        builder: (context, state) {
          if (state is PemeliharaanLoading) {
            return _buildLoadingState();
          } else if (state is PemeliharaanListLoaded) {
            final data = state.data?.data ?? [];
            
            if (data.isEmpty) {
              return _buildEmptyState();
            }

            return RefreshIndicator(
              onRefresh: () async {
                _loadData();
              },
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(vertical: 8),
                itemCount: data.length,
                itemBuilder: (context, index) {
                  final item = data[index];
                  return _buildListItem(item, index);
                },
              ),
            );
          } else if (state is PemeliharaanFailure) {
            return _buildErrorState(state.error);
          }
          
          return const SizedBox.shrink();
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          try {
            context.read<PemeliharaanAdminBloc>().add(GetPemeliharaanCreateForm());
            Get.to(() => const PemeliharaanFormScreen(isEdit: false));
          } catch (e) {
            debugPrint('Error navigating to create form: $e');
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Gagal membuka form: ${e.toString()}'),
                backgroundColor: Colors.red,
              ),
            );
          }
        },
        label: const Text(
          "Tambah Pemeliharaan",
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
        icon: const Icon(Icons.add),
        backgroundColor: Colors.teal,
        foregroundColor: Colors.white,
      ),
    );
  }
}