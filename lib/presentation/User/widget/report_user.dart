import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:tilik_desa/core/constants/colors.dart';
import 'package:tilik_desa/core/helpers/photo_manager.dart';
import 'package:tilik_desa/data/model/request/user/add_report_user_request_model.dart';
import 'package:tilik_desa/data/model/response/user/add_report_user_response_model.dart';
import 'package:tilik_desa/data/repository/User/add_report_user_repository.dart';

import 'package:tilik_desa/presentation/User/widget/riwayat_report_user.dart';
import 'package:tilik_desa/services/services_http_client.dart';
class ReportDraftModel {
  File? photo;
  double? latitude;
  double? longitude;
  String? locationDetail;
  String? fullAddress;
  String? description;
  String? category;
  int? categoryId;
  int?
  locationId; // This seems unused in the current flow, but kept for consistency
}

final reportDraft = ReportDraftModel();

void main() => runApp(
  MaterialApp(
    home: const CameraScreen(),
    theme: ThemeData(
      primarySwatch: Colors.blue,
      visualDensity: VisualDensity.adaptivePlatformDensity,
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          elevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        ),
      ),
    ),
  ),
);

class CameraScreen extends StatefulWidget {
  const CameraScreen({Key? key}) : super(key: key);

  @override
  State<CameraScreen> createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen> {
  final ImagePicker _picker = ImagePicker();
  bool _isProcessing = false;

  Future<void> _takePhoto() async {
    if (_isProcessing) return;

    setState(() => _isProcessing = true);

    try {
      final XFile? pickedFile = await _picker.pickImage(
        source: ImageSource.camera,
        maxWidth: 2048,
        maxHeight: 2048,
        imageQuality: 90,
      );

      if (pickedFile != null) {
        print('[CameraScreen] Photo taken: ${pickedFile.path}');
        _showProcessingDialog();
        final File? processedFile = await PhotoManager.processPhotoFromCamera(
          pickedFile,
        );
        Navigator.pop(context);

        if (processedFile != null) {
          final bool isValid = await PhotoManager.validatePhotoFile(
            processedFile,
          );

          if (isValid) {
            reportDraft.photo = processedFile;
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const LocationScreen()),
            );
          } else {
            _showErrorDialog('Foto tidak valid, silakan coba lagi');
          }
        } else {
          _showErrorDialog('Gagal memproses foto, silakan coba lagi');
        }
      }
    } catch (e) {
      Navigator.pop(context); // Close processing dialog if open
      _showErrorDialog('Error: $e');
    } finally {
      setState(() => _isProcessing = false);
    }
  }

  void _showProcessingDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder:
          (context) => AlertDialog(
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CircularProgressIndicator(),
                SizedBox(height: 16),
                Text('Memproses foto...'),
              ],
            ),
          ),
    );
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: Text('Error'),
            content: Text(message),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text('OK'),
              ),
            ],
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text(
          'Ambil Foto',
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        foregroundColor: Colors.black87,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 160,
                height: 160,
                decoration: BoxDecoration(
                  color: Colors.blue[50],
                  borderRadius: BorderRadius.circular(80),
                ),
                child: const Icon(
                  Icons.camera_alt_rounded,
                  size: 80,
                  color: Colors.blue,
                ),
              ),
              const SizedBox(height: 32),
              const Text(
                'Ambil Foto Kerusakan',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12),
              Text(
                'Foto akan digunakan sebagai bukti laporan kerusakan yang Anda temukan',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey[600],
                  height: 1.5,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 48),
              Container(
                width: double.infinity,
                height: 56,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      AppColors.primary,
                      AppColors.primary.withOpacity(0.8), // Gradasi lebih soft
                    ],
                  ),
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.primary.withOpacity(0.3),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: ElevatedButton.icon(
                  onPressed: _isProcessing ? null : _takePhoto,
                  icon:
                      _isProcessing
                          ? SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                          : Icon(Icons.camera_alt_rounded, color: Colors.white),
                  label: Text(
                    _isProcessing ? 'Memproses...' : 'Buka Kamera',
                    style: TextStyle(color: Colors.white),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.transparent,
                    shadowColor: Colors.transparent,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class LocationScreen extends StatefulWidget {
  const LocationScreen({Key? key}) : super(key: key);

  @override
  State<LocationScreen> createState() => _LocationScreenState();
}

class _LocationScreenState extends State<LocationScreen> {
  final TextEditingController _locationDetailController =
      TextEditingController();
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _getLocation();
  }

  @override
  void dispose() {
    _locationDetailController.dispose();
    super.dispose();
  }

  Future<void> _getLocation() async {
    try {
      setState(() => _isLoading = true);
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        _showErrorDialog('Layanan lokasi tidak aktif');
        return;
      }
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          _showErrorDialog('Izin lokasi ditolak');
          return;
        }
      }
      if (permission == LocationPermission.deniedForever) {
        _showErrorDialog('Izin lokasi ditolak secara permanen');
        return;
      }
      final position = await Geolocator.getCurrentPosition();
      try {
        List<Placemark> placemarks = await placemarkFromCoordinates(
          position.latitude,
          position.longitude,
        );
        if (placemarks.isNotEmpty) {
          final place = placemarks[0];
          final fullAddress = [
                place.street,
                place.subLocality,
                place.locality,
                place.subAdministrativeArea,
                place.administrativeArea,
                place.postalCode,
              ]
              .where((element) => element != null && element.isNotEmpty)
              .join(', ');
          reportDraft.fullAddress = fullAddress;
        }
      } catch (e) {
        print('Error getting address: $e');
      }
      setState(() {
        reportDraft.latitude = position.latitude;
        reportDraft.longitude = position.longitude;
        reportDraft.locationId = 1; // Assuming a default location ID for now
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
      _showErrorDialog('Gagal mengambil lokasi: $e');
    }
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            title: const Text('Error'),
            content: Text(message),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('OK'),
              ),
            ],
          ),
    );
  }

  void _navigateToDetailReport() {
    if (_locationDetailController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Mohon isi detail alamat'),
          backgroundColor: Colors.red,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      );
      return;
    }
    reportDraft.locationDetail = _locationDetailController.text.trim();
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const DetailReportScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text(
          'Lokasi',
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        foregroundColor: Colors.black87,
      ),
      body:
          _isLoading
              ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 80,
                      height: 80,
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.blue[50],
                        borderRadius: BorderRadius.circular(40),
                      ),
                      child: const CircularProgressIndicator(strokeWidth: 3),
                    ),
                    const SizedBox(height: 24),
                    const Text(
                      "Mengambil lokasi...",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              )
              : SingleChildScrollView(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (reportDraft.photo != null) ...[
                      Container(
                        width: double.infinity,
                        height: 200,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              blurRadius: 10,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(16),
                          child: Image.file(
                            reportDraft.photo!,
                            width: double.infinity,
                            height: 200,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),
                    ],
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.08),
                            blurRadius: 10,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: Colors.red[50],
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: const Icon(
                                  Icons.location_on,
                                  color: Colors.red,
                                  size: 20,
                                ),
                              ),
                              const SizedBox(width: 12),
                              const Text(
                                'Lokasi Terdeteksi',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: Colors.grey[50],
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: Colors.grey[200]!),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                if (reportDraft.fullAddress != null) ...[
                                  Text(
                                    'Alamat:',
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.grey[600],
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    reportDraft.fullAddress!,
                                    style: const TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  const SizedBox(height: 12),
                                ],
                                Text(
                                  'Koordinat:',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey[600],
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  '${reportDraft.latitude?.toStringAsFixed(6) ?? "-"}, ${reportDraft.longitude?.toStringAsFixed(6) ?? "-"}',
                                  style: const TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.08),
                            blurRadius: 10,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: Colors.blue[50],
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: const Icon(
                                  Icons.edit_location,
                                  color: Colors.blue,
                                  size: 20,
                                ),
                              ),
                              const SizedBox(width: 12),
                              const Text(
                                'Detail Alamat',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          TextFormField(
                            controller: _locationDetailController,
                            decoration: InputDecoration(
                              hintText:
                                  'Contoh: Jl. Sudirman No. 123, RT 01/RW 02',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide(
                                  color: Colors.grey[300]!,
                                ),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide(
                                  color: Colors.grey[300]!,
                                ),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: const BorderSide(
                                  color: Colors.blue,
                                  width: 2,
                                ),
                              ),
                              filled: true,
                              fillColor: Colors.grey[50],
                              contentPadding: const EdgeInsets.all(16),
                            ),
                            maxLines: 3,
                            style: const TextStyle(fontSize: 14),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 32),
                    Container(
                      width: double.infinity,
                      height: 56,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            AppColors.primary,
                            AppColors.primary.withOpacity(
                              0.8,
                            ), // Gradasi lebih soft
                          ],
                        ),
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.primary.withOpacity(0.3),
                            blurRadius: 12,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: ElevatedButton.icon(
                        onPressed: _navigateToDetailReport,
                        icon: const Icon(
                          Icons.arrow_forward_rounded,
                          color: Colors.white,
                        ),
                        label: const Text(
                          'Lanjutkan',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.transparent,
                          shadowColor: Colors.transparent,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
    );
  }
}

class DetailReportScreen extends StatefulWidget {
  const DetailReportScreen({Key? key}) : super(key: key);

  @override
  State<DetailReportScreen> createState() => _DetailReportScreenState();
}

class _DetailReportScreenState extends State<DetailReportScreen> {
  final TextEditingController _descriptionController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  List<CategoryData> _categories = []; // Use CategoryData from response model
  bool _isLoadingCategories = true;
  String? _selectedCategoryName;
  int? _selectedCategoryId;
  final ReportRepository _reportRepository = ReportRepository(
    ServiceHttpClient(),
  );

  @override
  void initState() {
    super.initState();
    _loadCategories();
  }

  @override
  void dispose() {
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _loadCategories() async {
    setState(() => _isLoadingCategories = true);
    try {
      final result =
          await _reportRepository.getCategories(); // Use ReportRepository
      result.fold(
        (error) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Gagal memuat kategori: $error'),
              backgroundColor: Colors.red,
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          );
          setState(() {
            _categories = [];
            _isLoadingCategories = false;
          });
        },
        (categories) {
          final activeCategories =
              categories.where((category) {
                return category.isActive == true;
              }).toList();
          setState(() {
            _categories = activeCategories;
            _isLoadingCategories = false;
          });
          print('Total kategori: ${categories.length}');
          print('Kategori aktif: ${activeCategories.length}');
        },
      );
    } catch (e) {
      setState(() {
        _categories = [];
        _isLoadingCategories = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Gagal memuat kategori: $e'),
          backgroundColor: Colors.red,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      );
    }
  }

  IconData _getIconForCategory(String categoryName, int index) {
    final lowerName = categoryName.toLowerCase();
    if (lowerName.contains('jalan') || lowerName.contains('road')) {
      return Icons.add_road;
    } else if (lowerName.contains('air') || lowerName.contains('water')) {
      return Icons.water_drop;
    } else if (lowerName.contains('listrik') ||
        lowerName.contains('electric')) {
      return Icons.electrical_services;
    } else if (lowerName.contains('lampu') || lowerName.contains('light')) {
      return Icons.lightbulb;
    } else if (lowerName.contains('jembatan') || lowerName.contains('bridge')) {
      return Icons.roundabout_left;
    } else if (lowerName.contains('pipa') || lowerName.contains('plumbing')) {
      return Icons.plumbing;
    } else if (lowerName.contains('konstruksi') ||
        lowerName.contains('construction')) {
      return Icons.construction;
    } else if (lowerName.contains('peringatan') ||
        lowerName.contains('warning')) {
      return Icons.warning;
    } else if (lowerName.contains('perbaikan') ||
        lowerName.contains('repair')) {
      return Icons.build;
    } else if (lowerName.contains('lokasi') || lowerName.contains('location')) {
      return Icons.location_on;
    } else {
      final icons = [
        Icons.build,
        Icons.water_drop,
        Icons.electrical_services,
        Icons.lightbulb,
        Icons.add_road,
        Icons.construction,
        Icons.warning,
        Icons.plumbing,
        Icons.location_on,
        Icons.roundabout_left,
      ];
      return icons[index % icons.length];
    }
  }

  Color _getColorForCategory(String categoryName, int index) {
    final lowerName = categoryName.toLowerCase();
    if (lowerName.contains('jalan') || lowerName.contains('road')) {
      return Colors.orange;
    } else if (lowerName.contains('air') || lowerName.contains('water')) {
      return Colors.blue;
    } else if (lowerName.contains('listrik') ||
        lowerName.contains('electric')) {
      return Colors.amber;
    } else if (lowerName.contains('lampu') || lowerName.contains('light')) {
      return Colors.yellow;
    } else if (lowerName.contains('jembatan') || lowerName.contains('bridge')) {
      return Colors.teal;
    } else if (lowerName.contains('pipa') || lowerName.contains('plumbing')) {
      return Colors.indigo;
    } else if (lowerName.contains('konstruksi') ||
        lowerName.contains('construction')) {
      return Colors.purple;
    } else if (lowerName.contains('peringatan') ||
        lowerName.contains('warning')) {
      return Colors.red;
    } else if (lowerName.contains('perbaikan') ||
        lowerName.contains('repair')) {
      return Colors.green;
    } else if (lowerName.contains('lokasi') || lowerName.contains('location')) {
      return Colors.pink;
    } else {
      final colors = [
        Colors.blue,
        Colors.green,
        Colors.orange,
        Colors.purple,
        Colors.red,
        Colors.teal,
        Colors.indigo,
        Colors.amber,
        Colors.pink,
        Colors.cyan,
      ];
      return colors[index % colors.length];
    }
  }

  void _navigateToSummary() {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    if (_selectedCategoryId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Mohon pilih kategori kerusakan'),
          backgroundColor: Colors.red,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      );
      return;
    }
    reportDraft.description = _descriptionController.text.trim();
    reportDraft.category = _selectedCategoryName; // Store the name
    reportDraft.categoryId = _selectedCategoryId; // Store the ID
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const SummaryScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text(
          'Detail Laporan',
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        foregroundColor: Colors.black87,
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.08),
                      blurRadius: 10,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Colors.blue[50],
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Icon(
                            Icons.description,
                            color: Colors.blue,
                            size: 20,
                          ),
                        ),
                        const SizedBox(width: 12),
                        const Text(
                          'Deskripsi Kerusakan',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _descriptionController,
                      decoration: InputDecoration(
                        hintText: 'Jelaskan kerusakan yang Anda temukan...',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: Colors.grey[300]!),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: Colors.grey[300]!),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(
                            color: Colors.blue,
                            width: 2,
                          ),
                        ),
                        filled: true,
                        fillColor: Colors.grey[50],
                        contentPadding: const EdgeInsets.all(16),
                      ),
                      maxLines: 4,
                      style: const TextStyle(fontSize: 14),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Deskripsi kerusakan tidak boleh kosong';
                        }
                        if (value.trim().length < 10) {
                          return 'Deskripsi minimal 10 karakter';
                        }
                        return null;
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.08),
                      blurRadius: 10,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Colors.orange[50],
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Icon(
                            Icons.category,
                            color: Colors.orange,
                            size: 20,
                          ),
                        ),
                        const SizedBox(width: 12),
                        const Text(
                          'Kategori Kerusakan',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const Spacer(),
                        IconButton(
                          onPressed:
                              _isLoadingCategories ? null : _loadCategories,
                          icon:
                              _isLoadingCategories
                                  ? const SizedBox(
                                    width: 16,
                                    height: 16,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                    ),
                                  )
                                  : const Icon(Icons.refresh, size: 20),
                          tooltip: 'Refresh Kategori',
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    _isLoadingCategories
                        ? Container(
                          height: 120,
                          child: const Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                CircularProgressIndicator(),
                                SizedBox(height: 12),
                                Text('Memuat kategori aktif...'),
                              ],
                            ),
                          ),
                        )
                        : _categories.isEmpty
                        ? Container(
                          height: 120,
                          decoration: BoxDecoration(
                            color: Colors.grey[50],
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: Colors.grey[300]!),
                          ),
                          child: const Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.category_outlined,
                                  size: 48,
                                  color: Colors.grey,
                                ),
                                SizedBox(height: 8),
                                Text(
                                  'Belum ada kategori aktif tersedia',
                                  style: TextStyle(color: Colors.grey),
                                ),
                              ],
                            ),
                          ),
                        )
                        : GridView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                crossAxisSpacing: 12,
                                mainAxisSpacing: 12,
                                childAspectRatio: 2.5,
                              ),
                          itemCount: _categories.length,
                          itemBuilder: (context, index) {
                            final category = _categories[index];
                            final isSelected =
                                _selectedCategoryId == category.id;
                            return GestureDetector(
                              onTap: () {
                                setState(() {
                                  _selectedCategoryName = category.name;
                                  _selectedCategoryId = category.id;
                                });
                              },
                              child: Container(
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color:
                                      isSelected
                                          ? _getColorForCategory(
                                            category.name,
                                            index,
                                          ).withOpacity(0.1)
                                          : Colors.grey[50],
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(
                                    color:
                                        isSelected
                                            ? _getColorForCategory(
                                              category.name,
                                              index,
                                            )
                                            : Colors.grey[300]!,
                                    width: isSelected ? 2 : 1,
                                  ),
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      _getIconForCategory(category.name, index),
                                      color:
                                          isSelected
                                              ? _getColorForCategory(
                                                category.name,
                                                index,
                                              )
                                              : Colors.grey[600],
                                      size: 18,
                                    ),
                                    const SizedBox(width: 8),
                                    Expanded(
                                      child: Text(
                                        category.name,
                                        style: TextStyle(
                                          fontSize: 12,
                                          fontWeight:
                                              isSelected
                                                  ? FontWeight.w600
                                                  : FontWeight.w500,
                                          color:
                                              isSelected
                                                  ? _getColorForCategory(
                                                    category.name,
                                                    index,
                                                  )
                                                  : Colors.grey[600],
                                        ),
                                        overflow: TextOverflow.ellipsis,
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                  ],
                ),
              ),
              const SizedBox(height: 32),
              Container(
                width: double.infinity,
                height: 56,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      AppColors.primary,
                      AppColors.primary.withOpacity(0.8), // Gradasi lebih soft
                    ],
                  ),
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.primary.withOpacity(0.3),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: ElevatedButton.icon(
                  onPressed: _navigateToSummary,
                  icon: const Icon(
                    Icons.arrow_forward_rounded,
                    color: Colors.white,
                  ),
                  label: const Text(
                    'Lanjutkan',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.transparent,
                    shadowColor: Colors.transparent,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class SummaryScreen extends StatefulWidget {
  const SummaryScreen({Key? key}) : super(key: key);

  @override
  State<SummaryScreen> createState() => _SummaryScreenState();
}

class _SummaryScreenState extends State<SummaryScreen> {
  bool _isConfirmed = false;
  bool _isSubmitting = false;
  final ReportRepository _reportRepository = ReportRepository(
    ServiceHttpClient(),
  );

  Future<void> _submitReport() async {
    if (!_isConfirmed) {
      _showError('Mohon konfirmasi kebenaran data');
      return;
    }

    setState(() => _isSubmitting = true);

    try {
      if (!await PhotoManager.validatePhotoFile(reportDraft.photo)) {
        throw Exception('File foto tidak valid atau rusak');
      }

      print('[SubmitReport] Photo validation passed');
      print('[SubmitReport] File path: ${reportDraft.photo?.path}');
      print(
        '[SubmitReport] File size: ${await reportDraft.photo?.length()} bytes',
      );
      final request = ReportStoreRequestModel(
        title: 'Laporan Kerusakan',
        description: reportDraft.description ?? '',
        categoryId: reportDraft.categoryId ?? 0,
        photoPath: reportDraft.photo?.path,
        fullAddress: reportDraft.fullAddress,
        latitude: reportDraft.latitude,
        longitude: reportDraft.longitude,
        locationDetail: reportDraft.locationDetail,
        isUrgent: false,
      );
      final result = await _submitWithRetry(request);

      result.fold(
        (errorMessage) {
          print('[SubmitReport] Error: $errorMessage');
          _showError(errorMessage);
        },
        (reportData) async {
          print('[SubmitReport] Success: ${reportData.toString()}');
          await _sendNotificationToAdmin(reportData);
          
          _showSuccessDialog();
        },
      );
    } catch (e) {
      print('[SubmitReport] Exception: $e');
      _showError('Terjadi kesalahan: $e');
    } finally {
      setState(() => _isSubmitting = false);
    }
  }
  Future<void> _sendNotificationToAdmin(dynamic reportData) async {
    try {
      String reportId = reportData?.id?.toString() ?? 'Unknown';
      final notificationRequest = {
        'title': 'Laporan Baru',
        'message': 'Laporan kerusakan baru telah diterima dan menunggu verifikasi',
        'type': 'NEW_REPORT',
        'report_id': reportId,
        'category': reportDraft.category ?? 'Umum',
        'location': reportDraft.locationDetail ?? reportDraft.fullAddress ?? 'Lokasi tidak diketahui',
        'timestamp': DateTime.now().toIso8601String(),
      };
      final notificationResult = await _reportRepository.sendNotificationToAdmin(
        notificationRequest,
      );

      notificationResult.fold(
        (error) {
          print('[Notification] Error sending notification: $error');
        },
        (success) {
          print('[Notification] Successfully sent notification to admin');
        },
      );
    } catch (e) {
      print('[Notification] Exception sending notification: $e');
    }
  }

  Future<dynamic> _submitWithRetry(ReportStoreRequestModel request) async {
    int maxRetries = 3;
    int currentRetry = 0;

    while (currentRetry < maxRetries) {
      try {
        final result = await _reportRepository.createReport(request);
        return result;
      } catch (e) {
        currentRetry++;
        print('[SubmitReport] Retry $currentRetry/$maxRetries - Error: $e');

        if (currentRetry < maxRetries) {
          await Future.delayed(Duration(seconds: 2 * currentRetry));
        } else {
          rethrow;
        }
      }
    }
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.error, color: Colors.white),
            const SizedBox(width: 8),
            Expanded(child: Text(message)),
          ],
        ),
        backgroundColor: Colors.red,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        margin: const EdgeInsets.all(16),
      ),
    );
  }

  void _showSuccessDialog() {
    reportDraft.photo = null;
    reportDraft.description = null;
    reportDraft.category = null;
    reportDraft.categoryId = null;
    reportDraft.latitude = null;
    reportDraft.longitude = null;
    reportDraft.fullAddress = null;
    reportDraft.locationId = null;
    reportDraft.locationDetail = null;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        contentPadding: const EdgeInsets.all(24),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.green.shade50,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.check_circle,
                color: Colors.green,
                size: 48,
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              'Laporan Terkirim!',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            Text(
              'Laporan Anda berhasil dikirim dan admin telah mendapat notifikasi untuk verifikasi.',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey[700]),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (_) => RiwayatLaporanPage()),
                );
              },
              child: const Text('Lihat Riwayat Laporan'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _infoCard({
    required IconData icon,
    required String label,
    required String value,
    bool isLast = false,
  }) {
    return Container(
      margin: EdgeInsets.only(bottom: isLast ? 0 : 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.blue.shade50,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: Colors.blue, size: 16),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: Colors.grey[600],
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        title: const Text(
          'Konfirmasi Laporan',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        foregroundColor: Colors.black87,
        systemOverlayStyle: SystemUiOverlayStyle.dark,
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.05),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [
                          Row(
                            children: [
                              Icon(
                                Icons.assignment_outlined,
                                color: Colors.blue,
                              ),
                              SizedBox(width: 12),
                              Text(
                                'Ringkasan Laporan',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 4),
                          Text(
                            'Periksa kembali detail laporan sebelum mengirim',
                            style: TextStyle(fontSize: 14, color: Colors.grey),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                    if (reportDraft.photo != null)
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.05),
                              blurRadius: 10,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Padding(
                              padding: EdgeInsets.all(16),
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.image_outlined,
                                    color: Colors.blue,
                                  ),
                                  SizedBox(width: 8),
                                  Text(
                                    'Foto Laporan',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            ClipRRect(
                              borderRadius: const BorderRadius.only(
                                bottomLeft: Radius.circular(16),
                                bottomRight: Radius.circular(16),
                              ),
                              child: Image.file(
                                File(reportDraft.photo!.path),
                                width: double.infinity,
                                height: 200,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ],
                        ),
                      ),
                    const SizedBox(height: 20),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.05),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _infoCard(
                            icon: Icons.category_outlined,
                            label: 'Kategori',
                            value: reportDraft.category ?? '-',
                          ),
                          _infoCard(
                            icon: Icons.description_outlined,
                            label: 'Deskripsi',
                            value: reportDraft.description ?? '-',
                          ),
                          _infoCard(
                            icon: Icons.location_on_outlined,
                            label: 'Alamat',
                            value: reportDraft.fullAddress ?? '-',
                          ),
                          _infoCard(
                            icon: Icons.place_outlined,
                            label: 'Detail Lokasi',
                            value: reportDraft.locationDetail ?? '-',
                          ),
                          _infoCard(
                            icon: Icons.my_location_outlined,
                            label: 'Koordinat',
                            value: reportDraft.latitude != null &&
                                    reportDraft.longitude != null
                                ? '${reportDraft.latitude?.toStringAsFixed(6)}, ${reportDraft.longitude?.toStringAsFixed(6)}'
                                : '-',
                            isLast: true,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.05),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Transform.scale(
                            scale: 1.2,
                            child: Checkbox(
                              value: _isConfirmed,
                              onChanged: (val) => setState(
                                () => _isConfirmed = val ?? false,
                              ),
                              activeColor: Colors.blue,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(4),
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          const Expanded(
                            child: Text(
                              'Saya menyatakan data di atas sudah benar dan sesuai dengan kondisi di lapangan.',
                              style: TextStyle(fontSize: 14, height: 1.4),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.all(20),
              child: SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: _isSubmitting ? null : _submitReport,
                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                        _isConfirmed ? AppColors.primary : Colors.grey[300],
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  child: _isSubmitting
                      ? const SizedBox(
                          width: 24,
                          height: 24,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                      : const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.send, color: Colors.white),
                            SizedBox(width: 8),
                            Text(
                              'Kirim Laporan',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}