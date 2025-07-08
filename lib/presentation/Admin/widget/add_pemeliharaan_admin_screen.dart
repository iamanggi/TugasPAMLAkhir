// File: pemeliharaan_form_screen.dart (Presentation Layer)

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geocoding/geocoding.dart';
import 'package:tilik_desa/data/model/request/admin/pemeliharaan_admin_request_model.dart';
import 'package:tilik_desa/presentation/Admin/bloc/pemeliharaan_admin/pemeliharaan_admin_bloc.dart';

class PemeliharaanFormScreen extends StatefulWidget {
  final bool isEdit;
  final int? id;

  const PemeliharaanFormScreen({super.key, required this.isEdit, this.id});

  @override
  State<PemeliharaanFormScreen> createState() => _PemeliharaanFormScreenState();
}

class _PemeliharaanFormScreenState extends State<PemeliharaanFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _judulController = TextEditingController();
  final TextEditingController _deskripsiController = TextEditingController();
  final TextEditingController _tanggalMulaiController = TextEditingController();
  final TextEditingController _tanggalSelesaiController = TextEditingController();
  final TextEditingController _catatanController = TextEditingController();
  File? _selectedImage;
  
  // Variables for location
  LatLng? _selectedLocation;
  String _selectedAddress = '';
  int? _selectedLokasiId;
  
  // Status dropdown
  String? _selectedStatus;
  final List<String> _statusOptions = [
    'Belum Dimulai',
    'Sedang Berlangsung',
    'Selesai',
    'Ditunda',
    'Dibatalkan',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: Text(
          widget.isEdit ? 'Edit Pemeliharaan' : 'Tambah Pemeliharaan',
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.white,
        foregroundColor: Colors.teal[700],
        elevation: 0,
        shadowColor: Colors.transparent,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(
            height: 1,
            color: Colors.grey[200],
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header Card
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Colors.teal[400]!, Colors.teal[600]!],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.teal.withOpacity(0.3),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(
                        widget.isEdit ? Icons.edit : Icons.add_circle_outline,
                        color: Colors.white,
                        size: 32,
                      ),
                      const SizedBox(height: 12),
                      Text(
                        widget.isEdit ? 'Edit Data Pemeliharaan' : 'Tambah Data Pemeliharaan',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        widget.isEdit 
                            ? 'Perbarui informasi pemeliharaan infrastruktur'
                            : 'Lengkapi form untuk menambah data pemeliharaan',
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.9),
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
                
                const SizedBox(height: 24),
                
                // Form Fields
                _buildFormSection(
                  title: 'Informasi Dasar',
                  icon: Icons.info_outline,
                  children: [
                    _buildTextField(
                      controller: _judulController,
                      label: 'Judul Pemeliharaan',
                      hint: 'Masukkan judul pemeliharaan',
                      icon: Icons.title,
                      validator: (value) => value == null || value.isEmpty ? 'Judul wajib diisi' : null,
                    ),
                    const SizedBox(height: 16),
                    _buildTextField(
                      controller: _deskripsiController,
                      label: 'Deskripsi',
                      hint: 'Jelaskan detail pemeliharaan',
                      icon: Icons.description,
                      maxLines: 3,
                      validator: (value) => value == null || value.isEmpty ? 'Deskripsi wajib diisi' : null,
                    ),
                  ],
                ),
                
                const SizedBox(height: 20),
                
                _buildFormSection(
                  title: 'Detail Lokasi & Waktu',
                  icon: Icons.location_on,
                  children: [
                    _buildLocationField(),
                    const SizedBox(height: 16),
                    _buildTextField(
                      controller: _tanggalMulaiController,
                      label: 'Tanggal Mulai',
                      hint: 'Pilih tanggal mulai',
                      icon: Icons.calendar_today,
                      readOnly: true,
                      onTap: () => _pickDate(true),
                      validator: (value) => value == null || value.isEmpty ? 'Tanggal mulai wajib diisi' : null,
                    ),
                    const SizedBox(height: 16),
                    _buildStatusDropdown(),
                  ],
                ),
                
                const SizedBox(height: 20),
                
                // Photo Upload Section
                _buildFormSection(
                  title: 'Foto Pemeliharaan',
                  icon: Icons.photo_camera,
                  children: [
                    _buildPhotoUploadWidget(),
                  ],
                ),
                
                const SizedBox(height: 32),
                
                // Submit Button
                SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton(
                    onPressed: _submitForm,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.teal[600],
                      foregroundColor: Colors.white,
                      elevation: 2,
                      shadowColor: Colors.teal.withOpacity(0.3),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          widget.isEdit ? Icons.update : Icons.save,
                          size: 20,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          widget.isEdit ? 'Update Data' : 'Simpan Data',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFormSection({
    required String title,
    required IconData icon,
    required List<Widget> children,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
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
                  color: Colors.teal.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  icon,
                  color: Colors.teal[600],
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              Text(
                title,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey[800],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          ...children,
        ],
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    String? Function(String?)? validator,
    TextInputType? keyboardType,
    bool readOnly = false,
    VoidCallback? onTap,
    int maxLines = 1,
  }) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        prefixIcon: Icon(icon, color: Colors.teal[600]),
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
          borderSide: BorderSide(color: Colors.teal[600]!, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.red, width: 2),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.red, width: 2),
        ),
        filled: true,
        fillColor: Colors.grey[50],
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        labelStyle: TextStyle(color: Colors.grey[600]),
        hintStyle: TextStyle(color: Colors.grey[400]),
      ),
      validator: validator,
      keyboardType: keyboardType,
      readOnly: readOnly,
      onTap: onTap,
      maxLines: maxLines,
    );
  }

  Widget _buildStatusDropdown() {
    return DropdownButtonFormField<String>(
      value: _selectedStatus,
      decoration: InputDecoration(
        labelText: 'Status',
        hintText: 'Pilih status pemeliharaan',
        prefixIcon: Icon(Icons.flag, color: Colors.teal[600]),
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
          borderSide: BorderSide(color: Colors.teal[600]!, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.red, width: 2),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.red, width: 2),
        ),
        filled: true,
        fillColor: Colors.grey[50],
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        labelStyle: TextStyle(color: Colors.grey[600]),
        hintStyle: TextStyle(color: Colors.grey[400]),
      ),
      items: _statusOptions.map((String status) {
        return DropdownMenuItem<String>(
          value: status,
          child: Text(status),
        );
      }).toList(),
      onChanged: (String? newValue) {
        setState(() {
          _selectedStatus = newValue;
        });
      },
      validator: (value) => value == null || value.isEmpty ? 'Status wajib dipilih' : null,
      dropdownColor: Colors.white,
      style: TextStyle(
        color: Colors.grey[800],
        fontSize: 16,
      ),
      icon: Icon(
        Icons.arrow_drop_down,
        color: Colors.teal[600],
      ),
    );
  }

  Widget _buildLocationField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GestureDetector(
          onTap: _openMapPicker,
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.grey[50],
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey[300]!),
            ),
            child: Row(
              children: [
                Icon(Icons.location_on, color: Colors.teal[600]),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Lokasi Pemeliharaan',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey[600],
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        _selectedAddress.isEmpty
                            ? 'Pilih lokasi dari peta'
                            : _selectedAddress,
                        style: TextStyle(
                          fontSize: 16,
                          color: _selectedAddress.isEmpty
                              ? Colors.grey[400]
                              : Colors.grey[800],
                        ),
                      ),
                    ],
                  ),
                ),
                Icon(
                  Icons.chevron_right,
                  color: Colors.grey[400],
                ),
              ],
            ),
          ),
        ),
        if (_selectedLocation != null)
          Padding(
            padding: const EdgeInsets.only(top: 8),
            child: Text(
              'Koordinat: ${_selectedLocation!.latitude.toStringAsFixed(6)}, ${_selectedLocation!.longitude.toStringAsFixed(6)}',
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey[600],
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildPhotoUploadWidget() {
    return GestureDetector(
      onTap: _pickImage,
      child: Container(
        width: double.infinity,
        height: 180,
        decoration: BoxDecoration(
          color: Colors.grey[50],
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: Colors.grey[300]!,
            style: BorderStyle.solid,
            width: 2,
          ),
        ),
        child: _selectedImage == null
            ? Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.teal.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(50),
                    ),
                    child: Icon(
                      Icons.cloud_upload,
                      size: 32,
                      color: Colors.teal[600],
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Pilih Foto',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey[700],
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Tap untuk memilih foto dari galeri',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[500],
                    ),
                  ),
                ],
              )
            : Stack(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Image.file(
                      _selectedImage!,
                      fit: BoxFit.cover,
                      width: double.infinity,
                      height: double.infinity,
                    ),
                  ),
                  Positioned(
                    top: 8,
                    right: 8,
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: Colors.red.withOpacity(0.8),
                        borderRadius: BorderRadius.circular(50),
                      ),
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            _selectedImage = null;
                          });
                        },
                        child: const Icon(
                          Icons.close,
                          color: Colors.white,
                          size: 16,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
      ),
    );
  }

  void _openMapPicker() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => MapPickerScreen(
          initialLocation: _selectedLocation,
        ),
      ),
    );

    if (result != null && result is Map) {
      setState(() {
        _selectedLocation = result['location'] as LatLng;
        _selectedAddress = result['address'] as String;
        _selectedLokasiId = result['lokasiId'] as int?;
      });
    }
  }

  Future<void> _getAddressFromLatLng(LatLng location) async {
    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(
        location.latitude,
        location.longitude,
      );

      if (placemarks.isNotEmpty) {
        final place = placemarks[0];
        setState(() {
          _selectedAddress = [
            place.street,
            place.subLocality,
            place.locality,
            place.administrativeArea,
            place.country,
          ].where((element) => element != null && element.isNotEmpty).join(', ');
        });
      }
    } catch (e) {
      print('Error getting address: $e');
      setState(() {
        _selectedAddress = 'Lokasi dipilih';
      });
    }
  }

  void _pickImage() async {
    final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _selectedImage = File(pickedFile.path);
      });
    }
  }

  void _pickDate(bool isStartDate) async {
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: Colors.teal[600]!,
              onPrimary: Colors.white,
              surface: Colors.white,
              onSurface: Colors.black,
            ),
          ),
          child: child!,
        );
      },
    );
    if (pickedDate != null) {
      final dateString = pickedDate.toIso8601String().split('T')[0];
      if (isStartDate) {
        _tanggalMulaiController.text = dateString;
      } else {
        _tanggalSelesaiController.text = dateString;
      }
    }
  }

  void _submitForm() {
    if (_formKey.currentState?.validate() ?? false) {
      if (_selectedLocation == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Lokasi wajib dipilih')),
        );
        return;
      }

      if (widget.isEdit && widget.id != null) {
        final updateRequest = UpdatePemeliharaanRequestModel(
          judul: _judulController.text,
          deskripsi: _deskripsiController.text,
          lokasiId: _selectedLokasiId ?? 1, // Default lokasi ID jika tidak ada
          tanggalMulai: _tanggalMulaiController.text,
          tanggalSelesai: _tanggalSelesaiController.text.isEmpty ? null : _tanggalSelesaiController.text,
          status: _selectedStatus!, // Menggunakan dropdown value
          catatan: _catatanController.text.isEmpty ? null : _catatanController.text,
        );

        context.read<PemeliharaanAdminBloc>().add(
          UpdatePemeliharaan(
            id: widget.id!,
            request: updateRequest,
            fotoFile: _selectedImage,
          ),
        );
      } else {
        final createRequest = CreatePemeliharaanRequestModel(
          judul: _judulController.text,
          deskripsi: _deskripsiController.text,
          lokasiId: _selectedLokasiId ?? 1, // Default lokasi ID jika tidak ada
          tanggalMulai: _tanggalMulaiController.text,
          tanggalSelesai: _tanggalSelesaiController.text.isEmpty ? null : _tanggalSelesaiController.text,
          status: _selectedStatus!, // Menggunakan dropdown value
          catatan: _catatanController.text.isEmpty ? null : _catatanController.text,
        );

        context.read<PemeliharaanAdminBloc>().add(
          CreatePemeliharaan(
            request: createRequest,
            fotoFile: _selectedImage,
          ),
        );
      }

      Get.back();
    }
  }

  @override
  void dispose() {
    _judulController.dispose();
    _deskripsiController.dispose();
    _tanggalMulaiController.dispose();
    _tanggalSelesaiController.dispose();
    _catatanController.dispose();
    super.dispose();
  }
}

// Map Picker Screen
class MapPickerScreen extends StatefulWidget {
  final LatLng? initialLocation;

  const MapPickerScreen({super.key, this.initialLocation});

  @override
  State<MapPickerScreen> createState() => _MapPickerScreenState();
}

class _MapPickerScreenState extends State<MapPickerScreen> {
  GoogleMapController? _controller;
  LatLng _selectedLocation = const LatLng(-7.7956, 110.3695); // Default: Yogyakarta
  String _selectedAddress = 'Menentukan alamat...';
  Set<Marker> _markers = {};

  @override
  void initState() {
    super.initState();
    if (widget.initialLocation != null) {
      _selectedLocation = widget.initialLocation!;
    }
    _updateMarker();
    _getAddressFromLatLng(_selectedLocation);
  }

  void _updateMarker() {
    setState(() {
      _markers = {
        Marker(
          markerId: const MarkerId('selected-location'),
          position: _selectedLocation,
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
          infoWindow: const InfoWindow(title: 'Lokasi Dipilih'),
        ),
      };
    });
  }

  // Generate a simple location ID based on coordinates
  int _generateLokasiId() {
    // Simple hash based on coordinates
    final lat = (_selectedLocation.latitude * 1000000).round();
    final lng = (_selectedLocation.longitude * 1000000).round();
    return (lat + lng).abs() % 10000; // Simple hash to generate ID
  }

  Future<void> _getAddressFromLatLng(LatLng location) async {
    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(
        location.latitude,
        location.longitude,
      );

      if (placemarks.isNotEmpty) {
        final place = placemarks[0];
        setState(() {
          _selectedAddress = [
            place.street,
            place.subLocality,
            place.locality,
            place.administrativeArea,
            place.country,
          ].where((element) => element != null && element.isNotEmpty).join(', ');
        });
      }
    } catch (e) {
      print('Error getting address: $e');
      setState(() {
        _selectedAddress = 'Lokasi dipilih';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pilih Lokasi'),
        backgroundColor: Colors.teal[600],
        foregroundColor: Colors.white,
        actions: [
          TextButton(
            onPressed: () {
              // Return data dengan format yang sesuai
              Navigator.pop(context, {
                'location': _selectedLocation,
                'address': _selectedAddress,
                'lokasiId': _generateLokasiId(), // Generate ID berdasarkan koordinat
              });
            },
            child: const Text(
              'Pilih',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
      body: Stack(
        children: [
          GoogleMap(
            onMapCreated: (GoogleMapController controller) {
              _controller = controller;
            },
            initialCameraPosition: CameraPosition(
              target: _selectedLocation,
              zoom: 15,
            ),
            markers: _markers,
            onTap: (LatLng location) {
              setState(() {
                _selectedLocation = location;
              });
              _updateMarker();
              _getAddressFromLatLng(location);
            },
            myLocationEnabled: true,
            myLocationButtonEnabled: true,
            mapType: MapType.normal,
          ),
          Positioned(
            bottom: 20,
            left: 20,
            right: 20,
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 10,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    'Lokasi Dipilih:',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    _selectedAddress,
                    style: const TextStyle(
                      fontSize: 12,
                      color: Colors.grey,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Lat: ${_selectedLocation.latitude.toStringAsFixed(6)}\nLng: ${_selectedLocation.longitude.toStringAsFixed(6)}',
                    style: const TextStyle(fontSize: 12),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Tap pada peta untuk memilih lokasi',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}